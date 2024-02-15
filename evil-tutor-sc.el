;;; evil-tutor-sc.el --- Simplified Chinese tutor for Evil

;; Copyright (C) 2023 clsty
;;
;; Author: clsty <celestial.y@outlook.com>
;; Keywords: convenience editing evil Chinese
;; Created: 14 June 2023
;; Version: 0.1
;; Package-Requires: ((evil "1.0.9") (evil-tutor "0.1"))
;; URL: https://github.com/clsty/evil-tutor-sc

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Vimtutor adapted for Evil in Simplified Chinese.

;;     M-x evil-tutor-sc-start

;; This will create a working file in `evil-tutor-sc-working-directory' (defaults
;; to `~/.emacs.d/.tutor-sc')

;; Features:
;; - restore last working file
;; - fast navigation between lessons with `C-j' and `C-k'

;;; Code:

(require 'evil)
(require 'evil-tutor)

(defcustom evil-tutor-sc-working-directory
  (file-name-as-directory (expand-file-name ".tutor-sc" user-emacs-directory))
  "The directory where to create working files."
  :type 'string
  :group 'evil)

(define-derived-mode evil-tutor-sc-mode evil-tutor-mode "evil-tutor-sc"
  "Major mode for evil-tutor-sc.")

;;;###autoload
(defun evil-tutor-sc-start ()
  "Start a evil-tutor-sc session."
  (interactive)
  (evil-tutor-sc-restore-or-create-working-file)
  (evil-tutor-sc-mode)
  (evil-mode))

;;;###autoload
(defun evil-tutor-sc-reset ()
  "Reset evil-tutor-sc session by cleaning previous working file."
  (interactive)
  (evil-tutor-sc-clean-working-file))

;;;###autoload
(defun evil-tutor-sc-start-new ()
  "Start a new evil-tutor-sc session."
  (interactive)
  (evil-tutor-sc-clean-working-file)
  (evil-tutor-sc-restore-or-create-working-file)
  (evil-tutor-sc-mode)
  (evil-mode))

;;;###autoload
(defalias 'evil-tutor-sc-resume #'evil-tutor-sc-start)

(defun evil-tutor-sc-restore-or-create-working-file ()
  "Create a new working buffer and save it in `evil-tutor-sc-working-directory'.

If a working file already exists in `evil-tutor-sc-working-directory' then the
found file is visited instead of creating a brand new buffer.

For now the point location is not saved but this is a functionality which can
be handled by minor modes."
  (let* ((files (if (file-exists-p evil-tutor-sc-working-directory)
                    (directory-files evil-tutor-sc-working-directory t nil t)))
         (previous-file (evil-tutor--find-first-working-file files)))
    (message "load: %s" (symbol-file 'evil-tutor-sc-mode))
    (if previous-file
           (find-file previous-file)
      (let* ((date (format-time-string "%d%m%Y"))
             (working-file-name (format "evil-tutor-sc-%s.txt" date))
             (tutor-sc-file (concat (file-name-directory (symbol-file
                                                       'evil-tutor-sc-mode))
                                 "tutor-sc.txt")))
        (switch-to-buffer (get-buffer-create "working-file-name"))
        (set-visited-file-name (concat evil-tutor-sc-working-directory
                                       working-file-name))
           (insert-file-contents tutor-sc-file)
        (make-directory evil-tutor-sc-working-directory 'parents)
        (save-buffer 0)))))

(defun evil-tutor-sc-clean-working-file ()
  "Clean the working file if it exists in `evil-tutor-sc-working-directory'."
  (let* ((files (if (file-exists-p evil-tutor-sc-working-directory)
                    (directory-files evil-tutor-sc-working-directory t nil t)))
         (previous-file (evil-tutor--find-first-working-file files)))
    (if previous-file
           (delete-file previous-file)
      (message "No previous working-file to clean."))))

(provide 'evil-tutor-sc)

;;; evil-tutor-sc.el ends here
