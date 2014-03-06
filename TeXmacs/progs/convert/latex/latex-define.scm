
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : latex-define.scm
;; DESCRIPTION : LaTeX definitions for TeXmacs extensions
;; COPYRIGHT   : (C) 2005  Joris van der Hoeven
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (convert latex latex-define)
  (:use (convert latex latex-texmacs-drd)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra TeXmacs symbols
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(smart-table latex-texmacs-macro
  ;; arrows with limits
  (leftarrowlim "\\mathop{\\leftarrow}\\limits")
  (rightarrowlim "\\mathop{\\rightarrow}\\limits")
  (leftrightarrowlim "\\mathop{\\leftrightarrow}\\limits")
  (mapstolim "\\mathop{\\mapsto}\\limits")
  (longleftarrowlim "\\mathop{\\longleftarrow}\\limits")
  (longrightarrowlim "\\mathop{\\longrightarrow}\\limits")
  (longleftrightarrowlim "\\mathop{\\longleftrightarrow}\\limits")
  (longmapstolim "\\mathop{\\longmapsto}\\limits")
  (leftsquigarrowlim "\\mathop{\\leftsquigarrow}\\limits")
  (rightsquigarrowlim "\\mathop{\\rightsquigarrow}\\limits")
  (leftrightsquigarrowlim "\\mathop{\\leftrightsquigarrow}\\limits")
  (equallim "\\mathop{=}\\limits")
  (longequallim "\\mathop{\\longequal}\\limits")
  (Leftarrowlim "\\mathop{\\leftarrow}\\limits")
  (Rightarrowlim "\\mathop{\\rightarrow}\\limits")
  (Leftrightarrowlim "\\mathop{\\leftrightarrow}\\limits")
  (Longleftarrowlim "\\mathop{\\longleftarrow}\\limits")
  (Longrightarrowlim "\\mathop{\\longrightarrow}\\limits")
  (Longleftrightarrowlim "\\mathop{\\longleftrightarrow}\\limits")

  ;; asymptotic relations by Joris
  (nasymp "\\not\\asymp")
  (asympasymp "{\\asymp\\!\\!\\!\\!\\!\\!-}")
  (nasympasymp "{\\not\\asymp\\!\\!\\!\\!\\!\\!-}")
  (simsim "{\\approx\\!\\!\\!\\!\\!\\!-}")
  (nsimsim "{\\not\\approx\\!\\!\\!\\!\\!\\!-}")
  (npreccurlyeq "\\not\\preccurlyeq")
  (precprec "\\prec\\!\\!\\!\\prec")
  (precpreceq "\\preceq\\!\\!\\!\\preceq")
  (precprecprec "\\prec\\!\\!\\!\\prec\\!\\!\\!\\prec")
  (precprecpreceq "\\preceq\\!\\!\\!\\preceq\\!\\!\\!\\preceq")
  (succsucc "\\succ\\!\\!\\!\\succ")
  (succsucceq "\\succeq\\!\\!\\!\\succeq")
  (succsuccsucc "\\succ\\!\\!\\!\\succ\\!\\!\\!\\succ")
  (succsuccsucceq "\\succeq\\!\\!\\!\\succeq\\!\\!\\!\\succeq")
  (lleq "\\leq\\negmedspace\\negmedspace\\leq")
  (llleq "\\leq\\negmedspace\\negmedspace\\leq\\negmedspace\\negmedspace\\leq")
  (ggeq "\\geq\\negmedspace\\negmedspace\\geq")
  (gggeq "\\geq\\negmedspace\\negmedspace\\geq\\negmedspace\\negmedspace\\geq")

  ;; extra literal symbols
  (btimes "{\\mbox{\\rotatebox[origin=c]{90}{$\\ltimes$}}}")
  (Backepsilon "{\\mbox{\\rotatebox[origin=c]{180}{E}}}")
  (Mho "{\\mbox{\\rotatebox[origin=c]{180}{$\\Omega$}}}")
  (mapmulti "{\\mbox{\\rotatebox[origin=c]{180}{$\\multimap$}}}")
  (mathcatalan "C")
  (mathd "\\mathrm{d}")
  (mathD "\\mathrm{D}")
  (mathe "\\mathrm{e}")
  (matheuler "\\gamma")
  (mathlambda "\\lambda")
  (mathi "\\mathrm{i}")
  (mathpi "\\pi")
  (Alpha "\\mathrm{A}")
  (Beta "\\mathrm{B}")
  (Epsilon "\\mathrm{E}")
  (Eta "\\mathrm{H}")
  (Iota "\\mathrm{I}")
  (Kappa "\\mathrm{K}")
  (Mu "\\mathrm{M}")
  (Nu "\\mathrm{N}")
  (Omicron "\\mathrm{O}")
  (Chi "\\mathrm{X}")
  (Rho "\\mathrm{P}")
  (Tau "\\mathrm{T}")
  (Zeta "\\mathrm{Z}")

  ;; other extra symbols
  (exterior "\\wedge")
  (Exists "\\exists")
  (bigintwl "\\int")
  (bigointwl "\\oint")
  (asterisk "*")
  (point ".")
  (cdummy "\\cdot")
  (comma "{,}")
  (copyright "\\copyright")
  (bignone "")
  (nobracket "")
  (nospace "")
  (nocomma "")
  (noplus "")
  (nosymbol "")
  (nin "\\not\\in")
  (nni "\\not\\ni")
  (notni "\\not\\ni")
  (nequiv "\\not\\equiv")
  (nleadsto "\\not\\leadsto")
  (dotamalg "\\mathaccent95{\\amalg}")
  (dottimes "\\mathaccent95{\\times}")
  (dotoplus "\\mathaccent95{\\oplus}")
  (dototimes "\\mathaccent95{\\otimes}")
  (into "\\rightarrow")
  (longequal "{=\\!\\!=}")
  (longhookrightarrow "{\\lhook\\joinrel\\relbar\\joinrel\\rightarrow}")
  (longhookleftarrow "{\\leftarrow\\joinrel\\relbar\\joinrel\\rhook}")
  (longdownarrow "\\downarrow")
  (longuparrow "\\uparrow")
  (triangleup "\\triangle")
  (precdot "{\\prec\\hspace{-0.6em}\\cdot}\\;\\,")
  (preceqdot "{\\preccurlyeq\\hspace{-0.6em}\\cdot}\\;\\,")
  (llangle "{\\langle\\!\\langle}")
  (rrangle "{\\rangle\\!\\rangle}")
  (join "\\Join")
  (um "-")
  (upl "+")
  (upm "\\pm")
  (ump "\\mp")
  (upequal "{\\mbox{\\rotatebox[origin=c]{90}{$=$}}}")
  (assign ":=")
  (plusassign "+\\!\\!=")
  (minusassign "-\\!\\!=")
  (timesassign "\times\\!\\!=")
  (overassign "/\\!\\!=")
  (lflux "\\ll")
  (gflux "\\gg")
  (colons "\\,:\\,")
  (transtype "\\,:\\!!>")
  (udots "{\\mathinner{\\mskip1mu\\raise1pt\\vbox{\\kern7pt\\hbox{.}}\\mskip2mu\\raise4pt\\hbox{.}\\mskip2mu\\raise7pt\\hbox{.}\\mskip1mu}}"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra TeXmacs macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(smart-table latex-texmacs-macro
  ;; Nullary macros
  (tmunsc "\\_")
  (emdash "---")
  (tmhrule "\\noindent\\rule[0.3\\baselineskip]{\\textwidth}{0.4pt}")
  (tmat "\\symbol{\"40}")
  (tmbsl "\\ensuremath{\\backslash}")
  (tmdummy "$\\mbox{}$")
  (TeXmacs "T\\kern-.1667em\\lower.5ex\\hbox{E}\\kern-.125emX\\kern-.1em\\lower.5ex\\hbox{\\textsc{m\\kern-.05ema\\kern-.125emc\\kern-.05ems}}")
  (madebyTeXmacs (footnote (!recurse (withTeXmacstext))))
  (withTeXmacstext
    (!append (!translate "This document has been produced using the GNU") " "
             (!group (!recurse (TeXmacs))) " " (!translate "text editor") " ("
             (!translate "see") " "
             (url "http://www.texmacs.org") ")"))
  (scheme "{\\sc Scheme}")
  (tmsep  ", ")
  (tmSep  "; ")
  (pari "{\\sc Pari}")

  ;; Unary macros
  (tmrsub (ensuremath (!append "_{" (textrm 1) "}")))
  (tmrsup (textsuperscript 1))
  (tmverbatim (!group (ttfamily) (!group 1)))
  (tmtextrm (!group (rmfamily) (!group 1)))
  (tmtextsf (!group (sffamily) (!group 1)))
  (tmtexttt (!group (ttfamily) (!group 1)))
  (tmtextmd (!group (mdseries) (!group 1)))
  (tmtextbf (!group (bfseries) (!group 1)))
  (tmtextup (!group (upshape) (!group 1)))
  (tmtextsl (!group (slshape) (!group 1)))
  (tmtextit (!group (itshape) (!group 1)))
  (tmtextsc (!group (scshape) (!group 1)))
  (tmmathbf (ensuremath (boldsymbol 1)))
  (tmop (ensuremath (operatorname 1)))
  (tmstrong (textbf 1))
  (tmem (!group "\\em " 1 "\\/"))
  (tmtt (texttt 1))
  (tmdate (today))
  (tmname (textsc 1))
  (tmsamp (textsf 1))
  (tmabbr 1)
  (tmdfn (textbf 1))
  (tmkbd (texttt 1))
  (tmvar (texttt 1))
  (tmacronym (textsc 1))
  (tmperson (textsc 1))
  (tmscript (text (scriptsize (!math 1))))
  (tmdef 1)
  (dueto (textup (textbf (!append "(" 1 ") "))))
  (op 1)
  (tmoutput 1)
  (tmerrput (!append (color "red!50!black") 1))
  (tmtiming (!append (hfill) (footnotesize) (color "black!50") 1 (par)))
  (tmrunningtitle (!append (!translate "Running title:") " " 1))
  (tmrunningauthor (!append (!translate "Running author:") " " 1))
  (tmaffiliation (thanks (!append (textit (!translate "Affiliation:")) " " 1)))
  (tmemail (thanks (!append (textit (!translate "Email:")) " " (texttt 1))))
  (tmhomepage (thanks (!append (textit (!translate "Web:")) " " (texttt 1))))
  (tmsubtitle (thanks (!append (textit (!translate "Subtitle:")) " " 1)))
  (tmacmhomepage (titlenote (!append (textit (!translate "Web:")) " " 1)))
  (tmacmmisc (titlenote (!append (textit (!translate "Misc:")) " " 1)))
  (tmieeeemail (!append (textit (!translate "Email:")) " " 1))
  (tmnote (thanks (!append (textit (!translate "Note:")) " " 1)))
  (tmmisc (thanks (!append (textit (!translate "Misc:")) " " 1)))

  ;; With options
  (tmcodeinline ((!option "") (!group (ttfamily) (!group 2))))

  ;; Binary macros
  (tmsummarizeddocumentation
   (trivlist (!append (item (!option "")) (mbox "") "\\large\\bf" 1)))
  (tmsummarizedgrouped (trivlist (!append (item (!option "[")) (mbox "") 1)))
  (tmsummarizedexplain
   (trivlist (!append (item (!option "")) (mbox "") "\\bf" 1)))
  (tmsummarizedplain (trivlist (!append (item (!option "")) (mbox "") 1)))
  (tmsummarizedtiny (trivlist (!append (item (!option "")) (mbox "") 1)))
  (tmsummarizedraw (trivlist (!append (item (!option "")) (mbox "") 1)))
  (tmsummarizedenv
   (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))
  (tmsummarizedstd
   (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))
  (tmsummarized
   (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))

  (tmdetaileddocumentation
   (trivlist (!append (item (!option "")) (mbox "") "\\large\\bf" 2)))
  (tmdetailedgrouped (trivlist (!append (item (!option "[")) (mbox "") 2)))
  (tmdetailedexplain
   (trivlist (!append (item (!option "")) (mbox "") "\\bf" 2)))
  (tmdetailedplain (trivlist (!append (item (!option "")) (mbox "") 2)))
  (tmdetailedtiny (trivlist (!append (item (!option "")) (mbox "") 2)))
  (tmdetailedraw (trivlist (!append (item (!option "")) (mbox "") 2)))
  (tmdetailedenv (trivlist (!append (item (!option "$\\circ$")) (mbox "") 2)))
  (tmdetailedstd (trivlist (!append (item (!option "$\\circ$")) (mbox "") 2)))
  (tmdetailed (trivlist (!append (item (!option "$\\circ$")) (mbox "") 2)))

  (tmfoldeddocumentation
   (trivlist (!append (item (!option "")) (mbox "") "\\large\\bf" 1)))
  (tmunfoldeddocumentation
   (trivlist (!append (item (!option "")) (mbox "")
		      (!group "\\large\\bf" 1) "\\\\"
		      (item (!option "")) (mbox "") 2)))
  (tmfoldedsubsession
   (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))
  (tmunfoldedsubsession
   (trivlist (!append (item (!option "$\\circ$"))   (mbox "") 1 "\\\\"
		      (item (!option "")) (mbox "") 2 )))
  (tmfoldedgrouped
   (trivlist (!append (item (!option "["))  (mbox "") 1)))
  (tmunfoldedgrouped
   (trivlist (!append (item (!option "$\\lceil$"))  (mbox "") 1 "\\\\"
		      (item (!option "$\\lfloor$")) (mbox "") 2 )))
  (tmfoldedexplain (trivlist (!append (item (!option "")) "\\bf" 1)))
  (tmunfoldedexplain
   (trivlist (!append (item (!option "")) (mbox "")
		      (!group "\\bf" 1) "\\\\"
		      (item (!option "")) (mbox "") 2 )))
  (tmfoldedplain (trivlist (!append (item (!option "")) (mbox "") 1)))
  (tmunfoldedplain
   (trivlist (!append (item (!option "")) (mbox "") 1 "\\\\"
		      (item (!option "")) (mbox "") 2 )))
  (tmfoldedenv (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))
  (tmunfoldedenv
   (trivlist (!append (item (!option "$\\circ$")) (mbox "") 1 "\\\\"
		      (item (!option "")) (mbox "") 2 )))
  (tmfoldedstd (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))
  (tmunfoldedstd
   (trivlist (!append (item (!option "$\\circ$")) (mbox "") 1 "\\\\"
		      (item (!option "")) (mbox "") 2 )))
  (tmfolded (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1)))
  (tmunfolded (trivlist (!append (item (!option "$\\circ$")) (mbox "") 1 "\\\\"
				 (item (!option "")) (mbox "") 2 )))
  (tminput
   (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		      (!group (!append (color "blue!50!black") (mbox "") 2)))))
  (tminputmath
   (trivlist (!append (item (!option 1)) (ensuremath 2))))
  (tmhlink  (!group (!append (color "blue") 1)))
  (tmaction (!group (!append (color "blue") 1)))
  (ontop ("{\\genfrac{}{}{0pt}{}{#1}{#2}}"))
  (subindex (index (!append 1 "!" 2)))

  ;; Ternary macros
  (tmsession (!group (!append (tt) 3)))
  (tmfoldediomath
   (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		      (!group (!append (color "blue!50!black") (ensuremath 2))))))
  (tmunfoldediomath
   (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		      (!group (!append (color "blue!50!black") (ensuremath 2)))
		      (item (!option "")) (mbox "") 3)))
  (tmfoldedio
   (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		      (mbox "") (!group (!append (color "blue!50!black") 2)))))
  (tmunfoldedio
   (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		      (mbox "") (!group (!append (color "blue!50!black") 2))
		      (item (!option "")) (mbox "") 3)))
  (subsubindex (index (!append 1 "!" 2 "!" 3)))
  (tmref 1)
  (glossaryentry (!append (item (!option (!append 1 (hfill)))) 2 (dotfill) 3))

  ;; Tetrary macros
  (tmscriptinput (fbox (!append (fbox (!append (sf) 2)) " "
				(!append (tt) 3))))
  (tmscriptoutput (!append 4))
  (tmconverterinput (fbox (!append (fbox (!append (sf) 2)) " "
				   (!append (tt) 3))))
  (tmconverteroutput (!append 4))
  (subsubsubindex (index (!append 1 "!" 2 "!" 3 "!" 4))))

