
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : tmtex-elsevier.scm
;; DESCRIPTION : special conversions for elsevier styles
;; COPYRIGHT   : (C) 2006  Joris van der Hoeven
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (convert latex tmtex-elsevier)
  (:use (convert latex tmtex)))

(tm-define (tmtex-transform-style x)
  (:mode elsevier-style?)
  (cond ((in? x '("elsart" "jsc")) "elsart")
	((== x "elsarticle") "elsarticle")
        (else x)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Initialization of elsevier style
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define note-counter 0)
(define author-counter 0)
(define clustered? #f)

(tm-define (init-elsevier body)
  (:synopsis "Initialize Elsevier style")
  (set! clustered? #f)
  (set! note-counter 0)
  (set! author-counter 0))

(tm-define (tmtex-style-init body)
  (:mode elsevier-style?)
  (init-elsevier body))

(tm-define (tmtex-style-init body)
  (:mode jsc-style?)
  (init-elsevier body)
  (set! tmtex-packages (cons "natbib" tmtex-packages))
  (latex-set-packages '("amsthm" "yjsco" "natbib")))

(define (ref-note)
  (number->string note-counter))

(define (refstep-note)
  (set! note-counter (+ note-counter 1))
  (string-append "note-" (ref-note)))

(define (ref-author)
  (number->string author-counter))

(define (refstep-author)
  (set! author-counter (+ author-counter 1))
  (string-append "author-" (ref-author)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Preprocessing datas
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-style-preprocess doc)
  (:mode elsevier-style?)
  (elsevier-create-frontmatter doc))

(define (elsarticle-frontmatter? t)
  (or (func? t 'abstract-data) (func? t 'doc-data) (func? t 'abstract)))

(define (partition l pred?)
  (if (npair? l) l
    (letrec ((npred? (lambda (x) (not (pred? x)))))
      (if (pred? (car l))
        (receive (h t) (list-break l npred?)
          (cons h (partition t pred?)))
        (receive (h t) (list-break l pred?)
          (cons h (partition t pred?)))))))

(define (elsevier-create-frontmatter t)
  (if (or (npair? t) (npair? (cdr t))) t
    (with l (map elsarticle-frontmatter? (cdr t))
      (if (in? #t l)
        (with parts (partition (cdr t) elsarticle-frontmatter?)
          `(,(car t) ,@(map (lambda (x)
                              (if (elsarticle-frontmatter? (car x))
                                `(elsevier-frontmatter (,(car t) ,@x))
                                `(,(car t) ,@x))) parts)))
        `(,(car t) ,@(map elsevier-create-frontmatter (cdr t)))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsevier specific customizations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-elsevier-frontmatter s l)
  (:mode elsevier-style?)
  `((!begin "frontmatter") ,(tmtex (car l))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsarticle specific title macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-replace-documents t)
  (:mode elsevier-style?) t)

(tm-define (springer-note-ref l r)
  (if (list? r)
    (set! r (tex-concat* (list-intersperse r ",")))
    (set! r (string-append l r)))
  `(tnoteref ,r))

(tm-define (tmtex-doc-title t)
  (:mode elsevier-style?)
  `(title ,(tmtex (cadr t))))

(tm-define (tmtex-doc-subtitle-ref s l)
  (:mode elsevier-style?)
  (springer-note-ref "sub-" (car l)))

(tm-define (tmtex-doc-subtitle-label s l)
  (:mode elsevier-style?)
  (with label (string-append "sub-" (car l))
    `(tsubtitletext (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-doc-note-ref s l)
  (:mode elsevier-style?)
  (springer-note-ref "note-" (car l)))

(tm-define (tmtex-doc-note-label s l)
  (:mode elsevier-style?)
  (with label (string-append "note-" (car l))
    `(tnotetext (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-doc-date-ref s l)
  (:mode elsevier-style?)
  (springer-note-ref "date-" (car l)))

(tm-define (tmtex-doc-date-label s l)
  (:mode elsevier-style?)
  (with label (string-append "date-" (car l))
    `(tdatetext (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-doc-misc-ref s l)
  (:mode elsevier-style?)
  (springer-note-ref "misc-" (car l)))

(tm-define (tmtex-doc-misc-label s l)
  (:mode elsevier-style?)
  (with label (string-append "misc-" (car l))
    `(tmisctext (!option ,label) ,(tmtex (cadr l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsevier specific authors macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (springer-author-note-ref l r)
  (if (list? r)
    (set! r (tex-concat* (list-intersperse r ",")))
    (set! r (string-append l r)))
  `(fnref ,r))

(tm-define (tmtex-author-note-ref s l)
  (:mode elsevier-style?)
  (springer-author-note-ref "author-note-" (car l)))

(tm-define (tmtex-author-note-label s l)
  (:mode elsevier-style?)
  (with label (string-append "author-note-" (car l))
    `(fntext (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-author-misc-ref s l)
  (:mode elsevier-style?)
  (springer-author-note-ref "author-misc-" (car l)))

(tm-define (tmtex-author-misc-label s l)
  (:mode elsevier-style?)
  (with label (string-append "author-misc-" (car l))
    `(fmtext (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-author-affiliation t)
  (:mode elsevier-style?)
  `(address ,(tmtex (cadr t))))

(tm-define (tmtex-author-affiliation-ref s l)
  (:mode elsevier-style?)
  (springer-author-note-ref "affiliation-" (car l)))

(tm-define (tmtex-author-affiliation-label s l)
  (:mode elsevier-style?)
  (with label (string-append "affiliation-" (car l))
    `(address (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-author-email t)
  (:mode elsevier-style?)
  `(ead ,(tmtex (cadr t))))

(tm-define (tmtex-author-homepage t)
  (:mode elsevier-style?)
  `(ead (!option "url") ,(tmtex (cadr t))))

(tm-define (tmtex-author-name t)
  (:mode elsevier-style?)
  `(author ,(tmtex (cadr t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsart specific title macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-replace-documents t)
  (:mode elsart-style?)
  (if (npair? t) t
    (with (r s) (list (car t) (map tmtex-replace-documents (cdr t)))
      (if (!= r 'document) `(,r ,@s)
        `(concat ,@(list-intersperse s '(next-line)))))))

(tm-define (springer-note-ref l r)
  (:mode elsart-style?)
  (if (list? r)
    `(!concat ,@(map (lambda (x) `(thanksref ,x)) r))
    `(thanksref ,(string-append l r))))

(tm-define (tmtex-doc-subtitle-label s l)
  (:mode elsart-style?)
  (with label (string-append "sub-" (car l))
    `(thankssubtitle (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-doc-note-label s l)
  (:mode elsart-style?)
  (with label (string-append "note-" (car l))
    `(thanks (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-doc-date-label s l)
  (:mode elsart-style?)
  (with label (string-append "date-" (car l))
    `(thanksdate (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-doc-misc-label s l)
  (:mode elsart-style?)
  (with label (string-append "misc-" (car l))
    `(thanksmisc (!option ,label) ,(tmtex (cadr l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsart specific authors macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (springer-author-note-ref l r)
  (:mode elsart-style?)
  (springer-note-ref l r))

(tm-define (tmtex-author-note-label s l)
  (:mode elsart-style?)
  (with label (string-append "author-note-" (car l))
    `(thanks (!option ,label) ,(tmtex (cadr l)))))

(tm-define (tmtex-author-misc-label s l)
  (:mode elsart-style?)
  (with label (string-append "author-misc-" (car l))
    `(thanksamisc (!option ,label) ,(tmtex (cadr l)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsevier title and author preprocessing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-prepare-doc-data l)
  (:mode elsevier-style?)
  (set! clustered?
    (or
      (contains-stree? l '(doc-title-options "cluster-by-affiliation"))
      (contains-stree? l '(doc-title-options "cluster-all"))))
  (set! l (map tmtex-replace-documents l))
  (set! l (make-references l 'doc-subtitle #f #f))
  (set! l (make-references l 'doc-note #f #f))
  (set! l (make-references l 'doc-misc #f #f))
  (set! l (make-references l 'doc-date #f #f))
  (set! l (make-references l 'author-note #t #f))
  (set! l (make-references l 'author-misc #t #f))
  (if clustered?
    (set! l (make-references l 'author-affiliation #t #f)))
  l)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsevier non clustered title and author presentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-make-doc-data titles subtitles authors dates miscs notes
                                subtitles-l dates-l miscs-l notes-l)
  (:mode elsevier-style?)
  (let* ((authors (filter nnull? authors))
         (authors (if (null? authors) '()
                    `((!paragraph ,@authors))))
         (titles (tmtex-concat-Sep (map cadr titles)))
         (notes  `(,@subtitles ,@dates ,@miscs ,@notes))
         (notes  (if (null? notes) '()
                   `(,(springer-note-ref "" (map cadr notes)))))
         (result `(,@titles ,@notes))
         (result (if (null? result) '() `((title (!concat ,@result)))))
         (result `(,@result ,@subtitles-l ,@notes-l
                   ,@miscs-l ,@dates-l ,@authors)))
    (if (null? result) "" `(!document ,@result))))

(tm-define (tmtex-make-author names affs emails urls miscs notes
                              affs-l emails-l urls-l miscs-l notes-l)
  (:mode elsevier-style?)
  (let* ((names  (tmtex-concat-Sep (map cadr names)))
         (notes  `(,@miscs ,@notes))
         (notes  (if (null? notes) '()
                   `(,(springer-author-note-ref "" (map cadr notes)))))
         (result `(,@names ,@notes))
         (result (if (null? result) '() `((author (!concat ,@result)))))
         (result `(,@result ,@affs ,@emails ,@urls ,@miscs-l ,@notes-l)))
    (if (null? result) '() `(!paragraph ,@result ""))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsevier affiliation clustered author presentation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-make-author names affs emails urls miscs notes
                              affs-l emails-l urls-l miscs-l notes-l)
  (:mode elsevier-style?)
  (:require clustered?)
  (let* ((names  (tmtex-concat-Sep (map cadr names)))
         (notes  `(,@miscs ,@notes))
         (notes  (if (null? notes) '()
                   `(,(springer-author-note-ref "" (map cadr notes)))))
         (affs   (if (null? affs) '()
                   `((!option
                       (!concat ,@(list-intersperse (map cadr affs) ","))))))
         (result `(,@names ,@notes))
         (result (if (null? result) '() `((author ,@affs (!concat ,@result)))))
         (labels `(,@affs-l ,@miscs-l ,@notes-l))
         (labels (if (null? labels) '() `((!document ,@labels))))
         (result `(,@result ,@emails ,@urls ,@labels)))
    (if (null? result) '() `(!paragraph ,@result))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elsevier abstract macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-abstract-data s l)
  (:mode elsevier-style?)
  (let* ((msc (tmtex-select-args-by-func 'abstract-msc l))
         (msc (apply append (map cdr (map tmtex msc))))
         (msc (list-intersperse msc '(!concat " " (sep) " ")))
         (msc (if (nnull? msc) `((!concat (PACS) " " ,@msc)) '()))
         (keywords (tmtex-select-args-by-func 'abstract-keywords l))
         (keywords (apply append (map cdr (map tmtex keywords))))
         (keywords (list-intersperse keywords '(!concat " " (sep) " ")))
         (keywords (if (nnull? keywords) `((!concat ,@keywords)) '()))
         (keywords (if (or (nnull? msc) (nnull? keywords))
                       `(((!begin "keyword")
                          (!document ,@keywords ,@msc))) '()))
         (abstract (map tmtex (tmtex-select-args-by-func 'abstract l))))
    `(!document ,@abstract ,@keywords)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The Elsevier style is quite ugly.
;; Transform equations into eqnarray* for more uniform alignment.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tmtex-equation s l)
  (:mode elsevier-style?)
  (tmtex-env-set "mode" "math")
  (let ((r (tmtex (car l))))
    (tmtex-env-reset "mode")
    (if (== s "equation")
	(list (list '!begin "eqnarray") r)  ;; FIXME: why do elsequation
	(list (list '!begin "eqnarray*") r) ;; and elsequation* not work?
	)))
