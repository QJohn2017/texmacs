
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : gpg-edit.scm
;; DESCRIPTION : GnuPG interface to documents
;; COPYRIGHT   : (C) 2015  Gregoire Lecerf
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (security gpg gpg-edit)
  (:use (security gpg gpg-widgets)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Predicates
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-symbol-decrypted? l)
  (in? l '(gpg-decrypted-block gpg-decrypted)))

(tm-define (tm-gpg-symbol-passphrase-decrypted? l)
  (in? l '(gpg-passphrase-decrypted-block gpg-passphrase-decrypted)))


(tm-define (tm-gpg-symbol-encrypted? l)
  (in? l '(gpg-encrypted-block gpg-encrypted)))

(tm-define (tm-gpg-symbol-passphrase-encrypted? l)
  (in? l '(gpg-passphrase-encrypted-block gpg-passphrase-encrypted)))


(tm-define (tm-gpg-decrypted? t)
  (tree-in? t '(gpg-decrypted-block gpg-decrypted)))

(tm-define (tm-gpg-passphrase-decrypted? t)
  (tree-in? t '(gpg-passphrase-decrypted-block gpg-passphrase-decrypted)))


(tm-define (tm-gpg-encrypted? t)
  (tree-in? t '(gpg-encrypted-block gpg-encrypted)))

(tm-define (tm-gpg-passphrase-encrypted? t)
  (tree-in? t '(gpg-passphrase-encrypted-block gpg-passphrase-encrypted)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; User id attached to document
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-get-key-user-id t)
  (:secure #t)
  (:synopsis "Retrieve user id from fingerprint @t")
  (with fingerprint (tree->string t)
    (with l (gpg-get-ahash-ref-attachment "gpg" fingerprint)
      (if l (string->tree (first l)) t))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Public key data attached to document
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-get-key-data t)
  (:secure #t)
  (:synopsis "Retrieve key data from fingerprint @t")
  (with fingerprint (tree->string t)
    (with l (gpg-get-ahash-ref-attachment "gpg" fingerprint)
      (string->tree (if l (second l) "")))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Insert gpg-decrypted, block and inline versions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-widget ((gpg-widget-error-decrypted fingerprint) cmd)
  (resize ("400px" "700px" "9999px") ("100px" "100px" "100px") 
  (padded
    (centered (bold (text
      (string-append "Unknown GnuPG recipient " fingerprint))))
    ===
    (bottom-buttons >> ("Ok" (cmd "Ok"))))))

(define (make-gpg-decrypted fingerprints block?)
  (let* ((t (cursor-tree))
	 (newtag (if block? 'gpg-decrypted-block 'gpg-decrypted)))
    (tree-set! t `(,newtag ,t ,@fingerprints))
    (tree-go-to t 0 :end)))

(tm-define (gpg-command-make-gpg-decrypted args block?)
  (when (and (nnull? args) (== (car args) "Ok"))
    (let* ((fingerprints (cdr args))
	   (pkeys (gpg-public-keys))
	   (t (gpg-get-ahash-table-attachment "gpg")))
      (for (f fingerprints)
	(and-with key (gpg-search-key-by-fingerprint f pkeys)
	  (ahash-set! t f (list (gpg-get-key-user-id key)
				(gpg-get-key-data key)))))
      (gpg-set-ahash-table-attachment "gpg" t)
      (make-gpg-decrypted fingerprints block?))))

(tm-define (tm-gpg-dialogue-insert-decrypted-block)
  (:secure #t)
  (:synopsis "Insert GnuPG decrypted block")
  (with fpr (gpg-get-default-key-fingerprint)
    (when (!= fpr "")
      (ahash-set! gpg-widget-selected-public-key-fingerprints fpr #t)))
  (dialogue-window gpg-widget-select-public-key-fingerprints
		   (lambda (x) (gpg-command-make-gpg-decrypted x #t))
		   "Select GnuPG recipients"))

(tm-define (tm-gpg-dialogue-insert-decrypted)
  (:secure #t)
  (:synopsis "Insert inline GnuPG decrypted region")
  (with fpr (gpg-get-default-key-fingerprint)
    (when (!= fpr "")
      (ahash-set! gpg-widget-selected-public-key-fingerprints fpr #t)))
  (dialogue-window gpg-widget-select-public-key-fingerprints
		   (lambda (x) (gpg-command-make-gpg-decrypted x #f))
		   "Select GnuPG recipients"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Change recipients
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (tm-gpg-replace-decrypted t fingerprints block?)
  (with newtag (if block? 'gpg-decrypted-block 'gpg-decrypted)
    (tree-remove! t 1 (- (tree-arity t) 1))
    (tree-insert! t 1 fingerprints)))

(tm-define (tm-gpg-command-replace-gpg-decrypted t args block?)
  (when (and (nnull? args) (== (car args) "Ok"))
    (let* ((fingerprints (cdr args))
           (pkeys (gpg-public-keys))
	   (ckeys (gpg-get-ahash-table-attachment "gpg")))
      (for (f fingerprints)
	 (and-with key (gpg-search-key-by-fingerprint f pkeys)
	   (ahash-set! ckeys f (list (gpg-get-key-user-id key)
				     (gpg-get-key-data key)))))
      (gpg-set-ahash-table-attachment "gpg" ckeys)
      (tm-gpg-replace-decrypted t fingerprints block?))))

(tm-define (tm-gpg-dialogue-replace-decrypted t)
  (:secure)
  (:synopsis "Edit list of recipients")
  (let* ((block? (symbol-ends? (tree-label t) '-block))
	 (fingerprints (map tree->string (cdr (tree-children t)))))
    (set! gpg-widget-selected-public-key-fingerprints
	  (make-ahash-table))
    (for (fpr fingerprints)
      (ahash-set! gpg-widget-selected-public-key-fingerprints fpr #t))
    (dialogue-window gpg-widget-select-public-key-fingerprints
      (lambda (x) (tm-gpg-command-replace-gpg-decrypted t x block?))
      "Select GnuPG recipients")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Insert gpg-passphrase-decrypted, block and inline versions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-insert-passphrase-decrypted-block)
  (:secure #t)
  (:synopsis "Insert GnuPG passphrase decrypted block")
  (make `gpg-passphrase-decrypted-block))

(tm-define (tm-gpg-insert-passphrase-decrypted)
  (:secure #t)
  (:synopsis "Insert inline GnuPG passphrase decrypted region")
  (make `gpg-passphrase-decrypted))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Encrypt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-encrypt t)
  (:secure #t)
  (:synopsis "Encrypt @t")
  (let* ((block? (symbol-ends? (tree-label t) '-block))
	 (newtag (if block? 'gpg-encrypted-block 'gpg-encrypted))
	 (data (serialize-texmacs (tree-ref t 0)))
	 (fingerprints (cdr (tree-children t))))
    (and-with enc (gpg-encrypt data (map tree->string fingerprints))
      (tree-set! t `(,newtag ,enc ,@(cdr (tree-children t))))
      (tree-go-to t :end)
      (autosave-buffer (current-buffer)))))

(tm-define (tm-gpg-encrypt-block!)
  (:secure #t)
  (:synopsis "Encrypt current block")
  (with-innermost t 'gpg-decrypted-block
    (tm-gpg-encrypt t)))

(tm-define (tm-gpg-encrypt!)
  (:secure #t)
  (:synopsis "Encrypt current inline region")
  (with-innermost t 'gpg-decrypted
    (tm-gpg-encrypt t)))

(tm-define (tm-gpg-dialogue-encrypt-buffer)
  (:secure #t)
  (:synopsis "Encrypt buffer")
  (map tm-gpg-encrypt (select (root-tree)
			      '(:* gpg-decrypted-block)))
  (map tm-gpg-encrypt (select (root-tree)
			      '(:* gpg-decrypted))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Passphrase encrypt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-passphrase-encrypt t passphrase)
  (:secure #t)
  (:synopsis "Passphrase encrypt @t with @passphrase")
  (let* ((block? (symbol-ends? (tree-label t) '-block))
	 (newtag (if block? 'gpg-passphrase-encrypted-block
		            'gpg-passphrase-encrypted))
	 (data (serialize-texmacs (tree-ref t 0)))
	 (enc (gpg-passphrase-encrypt data passphrase)))
    (when enc
      (tree-set! t `(,newtag ,enc))
      (tree-go-to t :end)
      (autosave-buffer (current-buffer)))))

(define (tm-gpg-command-passphrase-encrypt callback action)
  (when (and (list? action) (nnull? action) (== (first action) "Ok"))
    (callback (second action))))

(tm-define (tm-gpg-dialogue-passphrase-encrypt t)
  (:secure #t)
  (:synopsis "Interactive passphrase encryption")
  (with cb (lambda (x) (tm-gpg-passphrase-encrypt t x))
    (dialogue-window gpg-widget-ask-new-passphrase
      (lambda (action) (tm-gpg-command-passphrase-encrypt cb action))
      "Passphrase encryption")))

(tm-define (tm-gpg-dialogue-passphrase-encrypt-block!)
  (:secure #t)
  (:synopsis "Passphrase encrypt current block")
  (with-innermost t 'gpg-passphrase-decrypted-block
    (tm-gpg-dialogue-passphrase-encrypt t)))

(tm-define (tm-gpg-dialogue-passphrase-encrypt!)
  (:secure #t)
  (:synopsis "Passphrase encrypt current inline region")
  (with-innermost t 'gpg-passphrase-decrypted
    (tm-gpg-dialogue-passphrase-encrypt t)))

(tm-define (tm-gpg-passphrase-encrypt-buffer passphrase)
  (:secure #t)
  (:synopsis "Encrypt all passphrase decrypted regions")
  (with f (lambda (x) (tm-gpg-passphrase-encrypt x passphrase))
    (map f (select (root-tree) '(:* gpg-passphrase-decrypted-block)))
    (map f (select (root-tree) '(:* gpg-passphrase-decrypted)))))

(tm-define (tm-gpg-dialogue-passphrase-encrypt-buffer)
  (:secure #t)
  (:synopsis "Interactive passphrase encryption")
  (dialogue-window gpg-widget-ask-new-passphrase
    (lambda (action)
      (tm-gpg-command-passphrase-encrypt
       tm-gpg-passphrase-encrypt-buffer action))
      "Passphrase encryption"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Decrypt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-widget (gpg-widget-error-decrypt cmd)
  (centered
    (text "GnuPG error: cannot find suitable secret key to decrypt"))
  (bottom-buttons >> ("Ok" (cmd "Ok"))))

(define (gpg-try-decrypt data fingerprints callback)
  (if (null? fingerprints)
    (dialogue-window gpg-widget-error-decrypt noop
                     "GnuPG decryption error")
    (let* ((fpr (car fingerprints))
	   (cb (lambda (cmd)
		 (when (and (list? cmd) (equal? (length cmd) 2)
			    (== (car cmd) "Ok"))
		   (with dec (gpg-decrypt data (second cmd))
		     (if dec
			 (begin
			   (when (wallet-persistent-status-on?)
			     (with-wallet
                               (wallet-set (list "gpg" fpr) (second cmd))))
			   (callback dec))
			 (gpg-try-decrypt data
			   (cdr fingerprints) callback)))))))
      (with-wallet
	(with passphrase (wallet-get (list "gpg" fpr))
	  (if passphrase (cb (list "Ok" passphrase))
	      (dialogue-window (gpg-widget-ask-passphrase fpr) cb
                (string-append "Enter passphrase for "
			       (tree->string
				(tm-gpg-get-key-user-id (string->tree fpr)))
			       ", " fpr))))))))

(tm-define (tm-gpg-dialogue-decrypt t . callback)
  (:secure #t)
  (:synopsis "Interactive decryption")
  (let* ((argcb (if (null? callback) noop (car callback)))
	 (keys (gpg-secret-keys))
	 (rcps (map tree->string (cdr (tree-children t))))
	 (todo (filter (lambda (x) (gpg-search-key-by-fingerprint x keys))
		       rcps))
	 (enc (tree->string (tree-ref t 0)))
	 (block? (symbol-ends? (tree-label t) '-block))
	 (newtag (if block? 'gpg-decrypted-block 'gpg-decrypted))
	 (cb (lambda (dec)
	       (with data (parse-texmacs-snippet dec)
		 (tree-set! t `(,newtag ,data ,@(cdr (tree-children t)))))
	       (tree-go-to t 0 :end)
	       (argcb))))
    (gpg-try-decrypt enc todo cb)))

(tm-define (tm-gpg-dialogue-decrypt-block!)
  (:secure #t)
  (:synopsis "Interactive decryption")
  (with-innermost t 'gpg-encrypted-block
    (tm-gpg-dialogue-decrypt t)))

(tm-define (tm-gpg-dialogue-decrypt!)
  (:secure #t)
  (:synopsis "Interactive decryption")
  (with-innermost t 'gpg-encrypted
    (tm-gpg-dialogue-decrypt t)))

(tm-define (tm-gpg-dialogue-decrypt-buffer)
  (:secure #t)
  (:synopsis "Interactive decryption of all encrypted regions")
  (with s (append (select (root-tree) '(:* gpg-encrypted-block))
		  (select (root-tree) '(:* gpg-encrypted)))
    (when (nnull? s)
      (tm-gpg-dialogue-decrypt (car s) tm-gpg-dialogue-decrypt-buffer))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Passphrase decrypt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (tm-gpg-passphrase-decrypt t passphrase)
  (:secure #t)
  (:synopsis "Passphrase decrypt @t with @passphrase")
  (let* ((block? (symbol-ends? (tree-label t) '-block))
	 (newtag (if block? 'gpg-passphrase-decrypted-block
		            'gpg-passphrase-decrypted))
	 (data (tree->string (tree-ref t 0)))
	 (dec (gpg-passphrase-decrypt data passphrase)))
    (when dec
      (with data (parse-texmacs-snippet dec)
	(tree-set! t `(,newtag ,data))
	(tree-go-to t 0 :end)))))

(define (tm-gpg-command-passphrase-decrypt callback action)
  (when (and (list? action) (nnull? action) (== (first action) "Ok"))
    (callback (second action))))

(tm-define (tm-gpg-dialogue-passphrase-decrypt t)
  (:secure #t)
  (:synopsis "Interactive passphrase decryption")
  (with cb (lambda (x) (tm-gpg-passphrase-decrypt t x))
    (dialogue-window 
     (gpg-widget-ask-standalone-passphrase
      (lambda (x) (gpg-decryptable? (tree->string (tree-ref t 0)) x)))
     (lambda (action) (tm-gpg-command-passphrase-decrypt cb action))
     "Passphrase decryption")))

(tm-define (tm-gpg-dialogue-passphrase-decrypt-block!)
  (:secure #t)
  (:synopsis "Passphrase decrypt current block")
  (with-innermost t 'gpg-passphrase-encrypted-block
    (tm-gpg-dialogue-passphrase-decrypt t)))

(tm-define (tm-gpg-dialogue-passphrase-decrypt!)
  (:secure #t)
  (:synopsis "Passphrase decrypt current inline region")
  (with-innermost t 'gpg-passphrase-encrypted
    (tm-gpg-dialogue-passphrase-decrypt t)))

(tm-define (tm-gpg-passphrase-decrypt-buffer passphrase)
  (:secure #t)
  (:synopsis "Passphrase decrypt all regions in buffer")
  (with f (lambda (x) (tm-gpg-passphrase-decrypt x passphrase))
    (map f (select (root-tree) '(:* gpg-passphrase-encrypted-block)))
    (map f (select (root-tree) '(:* gpg-passphrase-encrypted)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Import new public keys contained in buffer
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-widget ((gpg-widget-import-public-keys-from-buffer fingerprints) cmd)
  (resize ("500px" "500px" "9999px") ("200px" "200px" "9999px") 
  (scrollable
    (padded
      (aligned
        (for (x fingerprints)
          (item (text (tm-gpg-get-key-user-id (string->tree x))))))))
  ===
  (bottom-buttons
    ("Cancel" (cmd "Cancel"))
    >>
    ("Ok"
      (for (x fingerprints))
        (gpg-import-public-keys
          (tree->string (tm-gpg-get-key-data (string->tree x)))))
      (cmd "Ok"))))

(tm-widget (gpg-widget-no-new-public-key-from-buffer cmd)
  (resize ("400px" "400px" "400px") ("100px" "100px" "100px") 
  (padded
    (centered (bold (text "No new public key in document!")))
    ===
    (bottom-buttons >> ("Ok" (cmd "Ok"))))))

(tm-define (gpg-dialogue-import-public-keys-from-buffer fingerprints)
  (if (null? fingerprints)
    (dialogue-window gpg-widget-no-new-public-key-from-buffer noop
                     "Import public keys from buffer")
    (dialogue-window (gpg-widget-import-public-keys-from-buffer fingerprints)
		     noop "Import public keys from buffer")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Structured edition
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(tm-define (structured-insert-horizontal t forwards?)
  (:require (or (tm-gpg-decrypted? t)
		(tm-gpg-encrypted? t)
		(tm-gpg-passphrase-decrypted? t)
		(tm-gpg-passphrase-encrypted? t)))
  (noop))

(tm-define (structured-remove-horizontal t forwards?)
  (:require (or (tm-gpg-decrypted? t)
		(tm-gpg-encrypted? t)
		(tm-gpg-passphrase-decrypted? t)
		(tm-gpg-passphrase-encrypted? t)))
  (noop))
