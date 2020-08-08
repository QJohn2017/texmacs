
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; MODULE      : cpp-lang.scm
;; DESCRIPTION : the C++ Language
;; COPYRIGHT   : (C) 2008  Francis Jamet
;;               (C) 2020  Darcy Shen
;;
;; This software falls under the GNU general public license version 3 or later.
;; It comes WITHOUT ANY WARRANTY WHATSOEVER. For details, see the file LICENSE
;; in the root directory or <http://www.gnu.org/licenses/gpl-3.0.html>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(texmacs-module (prog cpp-lang))

(tm-define (cpp-keywords)
  `(keywords
    (constant
      "false" "true" "cout" "cin" "cerr"
      "null" "NULL")
    (constant_type
      "bool" "char" "double" "float" "int" "long"
      "short" "signed" "unsigned" "void" "wchar_t")
    (declare_type "class" "interface" "enum")
    (declare_module "namespace" "using")
    (keyword
      "asm" "auto" "calloc" "class" "concrete" "constant"
      "const" "const_cast" "default" "delete" "dynamic_cast"
      "free" "enum" "extern" "explicit" "export"  "friend"
      "inline" "malloc" "mutable" "new" "operator" "private"
      "protected" "public" "realloc" "register" "reinterpret_cast" "sizeof"
      "static" "static_cast" "struct" "template" "this" "to"
      "typedef" "typeid" "typename" "union" "virtual" "volatile")
    (keyword_conditional
      "break" "continue" "do" "else" "for" "if"
      "while" "goto" "switch" "case")
    (keyword_control
      "throw" "catch" "finally" "return" "try" "yield")))


(tm-define (cpp-operators)
  `(operators
    (operator
      "+" "-" "/" "*" "%" ;; Arith
      "|" "&" "^" ;; Bit
      "&&" "||" "!"
      "<less><less>" "<gtr><gtr>" "==" "!="
      "<less>" "<gtr>" "<less>=" "<gtr>="
      "&&" "||" "!" "==" "!=" ;; Boolean
      "+=" "-=" "/=" "*=" "%=" "|=" "&=" "^=" ;; Assignment
      "=" ":")
    (operator_special "-<gtr>")
    (operator_decoration "@")
    (operator_field "." "::")
    (operator_openclose "{" "[" "(" ")" "]" "}")))


(define (cpp-number-suffix)
  `(suffix
    (long "l" "L")
    (double "d" "D")
    (float "f" "F")))

(tm-define (cpp-numbers)
  `(numbers
    (bool_features
     "prefix_0x"
     "sci_notation")
    ,(cpp-number-suffix)
    (separator "_")))


(tm-define (cpp-inline-comment-starts)
  (list "//"))


(tm-define (cpp-escape-sequences)
  (list
   `(bool_features)
   `(sequences "\\" "\"" "'" "b" "f" "n" "r" "t")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Preferences for syntax highlighting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (notify-cpp-pref var val)
   (syntax-read-preferences "cpp"))

(define-preferences
  ("syntax:cpp:none" "black" notify-cpp-pref)
  ("syntax:cpp:comment" "dark grey" notify-cpp-pref)
  ("syntax:cpp:keyword" "dark magenta" notify-cpp-pref)
  ("syntax:cpp:error" "dark red" notify-cpp-pref)
  ("syntax:cpp:preprocessor" "dark green" notify-cpp-pref)
  ("syntax:cpp:preprocessor_directive" "dark brown" notify-cpp-pref)
  ("syntax:cpp:constant_type" "#4040c0" notify-cpp-pref)
  ("syntax:cpp:constant_number" "#4040c0" notify-cpp-pref)
  ("syntax:cpp:constant_string" "dark red" notify-cpp-pref))
