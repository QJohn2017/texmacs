
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : tmhtml.scm
;; DESCRIPTION : conversion of TeXmacs trees into Html trees
;; COPYRIGHT   : (C) 2002  Joris van der Hoeven, David Allouche
;;
;; This software falls under the GNU general public license and comes WITHOUT
;; ANY WARRANTY WHATSOEVER. See the file $TEXMACS_PATH/LICENSE for details.
;; If you don't have this file, write to the Free Software Foundation, Inc.,
;; 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (convert html tmhtml)
  (:use (convert tools tmconcat) (convert mathml tmmath)
	(convert tools stm) (convert tools tmlength) (convert tools tmtable)
	(convert tools sxml) (convert tools sxhtml)
	(convert html htmlout)))

(define tmhtml-env (make-ahash-table))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Empty handler and strings
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-noop l) '())

(define (cork->html s)
  (utf8->html (cork->utf8 s)))

(define (tmhtml-sub-token s pos)
  (substring s pos (- (string-length s) 1)))

(define (tmhtml-math-token s)
  (cond ((= (string-length s) 1)
	 (cond ((== s "*") " ")
	       ((== s "+") " + ")
	       ((== s "-") " - ")
	       ((char-alphabetic? (string-ref s 0)) `(h:i ,s))
	       (else s)))
	((string-starts? s "<b-") `(h:b (h:i ,(tmhtml-sub-token s 3))))
	((string-starts? s "<bbb-") `(h:u (h:b ,(tmhtml-sub-token s 5))))
	((string-starts? s "<cal-") `(h:u (h:i ,(tmhtml-sub-token s 5))))
	((string-starts? s "<frak-") `(h:u ,(tmhtml-sub-token s 6)))
	((string-starts? s "<")
	 (with encoded (cork->utf8 s)
	   (utf8->html (if (== s encoded)
			   (tm->xml-cdata s)
			   encoded))))
	(else s)))

(define (tmhtml-string s)
  (if (ahash-ref tmhtml-env :math)
      (tmhtml-post-simplify-nodes
       (map tmhtml-math-token (tmconcat-tokenize-math s)))
      (list (cork->html s))))

(define (tmhtml-text s)
  (if (ahash-ref tmhtml-env :math)
      (tmhtml-string s)
      (tmhtml-string (make-ligatures s))))

(define cork-endash (char->string (integer->char 21)))
(define cork-ldquo (char->string (integer->char 16)))
(define cork-rdquo (char->string (integer->char 17)))

(define (make-ligatures s)
  ;; Make texmacs ligatures in Cork encoding  
  (string-replace
   (string-replace
    (string-replace s "--" cork-endash) "``" cork-ldquo) "''" cork-rdquo))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Entire documents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-find-title doc)
  (cond ((func? doc 'tmdoc-title 1) (cadr doc))
	((func? doc 'tmdoc-title* 2) (cadr doc))
	((func? doc 'tmdoc-title** 3) (caddr doc))
	((npair? doc) #f)
	(else (with title (tmhtml-find-title (car doc))
		(if title title
		    (tmhtml-find-title (cdr doc)))))))

(define tmhtml-css-header
  (string-append "body { text-align: justify } "
		 ".title-block { width: 100%; text-align: center } "
		 ".title-block p { margin: 0px } "))

(define (tmhtml-file l)
  ;; This handler is special:
  ;; Since !file is a special node used only at the top of trees
  ;; it produces a single node, and not a nodeset like other handlers.
  (let* ((doc (car l))
	 (styles (cdadr l))
	 (lang (caddr l))
	 (tmpath (cadddr l))
	 (title (tmhtml-find-title doc))
	 (css `(h:style (@ (type "text/css")) ,tmhtml-css-header))
	 (body (tmhtml doc)))
    (set! title (cond ((not title) "No title")
		      ((or (in? "tmdoc" styles) (in? "tmweb" styles))
		       `(concat ,title " (FSF GNU project)"))
		      (else title)))
    (if (or (in? "tmdoc" styles) (in? "tmweb" styles) (in? "mmxdoc" styles))
	(with ss (if (in? "mmxdoc" styles)
		     "http://www.texmacs.org/css/mmxdoc.css"
		     "http://www.texmacs.org/css/tmdoc.css")
	  (set! css `(h:link (@ (rel "stylesheet")
				(href ,ss)
				(type "text/css"))))
	  (set! body (tmhtml-tmdoc-post body))))
    `(h:html
      (h:head
       (h:title ,@(tmhtml title))
       (h:meta (@ (name "generator")
		  (content ,(string-append "TeXmacs " (texmacs-version)))))
       ,css)
      (h:body ,@body))))

(define (tmhtml-finalize-document top)
  ;; @top must be a node produced by tmhtml-file
  "Prepare a XML document for serialization"
  (define xmlns-attrs
    '((xmlns "http://www.w3.org/1999/xhtml")
      (xmlns:m "http://www.w3.org/1998/Math/MathML")
      (xmlns:x "http://www.texmacs.org/2002/extensions")))
  `(*TOP* (*PI* xml "version=\"1.0\" encoding=\"UTF-8\"")
	  ,((cut sxml-set-attrs <> xmlns-attrs)
	    (sxml-strip-ns-prefix "h" (sxml-strip-ns-prefix "m" top)))))

(define (tmhtml-finalize-selection l)
  ;; @l is a nodeset produced by any handler _but_ tmhtml-file
  "Prepare a HTML node-set for serialization."
  `(*TOP* ,@(map (cut sxml-strip-ns-prefix "h" <>) l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Block structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-document-elem x)
  ;; NOTE: this should not really be necessary, but it improves
  ;; the layout of verbatim environments with a missing block structure
  (if (and (list-2? x)
	   (or (== (car x) 'verbatim) (== (car x) 'code))
	   (not (func? (cadr x) 'document)))
      (tmhtml (list (car x) (list 'document (cadr x))))
      (tmhtml x)))

(define (tmhtml-document l)
  (if (not (ahash-ref tmhtml-env :preformatted))
      (tmhtml-post-paragraphs
       (map (lambda (x) (cons 'h:p (tmhtml-document-elem x))) l))
      (tmhtml-post-simplify-nodes
       (list-concatenate
	((cut list-intersperse <> '("\n"))
	 (map tmhtml l))))))

(define (tmhtml-paragraph l)
  (let rec ((l l))
    (if (null? l) '()
	(let ((h (tmhtml (car l)))
	      (r (rec (cdr l))))
	  (cond ((null? h) r)		; correct when r is null too
		((null? r) h)
		(else `(,@h (h:br) ,@r)))))))

