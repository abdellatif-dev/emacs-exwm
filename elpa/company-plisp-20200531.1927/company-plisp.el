;;; company-plisp.el --- Company mode backend for PicoLisp language	-*- lexical-binding: t; -*-
;; Copyright (C) 2020  Fermin Munoz

;; Author: Fermin MF <fmfs@posteo.net>
;; Created: 26 May 2020
;; Version: 0.0.1
;; Keywords: company,plisp,convenience,auto-completion

;; URL: https://gitlab.com/sasanidas/company-plisp
;; Package-Requires: ((emacs "25") (s "1.2.0") (company "0.8.12") (dash "2.12.0") (cl-lib "0.5"))
;; License: GPL-3.0-or-later

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Backend for company mode for the PicoLisp programming language

;;; Code:


(require 's)
(require 'cl-lib)
(require 'dash)
(require 'company)

(defgroup company-plisp nil
  "Company mode backend for PicoLisp functions."
  :group 'company
  :prefix "company-plisp-"
  :link '(url-link :tag "Repository" "https://gitlab.com/sasanidas/company-plisp"))


(defcustom company-plisp-complete-libraries nil
  "Wheter or not to complete file libraries.
It may affect performance."
  :type 'boolean
  :group 'company-plisp)

(defcustom company-plisp-pil-exec "/usr/bin/pil"
  "PicoLisp pil executable location."
  :type 'file
  :group 'company-plisp)

(defvar company-plisp-complete-file (concat
				     (file-name-directory load-file-name)
				     "company-plisp.l")
  "Default location for the company PicoLisp completion file.")

(defun company-plisp--load-libraries ()
  "Search for load function inside the buffer.
Append it to a temp file, and return the file name."
  (let* ((plisp-temp-l (make-temp-file "plisp_l.l"))
	 (load-lines
	  (-filter (lambda (line)
		     (posix-string-match "\(load\s+[\"][@]?[[:word:]]+[\\/]?[[:word:]]+\\.l[\"]" line))
		   (s-lines (buffer-substring-no-properties  1 (buffer-end 1))))))
    (-map (lambda (line)
	    (write-region line nil plisp-temp-l 'append 0))
	  load-lines)
    (format "%s" plisp-temp-l)))



(defun company-plisp--backend (prefix)
  "Company plisp backend function PREFIX."
  (let* ((library-file (if company-plisp-complete-libraries
			   (company-plisp--load-libraries)
			 ""))
	 (completion-list
	  (s-lines
	   (shell-command-to-string
	    (concat  company-plisp-pil-exec " "
		     library-file " "
		     company-plisp-complete-file " -"
		     prefix " -bye")))))
    (unless (equal (length library-file) 0)
      (delete-file library-file))
    completion-list))



 (defun company-plisp (command &optional arg &rest ignored)
   "Company plisp main function, it requires a COMMAND"
   (interactive (list 'interactive))
   (cl-case command
     (interactive (company-begin-backend 'company-plisp))
     (prefix (and (eq major-mode 'plisp-mode)
                 (company-grab-symbol)))
    (candidates
     (cl-remove-if-not
      (lambda (c) (string-prefix-p arg c))
      (company-plisp--backend (s-prepend "\\" arg))))))

(provide 'company-plisp)
;;; company-plisp.el ends here
