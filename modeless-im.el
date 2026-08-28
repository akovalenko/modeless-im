;;; modeless-im.el --- provide modeless (non-toggling) input method commands  -*- lexical-binding: t; -*-

;;; Commentary:

;; For software that has to handle different input methods, there is a
;; long-running tradition to have a keyboard command that toggles
;; input method state. When you know exactly what input method you
;; want, using toggle commands require unnecessary attention to the
;; current state of input method.
;;
;; modeless-im provides commands for turning input method to a wanted
;; state directly instead of toggling it.

(defun modeless-im-turn-off ()
  "Turn off input method in a modeless way"
  (interactive)
  (deactivate-input-method))

(defun modeless-im-turn-on ()
  "Turn on input method in a modeless way"
  (interactive)
  (unless current-input-method
    (toggle-input-method)))

(defun modeless-im-isearch-turn-off ()
  "Turn off input method modelessly in isearch mode"
  (interactive)
  (when (and isearch-input-method-function
	     (not (eq isearch-input-method-function 'list)))
    (isearch-toggle-input-method))
  (isearch-update))

(defun modeless-im-isearch-turn-on ()
  "Turn on input method modelessly in isearch mode"
  (interactive)
  (unless (and isearch-input-method-function
	       (not (eq isearch-input-method-function 'list)))
    (isearch-toggle-input-method))
  (isearch-update))

(defun modeless-im-define-keys (on-keys off-keys)
  "Define keys for setting input method state"
  (dolist (keys off-keys)
    (let ((kseq (kbd keys)))
      (global-set-key kseq  'modeless-im-turn-off)
      (define-key isearch-mode-map kseq
	'modeless-im-isearch-turn-off)))
  (dolist (keys on-keys)
    (let ((kseq (kbd keys)))
      (global-set-key kseq  'modeless-im-turn-on)
      (define-key isearch-mode-map kseq 
	'modeless-im-isearch-turn-on))))

(provide 'modeless-im)