(define (tmhtml-post-paragraphs l)
  ;; Post process a collection of h:p elements
  ;;
  ;; If a h:p contains a h:hN, remove the h:p node and prepend the rest of the
  ;; contents to the next h:p. If the next element, after post processing is
  ;; not a h:p, create an intermediate h:p to hold the data.
  ;;
  ;; If a h:p contains a list element, remove the enclosing h:p. The TeXmacs
  ;; editor ensures that an <item-list> or <desc-list> is the only element
  ;; contained in its enclosing <doc-item>.
  ;;
  ;; If a h:p contains a h:pre element, remove the enclosing h:p. The VERBATIM
  ;; handler ensures that block VERBATIM and CODE environment are alone in the
  ;; paragraph.
  ;;
  ;; NOTE: assumes the heading is at the start of a paragraph. That is
  ;; consistent with the fact that (as of 2003-02-04) the only converted
  ;; invisible markup is <label> and correct usage requires it to be after the
  ;; section title.
  (let rec ((in l) (out '()) (trail #f))
    (let* ((para (and (pair? in) (car in)))
	   (cont (and para (sxml-content para)))
	   (first (and cont (pair? cont) (car cont)))
	   (next (lambda (o t) (rec (cdr in) o t)))
	   (flush (lambda () (if trail `((h:p ,@trail) ,@out) out)))
	   (accept (lambda () (if trail (sxml-prepend para trail) para)))
	   (give (lambda () (and (pair? (cdr cont)) (cdr cont)))))
      ;; invariant: (xor prev prev-trail)
      (cond ((null? in) (reverse (flush)))
	    ((or (null? cont) (string? first))
	     (next (cons (accept) out) #f))
	    ((sxhtml-heading? first)
	     ;; tmhtml-post-heading should be called by concat handler
	     (next (cons first (flush)) (give)))
	    ((sxhtml-list? first)
	     ;; texmacs editor ensures there is no trail after a list
	     (next (append cont (flush)) #f))
	    ((== 'h:pre (sxml-name first))
	     ;; handlers and editor ensure there is no trail after a h:pre
	     (next (append cont (flush)) #f))
	    ((and (sxhtml-table? first) (null? (cdr cont)))
	     ;; if table is not alone, we cannot help but produce bad html
	     ;; if table is alone, drop the enclosing <h:p>
	     (next (append cont (flush)) #f))
	    (else (next (cons (accept) out) #f))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Surrounding block structures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-force-document l)
  (cond ((func? l 'document) l)
	((func? l 'with)
	 (let* ((args (cDdr l))
		(r (cdr (tmhtml-force-document (cAr l)))))
	   (cond ((null? r) r)
		 ((null? (cdr r))
		  `(document (with ,@args ,(car r))))
		 ((null? (cddr r))
		  `(document (with ,@args ,(car r))
			     (with ,@args ,(cAr r))))
		 (else
		  `(document (with ,@args ,(car r))
			     (with ,@args (document ,@(cDdr r)))
			     (with ,@args ,(cAr r)))))))
	((func? l 'surround 3)
	 (let* ((left (cadr l))
		(right (caddr l))
		(r (cdr (tmhtml-force-document (cadddr l)))))
	   (cond ((null? r) r)
		 ((null? (cdr r))
		  `(document (concat ,left ,(car r) ,right)))
		 (else
		  `(document (concat ,left ,(car r))
			     ,@(cDdr r)
			     (concat ,(cAr r) ,right))))))
	(else `(document ,l))))

(define (tmhtml-surround l)
  (let* ((r1 (tmhtml-force-document `(surround ,@l)))
	 (r2 (tree->stree (tree-simplify (stree->tree r1)))))
    ;(display* "r0= " `(surround ,@l) "\n")
    ;(display* "r1= " r1 "\n")
    ;(display* "r2= " r2 "\n")
    (tmhtml r2)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Horizontal concatenations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-post-heading l)
  ;; Post-process the converted result of a concat containing a section title.
  ;;
  ;; Any label preceding the section is moved after it.
  ;;
  ;; The first label after the section is changed to an 'id' attribute in the
  ;; heading element, if it has not already an 'id' attribute.
  ;;
  ;; NOTE: assumes the heading is the first node (not counting labels)
  (receive (labels-before rest) (list-span l sxhtml-label?)
    (receive (heading rest) (car+cdr rest)
      (if (sxml-attr heading 'id)
	  `(,heading ,@labels-before ,@rest)
	  (receive (labels-after rest) (list-partition rest sxhtml-label?)
	    (let ((labels (append labels-before labels-after)))
	      (if (null? labels) l
		  (cons (sxml-prepend (sxhtml-glue-label heading (car labels))
				      (cdr labels))
			rest))))))))

(define (heading? l)
  (cond ((null? l) #f)
	((sxhtml-label? (car l)) (heading? (cdr l)))
	((sxhtml-heading? (car l)) #t)
	(else #f)))

(define (tmhtml-concat l)
  (set! l (tmconcat-structure-tabs l))
  (tmhtml-post-simplify-nodes
   (let ((l (tmhtml-list l)))
     (cond ((null? l) '())
	   ((string? (car l)) l)
	   ((heading? l) (tmhtml-post-heading l))
	   ((list-any sxhtml-table? l) (tmhtml-post-table l))
	   (else l)))))

(define (tmhtml-align-left l)
  (if (in? l '(() (""))) '()
      `((h:div (@ (style "text-align: left"))
	       ,@(tmhtml-concat l)))))

(define (tmhtml-align-middle l)
  (if (in? l '(() (""))) '()
      `((h:div (@ (style "text-align: center"))
	       ,@(tmhtml-concat l)))))

(define (tmhtml-align-right l)
  (if (in? l '(() (""))) '()
      `((h:div (@ (style "text-align: right"))
	       ,@(tmhtml-concat l)))))

(define (tmhtml-post-simplify-nodes l)
  ;; Catenate adjacent string nodes and remove empty string nodes
  (let rec ((l l))
    (cond ((null? l) '())
	  ((and (string? (car l)) (string-null? (car l)))
	   (rec (cdr l)))
	  ((null? (cdr l)) l)
	  ((and (string? (car l)) (string? (cadr l)))
	   (rec (cons (string-append (car l) (cadr l)) (cddr l))))
	  (else (cons (car l) (rec (cdr l)))))))

(define (tmhtml-post-simplify-element e)
  ;; Simplify the nodes of the element content
  (list (append (sxml-element-head e)
		(tmhtml-post-simplify-nodes (sxml-content e)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Formatting text
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-hspace l)
  '(" "))

(define (tmhtml-vspace l)
  '())

(define (tmhtml-move l)
  (tmhtml (car l)))

(define (tmhtml-resize l)
  (tmhtml (car l)))

(define (tmhtml-float l)
  (tmhtml (cAr l)))

(define (tmhtml-repeat l)
  (tmhtml (car l)))

(define (tmhtml-datoms l)
  (tmhtml (cAr l)))

(define (tmhtml-new-line l)
  '((h:br)))

(define (tmhtml-next-line l)
  '((h:br)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mathematics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-id l)
  (tmhtml (car l)))

(define (tmhtml-big l)
  (cond ((in? (car l) '("sum" "prod" "int" "oint" "amalg"))
	 (tmhtml (string-append "<" (car l) ">")))
	((in? (car l) '("<cap>" "<cup>" "<vee>" "<wedge>"))
	 (with s (substring (car l) 1 (- (string-length (car l)) 1))
	   (tmhtml (string-append "<big" s ">"))))
	((== (car l) ".") '())
	(else (tmhtml (car l)))))

(define (tmhtml-below l)
  `("below (" ,@(tmhtml (car l)) ", " ,@(tmhtml (cadr l)) ")"))

(define (tmhtml-above l)
  `("above (" ,@(tmhtml (car l)) ", " ,@(tmhtml (cadr l)) ")"))

(define (tmhtml-sub l)
  `((h:sub ,@(tmhtml (car l)))))

(define (tmhtml-sup l)
  `((h:sup ,@(tmhtml (car l)))))

(define (tmhtml-frac l)
  (let* ((num (tmhtml (car l)))
	 (den (tmhtml (cadr l))))
    `("frac (" ,@num ", " ,@den ")")))

;;(define (tmhtml-frac l)
;;  (let* ((num (tmhtml (car l)))
;;	   (den (tmhtml (cadr l)))
;;	   (n `(h:tr (h:td (@ (align "center")
;;			      (style "border-bottom: solid 1px")) ,@num)))
;;	   (d `(h:tr (h:td (@ (align "center")) ,@den)))
;;	   (in `(h:table (@ (style "position: relative; top: 3ex")) ,n ,d)))
;;   `((h:table (@ (style "display: inline")) (h:tr (h:td ,in))))))

(define (tmhtml-sqrt l)
  (if (= (length l) 1)
      `("sqrt (" ,@(tmhtml (car l)) ")")
      `("sqrt" (h:sub ,@(tmhtml (cadr l)))
	" (" ,@(tmhtml (car l)) ")")))

(define (tmhtml-wide l)
  `("(" ,@(tmhtml (car l)) ")" (h:sup ,@(tmhtml (cadr l)))))

(define (tmhtml-neg l)
  `("not(" ,@(tmhtml (car l)) ")"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Local and global environment changes
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-with-font-size val)
  (let* ((x (* (string->number val) 100))
	 (s (cond ((< x 1) "-4") ((< x 55) "-4") ((< x 65) "-3")
		  ((< x 75) "-2") ((< x 95) "-1") ((< x 115) "0")
		  ((< x 135) "+1") ((< x 155) "+2") ((< x 185) "+3")
		  ((< x 225) "+4") ((< x 500) "+5") (else "+5"))))
    (and s `(h:font (@ (size ,s))))))

(define (tmhtml-with-one var val arg)
  (if (== var "mode")
      ;; FIXME: should go into the DRD modulo some reorganization
      (ahash-with tmhtml-env :math (== val "math")
	(tmhtml arg))
      ;;`((h:class (@ ("style" "font-style: normal")) ,@r))))
      (let ((w (or (drd-ref tmhtml-with-cmd% (list var val))
		   (let ((h (drd-ref tmhtml-with-cmd% var)))
		     (and h (h val))))))
	(if w
	    (list (append w (tmhtml arg)))
	    (tmhtml arg)))))

(define (tmhtml-with l)
  (cond ((null? l) '())
	((null? (cdr l)) (tmhtml (car l)))
	((null? (cddr l)) '())
	(else
	 (let* ((var (force-string (car l)))
		(val (force-string (cadr l)))
		(next (cddr l)))
	   (tmhtml-with-one var val `(with ,@next))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other macro-related primitives
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-compound l)
  ;; Explicit expansions are converted and handled as implicit expansions.
  (tmhtml-implicit-compound (cons (string->symbol (car l)) (cdr l))))

(define (tmhtml-mark l)
  ;; Explicit expansions are converted and handled as implicit expansions.
  (tmhtml (cadr l)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Source code
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (blue sym)
  `(h:font (@ (color "blue")) ,sym))

(define (tmhtml-src-args l)
  (if (null? l) l
      `(,(blue "|")
	,@(tmhtml (car l))
	,@(tmhtml-src-args (cdr l)))))

(define (tmhtml-inline-tag l)
  `(,(blue "&lt;")
    ,@(tmhtml (car l))
    ,@(tmhtml-src-args (cdr l))
    ,(blue "&gt;")))

(define (tmhtml-open-tag l)
  `(,(blue "&lt;\\")
    ,@(tmhtml (car l))
    ,@(tmhtml-src-args (cdr l))
    ,(blue "|")))

(define (tmhtml-middle-tag l)
  `(,@(tmhtml-src-args (cdr l))
    ,(blue "|")))

(define (tmhtml-close-tag l)
  `(,@(tmhtml-src-args (cdr l))
    ,(blue "&gt;")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Other primitives
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-label l)
  ;; WARNING: bad conversion if ID is not a string.
  `((h:a (@ (id ,(cork->html (force-string (car l))))))))

;(define (tmhtml-reference l)
;  (list 'ref (cork->html (force-string (car l)))))

;(define (tmhtml-pageref l)
;  (list 'pageref (cork->html (force-string (car l)))))

(define (tmhtml-suffix s)
  ;; Change .html suffix to .tm suffix for local files for correct
  ;; conversion of entire web-sites. We might create an option
  ;; in order to disable this suffix change
  (let* ((sdir (string-rindex s #\/))
	 (sep (string-rindex s #\#)))
    (cond ((or (string-starts? s "http:") (string-starts? s "ftp:")) s)
          ((and sep (or (not sdir) (< sdir sep)))
	   (string-append (tmhtml-suffix (substring s 0 sep))
			  (string-drop s sep)))
	  ((string-ends? s ".tm")
	   (string-append (string-drop-right s 3) ".html"))
	  (else s))))

(define (tmhtml-hyperlink l)
  ;; WARNING: bad conversion if URI is not a string.
  ;; TODO: change label at start of content into ID attribute, move other
  ;; labels out (A elements cannot be nested!).
  (let* ((body (tmhtml (first l)))
	 (to (cork->html (force-string (second l)))))
    (if (string-starts? to "$")
	body ;; temporary fix for URLs like $TEXMACS_PATH/...
	`((h:a (@ (href ,(tmhtml-suffix to))) ,@body)))))

(define (tmhtml-specific l)
  (if (== (car l) "html") (tmhtml (cadr l)) '()))

(define (tmhtml-action l)
  `((h:u ,@(tmhtml (car l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Tables
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-table-cols p)
  (map (lambda (x)
	 `(h:col (@ (align ,(cadr (assoc x '(("l" "left")
					     ("c" "center")
					     ("r" "right"))))))))
       (p 'cols 'halign)))

(define (tmhtml-table-contents p)
  (define (cell x)
    `(h:td ,@(tmhtml x)))
  (define (row l)
    `(h:tr ,@(map cell l)))
  (map row (p 'rows 'content)))

(define (tmhtml-table-make p)
  `((h:table
     (@ ,@(if (p 'global 'border)
	      '((border "1")) 
	      '((style "display: inline"))))
     ,@(tmhtml-table-cols p)
     (h:tbody ,@(tmhtml-table-contents p)))))

(define (tmhtml-table halign border x)
  ;; assert (= 1 (length x))
  ;; assert (or (func? (car x) 'tformat) (func? (car x) 'table))
  (let ((p (tmtable-parser `(tformat ,@(tmtable-cell-halign halign)
				     ,@(tmtable-block-borders border)
				     ,(car x)))))
    (if p (tmhtml-table-make p) '())))

(define (tmhtml-post-table l)
  ;; Post process the converted result of a concat containing a table.
  ;;
  ;; If a label is adjacent to the table, use it to set the table id. If there
  ;; are several labels adjacent to the table, leave all but one label
  ;; untouched. There is no guarantee on which label is glued.
  (define (glue-label-to-table x knil)
    (cond ((null? knil) (list x))
	  ((and (sxhtml-label? x)
		(sxhtml-table? (car knil))
		(not (sxml-attr (car knil) 'id)))
	   (cons (sxhtml-glue-label (car knil) x)
		 (cdr knil)))
	  ((and (sxhtml-table? x)
		(not (sxml-attr x 'id))
		(sxhtml-label? (car knil)))
	   (cons (sxhtml-glue-label x (car knil))
		 (cdr knil)))
	  (else (cons x knil))))
  (list-fold-right glue-label-to-table '() l))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Pictures
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; WARNING: Should also test that width and height are not magnifications.
;; Currently, magnifications make string->tmlength return #f.

(define (tmhtml-dimension-attr s name handlers)
  (let ((w (and-let* ((tmlen (string->tmlength s))
		      ((not (tmlength-null? tmlen)))
		      (proc (assoc (tmlength-unit tmlen) handlers)))
		     ((second proc) (tmlength-value tmlen)))))
    (if w `((,name ,w)) '())))

(define (exact-number->string x)
  (number->string (inexact->exact x)))
(define (number->percent x)
  (string-append (exact-number->string (* 100 x)) "%"))

(define (tmhtml-postscript l)
  (let ((s (first l)) (w (second l)) (h (third l)))
    (if (nstring? s) '()	; only convert linked images
	`((h:img (@ (src ,(cork->html s))
		    ,@(tmhtml-dimension-attr
		       w 'width `((par ,number->percent)
				  (px ,exact-number->string)))
		    ,@(tmhtml-dimension-attr
		       h 'height `((px ,exact-number->string)))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Standard markup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-list-document list-doc)
  ;; Convert a list-document to a list of <h:li> elements.
  ;; WARNING: makes the xpath environment inconsistent
  (define (item->li mark item)
    (cond ((null? item) '(h:li))
	  ((null? (cdr item)) `(h:li ,@(tmhtml (car item))))
	  (else `(h:li ,@(tmhtml `(document ,@item))))))
  (if (null? (cdr list-doc)) '((h:li))
      (stm-list-map item->li
		    (lambda (x) (== x '(item)))
		    (cdr list-doc))))

;; TODO: when the first data of the list is a label, it must be used to set the
;; ID attribute of the resulting xhtml element. When that is done, remove the
;; warning comment from htmltm-handler.

(define (tmhtml-itemize args)
  `((h:ul ,@(tmhtml-list-document (car args)))))

(define (tmhtml-enumerate args)
  `((h:ol ,@(tmhtml-list-document (car args)))))

(define (tmhtml-desc-document desc-doc)
  ;; WARNING: makes the xpath environment inconsistent
  (define (item->dt-dd mark item)
    (let ((html-item (if (null? (cdr item))
			 (tmhtml (car item))
			 (tmhtml `(document ,@item)))))
      (append
       (if mark (tmhtml mark) '())
       (cond ((and (null? html-item) mark) '())
	     ((null? html-item) '((h:dd)))
	     (else `((h:dd ,@html-item)))))))
  (if (null? (cdr desc-doc)) '((h:dd))
      (apply append (stm-list-map item->dt-dd
				  (lambda (x) (func? x 'item* 1))
				  (cdr desc-doc)))))

(define (tmhtml-description args)
  `((h:dl ,@(tmhtml-desc-document (car args)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Verbatim
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-verbatim args)
  ;; Block-level verbatim environments should only contain inline elements.
  ;;
  ;; @args should be a single element list, we will call this element @body.
  ;;
  ;; If @body is a block structure, it will be either:
  ;; -- a simple DOCUMENT (normal case), and @(tmhtml body) will produce a list
  ;;    of h:p elements;
  ;; -- a block structure producing a single element (degenerate case).
  ;;
  ;; Verbatim structures which do not contain a DOCUMENT but are direct
  ;; children of a DOCUMENT (i.e. they occupy a whole paragraph) are degenerate
  ;; cases of block-level verbatim and must be exported as PRE.
  ;;
  ;; Inline verbatim has little special significance for display in TeXmacs. In
  ;; LaTeX it is used to escape special characters (and protect multiple inline
  ;; spaces, yuck!), but in TeXmacs there is no such problem.
  (with body (first args)
    (if (stm-block-structure? body)
	(verbatim-pre
	 (ahash-with tmhtml-env :preformatted #t
		     (tmhtml body)))
	(verbatim-tt (tmhtml body)))))

(define (verbatim-tt content)
  `((h:tt (@ (class "verbatim")) ,@content)))

(define (verbatim-pre content)
  `((h:pre (@ (class "verbatim") (xml:space "preserve")) ,@content)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Additional tags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-doc-title-block l)
  `((h:table (@ (class "title-block"))
	     (h:tr (h:td ,@(tmhtml (car l)))))))

(define (tmhtml-equation-lab l)
  `((h:table (@ (width "100%"))
	     (h:tr (h:td (@ (align "center") (width "100%"))
			 ,@(tmhtml (car l)))
		   (h:td (@ (align "right"))
			 "(" ,@(tmhtml (cadr l)) ")")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tmdoc tags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-make-block content)
  (let* ((l '(h:td
	      (@ (align "left"))
	      (h:img (@ (src "http://www.texmacs.org/Images/tm_gnu1b.png")))))
	 (c `(h:td
	      (@ (align "center") (width "100%"))
	      ,@(tmhtml content)))
	 (r '(h:td
	      (@ (align "right"))
	      (h:img (@ (src "http://www.texmacs.org/Images/tm_gnu2b.png")))))
	 (row `(h:tr ,l ,c ,r)))
    `(h:table (@ (width "100%") (cellspacing "0") (cellpadding "3")) ,row)))

(define (tmhtml-tmdoc-title l)
  (list `(h:div (@ (class "tmdoc-title-1"))
		,(tmhtml-make-block (car l)))))

(define (tmhtml-tmdoc-title* l)
  (list `(h:div (@ (class "tmdoc-title-2"))
		,(tmhtml-make-block (car l)))
	`(h:div (@ (class "tmdoc-navbar")) ,@(tmhtml (cadr l)))))

(define (tmhtml-tmdoc-title** l)
  (list `(h:div (@ (class "tmdoc-navbar")) ,@(tmhtml (car l)))
	`(h:div (@ (class "tmdoc-title-3")) ,(tmhtml-make-block (cadr l)))
	`(h:div (@ (class "tmdoc-navbar")) ,@(tmhtml (caddr l)))))

(define (tmhtml-tmdoc-flag l)
  ;(tmhtml (car l)))
  (list `(h:div (@ (class "tmdoc-flag")) ,@(tmhtml (car l)))))

(define (tmhtml-tmdoc-copyright* l)
  (if (null? l) l
      `(", " ,@(tmhtml (car l)) ,@(tmhtml-tmdoc-copyright* (cdr l)))))

(define (tmhtml-tmdoc-copyright l)
  (with content
      `("&copy;" " " ,@(tmhtml (car l))
	" " ,@(tmhtml (cadr l))
	,@(tmhtml-tmdoc-copyright* (cddr l)))
    (list `(h:div (@ (class "tmdoc-copyright")) ,@content))))

(define (tmhtml-tmdoc-license l)
  (list `(h:div (@ (class "tmdoc-license")) ,@(tmhtml (car l)))))

(define (tmhtml-key l)
  `((h:u (h:tt ,@(tmhtml (car l))))))

(define (tmhtml-tmdoc-bar? y)
  (or (func? y 'h:h1)
      (func? y 'h:h2)
      (and (func? y 'h:div)
	   (nnull? (cdr y))
	   (func? (cadr y) '@ 1)
	   (== (first (cadadr y)) 'class)
	   (string-starts? (second (cadadr y)) "tmdoc"))))

(define (tmhtml-tmdoc-post-sub x)
  ;; FIXME: these rewritings are quite hacky;
  ;; better simplification would be nice...
  (cond ((and (func? x 'h:p) (list-find (cdr x) tmhtml-tmdoc-bar?)) (cdr x))
	((func? x 'h:p)
	 (with r (append-map tmhtml-tmdoc-post-sub (cdr x))
	   (if (== (cdr x) r) (list x) r)))
	(else (list x))))

(define (tmhtml-tmdoc-post body)
  (with r (append-map tmhtml-tmdoc-post-sub body)
    `((h:div (@ (class "tmdoc-body")) ,@r))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Main conversion routines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tmhtml-list l)
  (append-map tmhtml l))

(define (tmhtml-dispatch htable l)
  (let ((x (drd-ref ,htable (car l))))
    (cond ((not x) #f)
	  ((procedure? x) (x (cdr l)))
	  (else (tmhtml-post-simplify-element
		 (append x (tmhtml-list (cdr l))))))))

(define (tmhtml-implicit-compound l)
  (or (tmhtml-dispatch 'tmhtml-stdmarkup% l)
      (tmhtml-dispatch 'tmhtml-tables% l)
      '()))

(tm-define (tmhtml-root x)
  (ahash-with tmhtml-env :math #f
    (ahash-with tmhtml-env :preformatted #f
      (tmhtml x))))

(define (tmhtml x)
  ;; Main conversion function.
  ;; Takes a TeXmacs tree in Scheme notation and produce a SXML node-set.
  ;; All handler functions have a similar prototype.
  (cond
; ((ahash-ref tmhtml-env :math)
;  `((m:math (@ (xmlns "http://www.w3.org/1998/Math/MathML"))
;	    ,(texmacs->mathml x))))
	((string? x)
	 (if (string-null? x) '() (tmhtml-text x))) ; non-verbatim string nodes
	(else (or (tmhtml-dispatch 'tmhtml-primitives% x)
		  (tmhtml-implicit-compound x)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Dispatching
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(drd-dispatcher tmhtml-primitives%
  (document tmhtml-document)
  (para tmhtml-paragraph)
  (surround tmhtml-surround)
  (concat tmhtml-concat)
  (format tmhtml-noop)
  (hspace tmhtml-vspace)
  (vspace* tmhtml-vspace)
  (vspace tmhtml-vspace)
  (space tmhtml-hspace)
  (htab tmhtml-hspace)
  (split tmhtml-noop)
  (move tmhtml-move)
  (resize tmhtml-resize)
  (float tmhtml-float)
  (repeat tmhtml-repeat)
  (datoms tmhtml-datoms)
  (dlines tmhtml-datoms)
  (dpages tmhtml-datoms)
  (dbox tmhtml-datoms)

  (with-limits tmhtml-noop)
  (line-break tmhtml-noop)
  (new-line tmhtml-new-line)
  (line-sep tmhtml-noop)
  (next-line tmhtml-next-line)
  (no_break tmhtml-noop)
  (no-indent tmhtml-noop)
  (yes-indent tmhtml-noop)
  (no-indent* tmhtml-noop)
  (yes-indent* tmhtml-noop)
  (page-break* tmhtml-noop)
  (page-break tmhtml-noop)
  (no-page-break* tmhtml-noop)
  (no-page-break tmhtml-noop)
  (new-page* tmhtml-noop)
  (new-page tmhtml-noop)
  (new-dpage* tmhtml-noop)
  (new-dpage tmhtml-noop)

  (group tmhtml-id)
  (left tmhtml-id)
  (mid tmhtml-id)
  (right tmhtml-id)
  (big tmhtml-big)
  (lprime tmhtml-id)
  (rprime tmhtml-id)
  (below tmhtml-below)
  (above tmhtml-above)
  (lsub tmhtml-sub)
  (lsup tmhtml-sup)
  (rsub tmhtml-sub)
  (rsup tmhtml-sup)
  (frac tmhtml-frac)
  (sqrt tmhtml-sqrt)
  (wide tmhtml-wide)
  (neg tmhtml-neg)
  ((:or tree old-matrix old-table old-mosaic old-mosaic-item)
   tmhtml-noop)
  (table (lambda (l) (tmhtml `(tabular (table ,@l)))))
  (tformat (lambda (l) (tmhtml `(tabular (tformat ,@l)))))
  ((:or twith cwith tmarker row cell sub-table) tmhtml-noop)

  (assign tmhtml-noop)
  (with tmhtml-with)
  (provides tmhtml-noop)
  ((:or value quote-value) tmhtml-compound)
  ((:or macro drd-props arg quote-arg) tmhtml-noop)
  (compound tmhtml-compound)
  ((:or xmacro get-label get-arity map-args eval-args) tmhtml-noop)
  (mark tmhtml-mark)
  (eval tmhtml-noop)
  ((:or if if* case while for-each extern include use-package) tmhtml-noop)
  
  ((:or or xor and not plus minus times over div mod merge length range
	number date translate is-tuple look-up equal unequal less lesseq
	greater greatereq if case while extern authorize)
   tmhtml-noop)

  ((:or style-with style-with* style-only style-only*
	active active* inactive inactive* rewrite-inactive) tmhtml-noop)
  (inline-tag tmhtml-inline-tag)
  (open-tag tmhtml-open-tag)
  (middle-tag tmhtml-middle-tag)
  (close-tag tmhtml-close-tag)
  (symbol tmhtml-noop)
  (latex tmhtml-noop)
  (hybrid tmhtml-noop)

  ((:or tuple collection associate) tmhtml-noop)
  (label tmhtml-label)
  (reference tmhtml-noop)
  (pageref tmhtml-noop)
  (write tmhtml-noop)
  (specific tmhtml-specific)
  (hlink tmhtml-hyperlink)
  (action tmhtml-action)
  ((:or tag meaning) tmhtml-noop)
  ((:or switch fold exclusive progressive superposed) tmhtml-noop)
  ((:or graphics point line arc bezier) tmhtml-noop)
  (postscript tmhtml-postscript)

  (!file tmhtml-file))

(drd-table tmhtml-stdmarkup%
  ;; special auxiliary tags
  (!left ,tmhtml-align-left)
  (!middle ,tmhtml-align-middle)
  (!right ,tmhtml-align-right)
  ;; Sectioning
  (chapter-title (h:h1))
  (section-title (h:h2))
  (subsection-title (h:h3))
  (subsubsection-title (h:h4))
  ;; paragraph and subparagraph are intented to be used at the start
  ;; of a paragraph. So they cannot be converted to 'h5' and 'h6
  (paragraph-title (h:strong (@(class "paragraph"))))
  (subparagraph-title (h:strong (@(class "subparagraph"))))
  ;; Lists
  ((:or itemize itemize-minus itemize-dot itemize-arrow)
   ,tmhtml-itemize)
  ((:or enumerate enumerate-numeric enumerate-roman enumerate-Roman
	enumerate-alpha enumerate-Alpha)
   ,tmhtml-enumerate)
  ((:or description description-compact description-dash
	description-align description-long)
   ,tmhtml-description)
  (item* (h:dt))
  ;; Phrase elements
  (strong (h:strong))
  (em (h:em))
  (dfn (h:dfn))
  (code* (h:code))
  (samp (h:samp)) ; WARNING: semantic documentation does not match HTML4
  (kbd (h:kbd))
  (var (h:var))
  (abbr (h:abbr))
  (acronym (h:acronym))
  (verbatim ,tmhtml-verbatim)
  (code ,tmhtml-verbatim)
  ;; Presentation
  (tt (h:tt))
  (hrule (h:hr))
  ;; Names
  (TeXmacs ,(lambda x '("TeXmacs")))
  (TeX ,(lambda x '("TeX")))
  (LaTeX ,(lambda x '("LaTeX")))
  ;; additional tags
  (doc-title-block ,tmhtml-doc-title-block)
  (equation-lab ,tmhtml-equation-lab)
  ;; tmdoc tags
  (tmdoc-title ,tmhtml-tmdoc-title)
  (tmdoc-title* ,tmhtml-tmdoc-title*)
  (tmdoc-title** ,tmhtml-tmdoc-title**)
  (tmdoc-flag ,tmhtml-tmdoc-flag)
  (tmdoc-copyright ,tmhtml-tmdoc-copyright)
  (tmdoc-license ,tmhtml-tmdoc-license)
  (key ,tmhtml-key)
  (hyper-link ,tmhtml-hyperlink))

;;    (name (h:name)) ; not in HTML4
;;    (person (h:person)))) ; not in HTML4

(drd-table tmhtml-with-cmd%
  (("font-family" "tt") (h:tt))
  (("font-family" "ss") (h:class (@ (style "font-family: sans-serif"))))
  (("font-series" "bold") (h:b))
  (("font-shape" "italic") (h:i))
  (("font" "roman") (h:class (@ (style "font-family: Times New Roman"))))
  (("font" "times") (h:class (@ (style "font-family: Times New Roman"))))
  (("font" "helvetica") (h:class (@ (style "font-family: Helvetica"))))
  (("font" "courier") (h:class (@ (style "font-family: Coutier"))))
  (("math-font" "cal") (h:class (@ (style "font-family: Flemish Script"))))
  (("math-font" "frak") (h:class (@ (style "font-family: Bernhard Modern"))))
  (("font-series" "medium") (h:class (@ (style "font-weight: normal"))))
  (("font-shape" "right") (h:class (@ (style "font-style: normal"))))
  (("font-shape" "small-caps")
   (h:class (@ (style "font-variant: small-caps")))))

(drd-table tmhtml-with-cmd% ; deprecated
  ("font-size" ,tmhtml-with-font-size)
  (("color" "black") (h:font (@ (color "black"))))
  (("color" "grey") (h:font (@ (color "grey"))))
  (("color" "white") (h:font (@ (color "white"))))
  (("color" "red") (h:font (@ (color "red"))))
  (("color" "blue") (h:font (@ (color "blue"))))
  (("color" "yellow") (h:font (@ (color "black"))))
  (("color" "magenta") (h:font (@ (color "magenta"))))
  (("color" "orange") (h:font (@ (color "orange"))))
  (("color" "green") (h:font (@ (color "green"))))
  (("color" "brown") (h:font (@ (color "brown"))))
  (("color" "dark magenta") (h:font (@ (color "#800080"))))
  (("color" "dark green") (h:font (@ (color "#008000"))))
  (("par-mode" "left") (h:div (@ (align "left"))))
  (("par-mode" "justify") (h:div (@ (align "justify"))))
  (("par-mode" "center") (h:center)))

(drd-table tmhtml-with-cmd% ; netscape4
  (("par-columns" "1") (h:multicol (@ (cols "1"))))
  (("par-columns" "2") (h:multicol (@ (cols "2"))))
  (("par-columns" "3") (h:multicol (@ (cols "3"))))
  (("par-columns" "4") (h:multicol (@ (cols "4"))))
  (("par-columns" "5") (h:multicol (@ (cols "5")))))

(drd-dispatcher tmhtml-tables%
  (block (cut tmhtml-table "l" #t <>))
  (block* (cut tmhtml-table "c" #t <>))
  (tabular (cut tmhtml-table "l" #f <>))
  (tabular* (cut tmhtml-table "c" #f <>)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Interface
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (texmacs->html x)
  (if (tmfile? x)
      (let* ((body (tmfile-extract x 'body))
	     (style* (tmfile-extract x 'style))
	     (style (if (list? style*) style* (list style*)))
	     (lan (tmfile-init x "language"))
	     (doc (list '!file body style lan (get-texmacs-path))))
	(texmacs->html doc))
      ((if (func? x '!file)
	   tmhtml-finalize-document
	   tmhtml-finalize-selection)
       (tmhtml-root x))))
