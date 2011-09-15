;;; gdb-bp-session.el --- Save and Restore breakpoints for Emacs gdb

;; Copyright (C) 2011 Lee Jong-Gyu<jglee1027@gmail.com>

;; Authors: Lee Jong-Gyu<jglee1027@gmail.com>
;; Maintainer: Lee Jong-Gyu<jglee1027@gmail.com>
;; Created: 15 Sep 2011
;; Version: 0.1.0
;; Keywords: languages, tools
;; Repository: git://github.com/jglee1027/gdb-bp-session.git

;; This file is NOT part of GNU Emacs.

;; This file is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; It is distributed in the hope that it will be useful, but WITHOUT
;; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
;; or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
;; License for more details.

;; You should have received a copy of the GNU General Public License
;; along with it.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; gdb-bp-session provides keeping breakpoints which you set recently
;; in gdb.  You should kill gdb buffer using `gdb-kill-buffer'
;; function "C-x k" to save current breakpoints, that's all. Is it too
;; easy? The current breakpionts are saved to
;; `$HOME/.$PROCESS_NAME-breakpoints.gdb'

;; * Installation
;;   Edit your ~/.emacs file to add the line:
;;     (add-to-list 'load-path "/path/to/gdb-bp-session")
;;     (require 'gdb-bp-session)

;;; Code:

(require 'gud)

(defun gud-get-process-name ()
  (let ((process (get-buffer-process gud-comint-buffer)))
	(if (null process)
		nil
	  (process-name process))))

;;;###autoload
(defun gdb-save-breakpoints ()
  "Save current breakpoint definitions as a script."
  (interactive)
  (let ((gud-process-name (gud-get-process-name)))
	(cond (gud-process-name
		   (gud-basic-call
			(format "save breakpoints ~/.%s-breakpoints.gdb"
					gud-process-name))))))

;;;###autoload
(defun gdb-restore-breakpoints ()
  "Restore the saved breakpoint definitions as a script."
  (interactive)
  (let ((breakpoints-file (format "~/.%s-breakpoints.gdb"
								  (gud-get-process-name))))
	(if (file-exists-p breakpoints-file)
		(gud-basic-call (format "source %s" breakpoints-file)))))

;;;###autoload
(defun gdb-kill-buffer ()
  "Kill gdb-buffer."
  (interactive)
  (gdb-save-breakpoints)
  (kill-buffer))

(defun gdb-breakpoint-session ()
  (gdb-restore-breakpoints)
  (local-set-key (kbd "C-x k") 'gdb-kill-buffer))
  
(add-hook 'gdb-mode-hook 'gdb-breakpoint-session)

(provide 'gdb-bp-session)

;;; gdb-bp-session ends here
