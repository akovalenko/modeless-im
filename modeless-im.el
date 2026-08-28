;;; modeless-im.el --- Modeless (non-toggling) input method commands  -*- lexical-binding: t; -*-

;; Author: Anton Kovalenko <anton@sw4me.com>
;; Assisted-by: Claude Code:claude-fable-5
;; Maintainer: Anton Kovalenko <anton@sw4me.com>
;; URL: https://github.com/akovalenko/modeless-im
;; Version: 1.0
;; Package-Requires: ((emacs "24.3"))
;; Keywords: i18n, convenience
;; SPDX-License-Identifier: Unlicense

;; This is free and unencumbered software released into the public
;; domain.  See the UNLICENSE file or <https://unlicense.org> for
;; details.

;;; Commentary:

;; For software that has to handle different input methods, there is a
;; long-running tradition to have a keyboard command that toggles
;; input method state.  When you know exactly what input method you
;; want, using toggle commands requires unnecessary attention to the
;; current state of input method.
;;
;; modeless-im provides commands for turning input method to a wanted
;; state directly instead of toggling it, in ordinary buffers as well
;; as in isearch.
;;
;; Bind a dedicated key to each state, for example:
;;
;;   (require 'modeless-im)
;;   (modeless-im-define-keys '("S-<f11>") '("S-<f12>"))
;;
;; after which S-<f11> always turns the input method on and S-<f12>
;; always turns it off, regardless of the current state.

;;; Code:

;;;###autoload
(defun modeless-im-turn-off ()
  "Turn off input method in a modeless way."
  (interactive)
  (deactivate-input-method))

;;;###autoload
(defun modeless-im-turn-on ()
  "Turn on input method in a modeless way."
  (interactive)
  (unless current-input-method
    (toggle-input-method)))

;; In the isearch commands below, `isearch-input-method-function'
;; holds the value of `input-method-function' captured from the
;; searched buffer.  The global default of `input-method-function' is
;; the symbol `list', a placeholder meaning "no input method" -- so an
;; input method is active in the search only when the captured value
;; is non-nil and different from `list'.

;;;###autoload
(defun modeless-im-isearch-turn-off ()
  "Turn off input method modelessly in isearch mode."
  (interactive)
  (when (and isearch-input-method-function
             (not (eq isearch-input-method-function 'list)))
    (isearch-toggle-input-method))
  (isearch-update))

;;;###autoload
(defun modeless-im-isearch-turn-on ()
  "Turn on input method modelessly in isearch mode."
  (interactive)
  (unless (and isearch-input-method-function
               (not (eq isearch-input-method-function 'list)))
    (isearch-toggle-input-method))
  (isearch-update))

;;;###autoload
(defun modeless-im-define-keys (on-keys off-keys)
  "Bind keys for setting input method state directly.
ON-KEYS and OFF-KEYS are lists of key descriptions in `kbd' format.
Each of ON-KEYS is bound globally to `modeless-im-turn-on' and, in
`isearch-mode-map', to `modeless-im-isearch-turn-on'; each of
OFF-KEYS is likewise bound to the corresponding turn-off commands."
  (dolist (keys off-keys)
    (let ((kseq (kbd keys)))
      (global-set-key kseq #'modeless-im-turn-off)
      (define-key isearch-mode-map kseq
        #'modeless-im-isearch-turn-off)))
  (dolist (keys on-keys)
    (let ((kseq (kbd keys)))
      (global-set-key kseq #'modeless-im-turn-on)
      (define-key isearch-mode-map kseq
        #'modeless-im-isearch-turn-on))))

(provide 'modeless-im)
;;; modeless-im.el ends here
