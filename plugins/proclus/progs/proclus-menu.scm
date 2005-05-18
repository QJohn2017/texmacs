
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; arch-tag: 50b8b47d-3ab4-47b5-b0b6-adfcf98eff6e
;;
;; MODULE      : proclus-menu.scm
;; DESCRIPTION : Menus definitions for the 'proclus' plugin
;; COPYRIGHT   : (C) 2003--2004  Alain Herreman, David Allouche
;;
;;   This program is free software; you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;   the Free Software Foundation; either version 2 of the License, or
;;   (at your option) any later version.
;;
;;   You should have received a copy of the GNU General Public License
;;   along with this program; if not, write to the Free Software
;;   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (proclus-menu)
  (:use (proclus) (proclus-types) (proclus-absname)
	(proclus-distill) (proclus-source) (proclus-absname-editor)))

(menu-bind proclus-links-menu
  (=> "Links"
      (when (in-proclus-locus?)
            ("Active source" (active-source))
	    (when (has-active-source?)
		  ("Active but" (active-but))
		  ("Initialiser" (proclus-inactivate))))
      ---
      (when (has-last-locus?)
            ("Dernier locus" (go-to-last-locus)))
      (when (has-source-link?)
            ("Locus source" (go-to-source-link)))
      ("Constellation" (absname-editor))
      ---
      (when (in-proclus-locus?)
            ("Supprimer le lien" (remove-link))
            ("Supprimer type..." (remove-link-type)))
      ---
      (when (has-source-link?)
            (link proclus-types-menu)
            ---
            (link proclus-edit-menu))))

(menu-bind proclus-menu
  (=> "Proclus"
      (when (has-absolute-name?)
            ("Locus" (locus))
            (when (or (selection-active-any?) (in-proclus-locus?))
                  ("Active source" (active-source))
		  (when (has-active-source?)
                  ("Active but" (active-but))
		  ("Initialiser" (proclus-inactivate)))))
      ---
      (when (has-last-locus?)
            ("Retour source" (go-to-last-locus)))
      ---
      ("Constellation" (absname-editor))
      (when (has-conflicting-absolute-name?)
            ("Document d�plac�" (absolute-name-reregister-buffer)))
      (when (and (not (no-name?)) (not (has-absolute-name?)))
            ("Nommer ce document..." (interactive-absolute-name)))
      ("Apprendre un nom..." (absname-choose-file))
      ---
      (link proclus-types-menu)
      ---
      (when (in-proclus-editable?)
            ("Loci" (proclus-edit-loci)))
      (link proclus-edit-menu)))

(menu-bind proclus-types-menu
  (promise (type-menu-promise)))

(menu-bind proclus-edit-menu
  (when (in-proclus-locus?)
        ("Liens" (proclus-edit-links))))

(menu-bind proclus-popup-menu
  ("Activer source" (active-source))
  ("Activer but" (active-but))
  ("Initialiser" (proclus-inactivate))
  (link proclus-types-menu)
  ("Liens" (proclus-edit-links))
  (if (in-proclus-links?)
      ---
      ("Supprimer le lien" (remove-link))
      ("Supprimer type..." (remove-link-type))))