(smart-table latex-texmacs-macro
  (:require (latex-has-texmacs-package? "framed-session"))
  (tmerrput ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={red!15},linecolor={red!50!black}"))
             (!append (color "red!50!black") 1)))
  (tmfoldedsubsession
   ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={rgb:white,10;red,9;green,4;yellow,2},linecolor={black!50}"))
    (trivlist (!append (item (!option "$\\bullet$")) (mbox "") 1))))
  (tmunfoldedsubsession
   (!append
    ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={rgb:white,10;red,9;green,4;yellow,2},linecolor={black!50}"))
     (trivlist (!append (item (!option "$\\circ$")) (mbox "") 1)))
    ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={rgb:white,50;red,9;green,4;yellow,2},linecolor={black!50}"))
     (trivlist (!append (item (!option "")) (mbox "") 2 )))))
  (tminput
   ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={yellow!15},linecolor={black!15}"))
    (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		       (!group (!append (color "blue!50!black") (mbox "") 2))))))
  (tminputmath
   ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={yellow!15},linecolor={black!15}"))
    (trivlist (!append (item (!option 1)) (mbox "") (ensuremath 2)))))
  

  (tmfoldediomath
   ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={yellow!15},linecolor={black!15}"))
    (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		       (mbox "") (!group (!append (color "blue!50!black") (ensuremath 2)))))))
  (tmunfoldediomath
   (!append ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={yellow!15},linecolor={black!15}"))
	     (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
				(mbox "") (!group (!append (color "blue!50!black") (ensuremath 2))))))
	    ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor=white,linewidth=0pt"))
	     (trivlist (!append (item (!option "")) (mbox "") 3)))))
  (tmfoldedio
   ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={yellow!15},linecolor={black!15}"))
    (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
		       (mbox "") (!group (!append (color "blue!50!black") 2))))))
  (tmunfoldedio
   (!append ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor={yellow!15},linecolor={black!15}"))
	     (trivlist (!append (item (!option (!append (color "rgb:black,10;red,9;green,4;yellow,2") 1)))
				(mbox "") (!group (!append (color "blue!50!black") 2)))))
	    ((!begin "tmframed" (!option "skipabove=0,skipbelow=0,backgroundcolor=white,linewidth=0pt"))
	     (trivlist (!append (item (!option "")) (mbox "") 3))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Style-dependent extra macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(smart-table latex-texmacs-macro
  (:require (latex-has-style? "letter"))
  (appendix ""))

(define-macro (latex-texmacs-section name inside style)
  `(smart-table latex-texmacs-macro
     (:require (latex-has-style? ,style))
     (,name (!append (medskip) (bigskip) "\n\n" (noindent) (textbf ,inside)))))

(define-macro (latex-texmacs-paragraph name inside style)
  `(smart-table latex-texmacs-macro
     (:require (latex-has-style? ,style))
     (,name (!append (smallskip) "\n\n" (noindent) (textbf ,inside)))))

(latex-texmacs-section chapter (!append "\\huge " 1) "article")
(latex-texmacs-section chapter (!append "\\huge " 1) "letter")
(latex-texmacs-section section (!append "\\LARGE " 1) "letter")
(latex-texmacs-section subsection (!append "\\Large " 1) "letter")
(latex-texmacs-section subsubsection (!append "\\large " 1) "letter")
(latex-texmacs-paragraph paragraph 1 "letter")
(latex-texmacs-paragraph subparagraph 1 "letter")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Deprecated extra macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(smart-table latex-texmacs-macro
  (labeleqnum "\\addtocounter{equation}{-1}\\refstepcounter{equation}\\addtocounter{equation}{1})")
  (eqnumber (!append "\\hfill(\\theequation" (!recurse (labeleqnum)) ")"))
  (leqnumber (!append "(\\theequation" (!recurse (labeleqnum)) ")\\hfill"))
  (reqnumber (!append "\\hfill(\\theequation" (!recurse (labeleqnum)) ")"))

  (key (!append "\\fbox{\\rule[-2pt]{0pt}{9pt}" (texttt 1) "}"))
  (skey (!recurse (key (!append "shift-" 1))))
  (ckey (!recurse (key (!append "ctrl-" 1))))
  (akey (!recurse (key (!append "alt-" 1))))
  (mkey (!recurse (key (!append "meta-" 1))))
  (hkey (!recurse (key (!append "hyper-" 1)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra TeXmacs environments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(smart-table latex-texmacs-environment
  ("proof"
   (!append (noindent) (textbf (!append (!translate "Proof") "\\ "))
	    ---
	    (hspace* (fill)) (!math (Box)) (medskip)))
  ("proof*"
   (!append (noindent) (textbf (!append 1 "\\ "))
	    ---
	    (hspace* (fill)) (!math (Box)) (medskip)))
  ("left-aligned"
   (!append (!begin "flushleft")
	    ---
            (!end "flushleft")))
  ("tmcode"
   ((!option "")
    (!append (begin "alltt")
	    ---
             (end "alltt"))))
  ("right-aligned"
   (!append (!begin "flushright")
	    ---
            (!end "flushright")))
  ("tmparmod"
   ((!begin "list" "" (!append "\\setlength{\\topsep}{0pt}"
			       "\\setlength{\\leftmargin}{" 1 "}"
			       "\\setlength{\\rightmargin}{" 2 "}"
			       "\\setlength{\\parindent}{" 3 "}"
			       "\\setlength{\\listparindent}{\\parindent}"
			       "\\setlength{\\itemindent}{\\parindent}"
			       "\\setlength{\\parsep}{\\parskip}"))
    (!append "\\item[]"
	     ---)))
  ("tmparsep"
   (!append (begingroup) "\\setlength{\\parskip}{" 1 "}"
	     ---
	     (endgroup)))
  ("tmindent"
   ((!begin "tmparmod" "1.5em" "0pt" "0pt") ---))
  ("elsequation" ((!begin "eqnarray") (!append --- "&&")))
  ("elsequation*" ((!begin "eqnarray*") (!append --- "&&")))
  ("theglossary"
   ((!begin "list" "" (!append "\\setlength{\\labelwidth}{6.5em}"
			       "\\setlength{\\leftmargin}{7em}"
			       "\\small")) ---)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TeXmacs list environments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (latex-texmacs-itemize env lab)
  `(smart-table latex-texmacs-environment
     (,env
      ((!begin "itemize")
       (!append "\\renewcommand{\\labelitemi}{" ,lab "}"
		"\\renewcommand{\\labelitemii}{" ,lab "}"
		"\\renewcommand{\\labelitemiii}{" ,lab "}"
		"\\renewcommand{\\labelitemiv}{" ,lab "}"
		---)))))

(define-macro (latex-texmacs-enumerate env lab)
  `(smart-table latex-texmacs-environment
     (,env ((!begin "enumerate" (!option ,lab)) ---))))

(define-macro (latex-texmacs-description env)
  `(smart-table latex-texmacs-environment
     (,env ((!begin "description") ---))))

(latex-texmacs-itemize "itemizeminus" "$-$")
(latex-texmacs-itemize "itemizedot" "$\\bullet$")
(latex-texmacs-itemize "itemizearrow" "$\\rightarrow$")
(latex-texmacs-enumerate "enumeratenumeric" "1.")
(latex-texmacs-enumerate "enumerateroman" "i.")
(latex-texmacs-enumerate "enumerateromancap" "I.")
(latex-texmacs-enumerate "enumeratealpha" "a{\\textup{)}}")
(latex-texmacs-enumerate "enumeratealphacap" "A.")
(latex-texmacs-description "descriptioncompact")
(latex-texmacs-description "descriptionaligned")
(latex-texmacs-description "descriptiondash")
(latex-texmacs-description "descriptionlong")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra preamble definitions which are needed to export certain macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(logic-table latex-texmacs-preamble%
  (newmdenv
   (!append (mdfsetup (!append "linecolor=black,linewidth=0.5pt,"
			       "skipabove=0.5em,skipbelow=0.5em,"
			       "hidealllines=true,\ninnerleftmargin=0pt,"
			       "innerrightmargin=0pt,innertopmargin=0pt,"
			       "innerbottommargin=0pt" )) "\n"))
  (tmkeywords
   (!append (newcommand (tmkeywords)
			(!append (textbf (!translate "Keywords:")) " "))
	    "\n"))
  (tmacm
   (!append (newcommand (tmacm)
			(!append
                         (textbf
			  (!translate "A.C.M. subject classification:")) " "))
	    "\n"))
  (tmarxiv
   (!append (newcommand (tmarxiv)
			(!append
			 (textbf
			  (!translate "arXiv subject classification:")) " "))
	    "\n"))
  (tmpacs
   (!append (newcommand (tmpacs)
                        (!append
			 (textbf
			  (!translate "P.A.C.S. subject classification:"))
			 " "))
	    "\n"))
  (tmmsc
   (!append (newcommand (tmmsc)
			(!append
                         (textbf
			  (!translate "A.M.S. subject classification:")) " "))
	    "\n"))
  (fmtext (!append "\\newcommand{\\fmtext}[2][]{\\fntext[#1]{"
		   (!translate "Misc:") " #2}}\n"))
  (tdatetext (!append "\\newcommand{\\tdatetext}[2][]{\\tnotetext[#1]{"
		      (!translate "Date:") " #2}}\n"))
  (tmisctext (!append "\\newcommand{\\tmisctext}[2][]{\\tnotetext[#1]{"
		      (!translate "Misc:") " #2}}\n"))
  (tsubtitletext (!append "\\newcommand{\\tsubtitletext}[2][]{\\tnotetext[#1]{"
                          (!translate "Subtitle:") " #2}}\n"))
  (thankshomepage (!append "\\newcommand{\\thankshomepage}[2][]{\\thanks[#1]{"
			   (!translate "URL:") " #2}}\n"))
  (thanksemail (!append "\\newcommand{\\thanksemail}[2][]{\\thanks[#1]{"
			(!translate "Email:") " #2}}\n"))
  (thanksdate (!append "\\newcommand{\\thanksdate}[2][]{\\thanks[#1]{"
		       (!translate "Date:") " #2}}\n"))
  (thanksamisc (!append "\\newcommand{\\thanksamisc}[2][]{\\thanks[#1]{"
			(!translate "Misc:") " #2}}\n"))
  (thanksmisc (!append "\\newcommand{\\thanksmisc}[2][]{\\thanks[#1]{"
		       (!translate "Misc:") " #2}}\n"))
  (thankssubtitle (!append "\\newcommand{\\thankssubtitle}[2][]{\\thanks[#1]{"
                           (!translate "Subtitle:") " #2}}\n"))
  (mho
   (!append
    "\\renewcommand{\\mho}{\\mbox{\\rotatebox[origin=c]{180}{$\\omega$}}}"))
  (tmfloat
   (!append
    "\\newcommand{\\tmfloatcontents}{}\n"
    "\\newlength{\\tmfloatwidth}\n"
    "\\newcommand{\\tmfloat}[5]{\n"
    "  \\renewcommand{\\tmfloatcontents}{#4}\n"
    "  \\setlength{\\tmfloatwidth}{\\widthof{\\tmfloatcontents}+1in}\n"
    "  \\ifthenelse{\\equal{#2}{small}}\n"
    "    {\\ifthenelse{\\lengthtest{\\tmfloatwidth > \\linewidth}}\n"
    "      {\\setlength{\\tmfloatwidth}{\\linewidth}}{}}\n"
    "    {\\setlength{\\tmfloatwidth}{\\linewidth}}\n"
    "  \\begin{minipage}[#1]{\\tmfloatwidth}\n"
    "    \\begin{center}\n"
    "      \\tmfloatcontents\n"
    "      \\captionof{#3}{#5}\n"
    "    \\end{center}\n"
    "  \\end{minipage}}\n")))

;;(define-macro (latex-texmacs-long prim x l m r)
;;  `(logic-table latex-texmacs-preamble%
;;     (,(string->symbol (substring prim 1 (string-length prim)))
;;      (!append
;;       "\\def" ,prim "fill@{\\arrowfill@" ,l ,m ,r "}\n"
;;       "\\providecommand{" ,prim "}[2][]{"
;;       "\\ext@arrow 0099" ,prim "fill@{#1}{#2}}\n"))))

(define-macro (latex-texmacs-long prim x l m r)
  `(logic-table latex-texmacs-preamble%
     (,(string->symbol (substring prim 1 (string-length prim)))
      (!append
       "\\providecommand{" ,prim "}[2][]{"
       "\\mathop{" ,x "}\\limits_{#1}^{#2}}\n"))))

(latex-texmacs-long "\\xminus" "-"
                    "\\DOTSB\\relbar" "\\relbar" "\\DOTSB\\relbar")
(latex-texmacs-long "\\xleftrightarrow" "\\longleftrightarrow"
                    "\\leftarrow" "\\relbar" "\\rightarrow")
(latex-texmacs-long "\\xmapsto" "\\longmapsto"
                    "\\vdash" "\\relbar" "\\rightarrow")
(latex-texmacs-long "\\xmapsfrom" "\\leftarrow\\!\\!\\dashv"
                    "\\leftarrow" "\\relbar" "\\dashv")
(latex-texmacs-long "\\xequal" "="
                    "\\DOTSB\\Relbar" "\\Relbar" "\\DOTSB\\Relbar")
(latex-texmacs-long "\\xLeftarrow" "\\Longleftarrow"
                    "\\Leftarrow" "\\Relbar" "\\Relbar")
(latex-texmacs-long "\\xRightarrow" "\\Longrightarrow"
                    "\\Relbar" "\\Relbar" "\\Rightarrow")
(latex-texmacs-long "\\xLeftrightarrow" "\\Longleftrightarrow"
                    "\\Leftarrow" "\\Relbar" "\\Rightarrow")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Plain style theorems
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (latex-texmacs-thmenv prim name before after)
  `(logic-table latex-texmacs-env-preamble%
     (,prim (!append ,@before (newtheorem ,prim (!translate ,name))
		     ,@after "\n")
	    no-amsthm-package%)))

(define-macro (latex-texmacs-theorem prim name)
  `(latex-texmacs-thmenv ,prim ,name () ()))

(define-macro (latex-texmacs-remark prim name)
  `(latex-texmacs-thmenv
    ,prim ,name ("{" (!recurse (theorembodyfont "\\rmfamily"))) ("}")))

(define-macro (latex-texmacs-exercise prim name)
  `(latex-texmacs-thmenv
    ,prim ,name ("{" (!recurse (theorembodyfont "\\rmfamily\\small"))) ("}")))

(latex-texmacs-theorem "theorem" "Theorem")
(latex-texmacs-theorem "proposition" "Proposition")
(latex-texmacs-theorem "lemma" "Lemma")
(latex-texmacs-theorem "corollary" "Corollary")
(latex-texmacs-theorem "axiom" "Axiom")
(latex-texmacs-theorem "definition" "Definition")
(latex-texmacs-theorem "notation" "Notation")
(latex-texmacs-theorem "conjecture" "Conjecture")
(latex-texmacs-remark "remark" "Remark")
(latex-texmacs-remark "note" "Note")
(latex-texmacs-remark "example" "Example")
(latex-texmacs-remark "convention" "Convention")
(latex-texmacs-remark "warning" "Warning")
(latex-texmacs-remark "acknowledgments" "Acknowledgments")
(latex-texmacs-remark "answer" "Answer")
(latex-texmacs-remark "question" "Question")
(latex-texmacs-exercise "exercise" "Exercise")
(latex-texmacs-exercise "problem" "Problem")
(latex-texmacs-exercise "solution" "Solution")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; AMS style theorems
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-macro (ams-texmacs-theorem abbr full)
  `(begin
     (logic-table latex-texmacs-env-preamble%
       (,abbr (!append "\\theoremstyle{plain}\n"
		       (newtheorem ,abbr (!translate ,full))
		       "\n")
	      amsthm-package%))))

(define-macro (ams-texmacs-remark abbr full)
  `(begin
     (logic-table latex-texmacs-env-preamble%
       (,abbr (!append "\\theoremstyle{remark}\n"
		       (newtheorem ,abbr (!translate ,full))
		       "\n")
	      amsthm-package%))))

(define-macro (ams-texmacs-indent-exercise abbr full)
  `(begin
     (logic-table latex-texmacs-env-preamble%
       (,abbr (!append "\\newtheoremstyle{indent-exercise}{3pt}{3pt}"
		       "{\\small}{\\parindent}{\\bf\\small}{.}{.5em}{}{}\n"
		       "\\theoremstyle{indent-exercise}\n"
		       (newtheorem ,abbr (!translate ,full))
		       "\n")
	      amsthm-package%))))

(define-macro (ams-texmacs-noindent-exercise abbr full)
  `(begin
     (logic-table latex-texmacs-env-preamble%
       (,abbr (!append "\\newtheoremstyle{noindent-exercise}{3pt}{3pt}"
		       "{\\small}{}{\\bf\\small}{.}{.5em}{}{}\n"
		       "\\theoremstyle{noindent-exercise}\n"
		       (newtheorem ,abbr (!translate ,full))
		       "\n")
	      amsthm-package%))))

(ams-texmacs-theorem "theorem" "Theorem")
(ams-texmacs-theorem "proposition" "Proposition")
(ams-texmacs-theorem "lemma" "Lemma")
(ams-texmacs-theorem "corollary" "Corollary")
(ams-texmacs-theorem "axiom" "Axiom")
(ams-texmacs-theorem "definition" "Definition")
(ams-texmacs-theorem "notation" "Notation")
(ams-texmacs-theorem "conjecture" "Conjecture")
(ams-texmacs-remark "remark" "Remark")
(ams-texmacs-remark "note" "Note")
(ams-texmacs-remark "example" "Example")
(ams-texmacs-remark "convention" "Convention")
(ams-texmacs-remark "acknowledgments" "Acknowledgments")
(ams-texmacs-remark "warning" "Warning")
(ams-texmacs-remark "answer" "Answer")
(ams-texmacs-remark "question" "Question")
(ams-texmacs-indent-exercise "exercise" "Exercise")
(ams-texmacs-indent-exercise "problem" "Problem")
(ams-texmacs-noindent-exercise "solution" "Solution")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Ornamented environments
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(logic-table latex-texmacs-env-preamble%
  ("tmpadded" (!append (newmdenv (!option "") "tmpadded") "\n"))
  ("tmoverlined"
   (!append (newmdenv (!option "topline=true,innertopmargin=1ex")
                      "tmoverlined") "\n"))
  ("tmunderlined"
   (!append (newmdenv (!option "bottomline=true,innerbottommargin=1ex")
                      "tmunderlined") "\n"))
  ("tmbothlined"
   (!append (newmdenv (!option "topline=true,bottomline=true,innertopmargin=1ex,innerbottommargin=1ex")
                      "tmbothlined") "\n"))
  ("tmframed"
   (!append (newmdenv (!option "hidealllines=false,innertopmargin=1ex,innerbottommargin=1ex,innerleftmargin=1ex,innerrightmargin=1ex")
                      "tmframed") "\n"))
  ("tmornamented"
   (!append (newmdenv (!option "hidealllines=false,innertopmargin=1ex,innerbottommargin=1ex,innerleftmargin=1ex,innerrightmargin=1ex")
                      "tmornamented") "\n")))
