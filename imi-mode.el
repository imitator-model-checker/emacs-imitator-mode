;;
;; Major mode for Imitator programs
;; 
;; Author: Giuseppe Lipari (g.lipari@univ-lille.fr)
;; Date: 24/07/2018
;;
;; Imitator is a tool for doing model checking of Parametric Timed
;; Automata (https://www.imitator.fr/ Copyright Etienne André) 
;;
;; This is an Emacs major mode for the language imitator uses for
;; specyfing PTAs. It refers to Imitator v. 2.10.4 (Butter Jellyfish)
;; This version of the file DOES NOT support indentation for the
;; moment, I am working on it !

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;

;; INSTALL

;; 1) Put this file in a place where emacs can find it
;;    or customize load-path in your .emacs startup file like this:
;; 
;;    (setq load-path
;;      (append load-path
;;	      '("/home/dir_where_you_put_imi-mode.el")))
;;
;; 2) Byte compile it (if you wish to speed it up)
;;
;;    M-x byte-compile-file
;;
;; 3) Put the following in your emacs startup file for loading at
;;    startup:
;;
;;    (require 'imi-mode)
;;
;; That's it!
;;

;; -------------------------------------------------------

;; Hook for users that want to customize the mode
(defvar imi-mode-hook nil)

;; An example of emacs command (not very useful, I leave it here for
;; future extensions)
(defvar imi-mode-map
  (let ((map (make-keymap)))
    (define-key map "\C-j" 'newline-and-indent)
    map)
  "Keymap for Imitator major mode")

;; autoload when a .imi file is open
(add-to-list 'auto-mode-alist '("\\.imi\\'" . imi-mode))

;; Language keywords
(defvar imi-mode-font-lock-keywords)

(setq imi-mode-font-lock-keywords
      (let* (
	     ;; define several category of keywords
            (x-keywords '("automaton" "synclabs" "loc" "sync" "do" "goto" "while" "end" "init" "var"))
            (x-types '("clock" "discrete" "constant" "parameter" "unreachable"))
            (x-constants '("True" "False"))
            (x-events '("when"))
            (x-functions '("property"))
	    
	    ;; generate regex string for each category of keywords
            (x-keywords-regexp (regexp-opt x-keywords 'words)) 
            (x-types-regexp (regexp-opt x-types 'words))
            (x-constants-regexp (regexp-opt x-constants 'words))
            (x-events-regexp (regexp-opt x-events 'words))
            (x-functions-regexp (regexp-opt x-functions 'words)))
	`(
          (,x-types-regexp . font-lock-type-face)
          (,x-constants-regexp . font-lock-constant-face)
          (,x-events-regexp . font-lock-builtin-face)
          (,x-functions-regexp . font-lock-function-name-face)
          (,x-keywords-regexp . font-lock-keyword-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;; Syntax table and comments coloring 
(defvar imi-mode-syntax-table nil "Syntax table for Imitator mode.")
(setq imi-mode-syntax-table
      (let ( (synTable (make-syntax-table)))

        ;; set/modify each char's class
        (modify-syntax-entry ?_ "w" synTable)
	;; Wolfram Language style comment “(* … *)”
        (modify-syntax-entry ?\( ". 1" synTable)
        (modify-syntax-entry ?\) ". 4" synTable)
        (modify-syntax-entry ?* ". 23" synTable)
        ;; more lines here ...

        ;; return it
        synTable))


;; Definition of the mode
(define-derived-mode imi-mode fundamental-mode "Imitator"
  "major mode for editing Imitator language code."
  (setq font-lock-defaults '(imi-mode-font-lock-keywords))
  (set-syntax-table imi-mode-syntax-table))

;; This file provides imi-mode
(provide 'imi-mode)
