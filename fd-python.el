;; Python

;; Fix docstring paragraph filling
(add-hook 'python-mode-hook (lambda ()
			      (setq paragraph-start (concat paragraph-start "\\|\\s-*\"\"\".*$"))))

(require 'python)
;; (defun py-my-indent-region (&optional min max)
;;   "Stupidly clamp indentation to the closest multiple of 4 spaces."
;;   (interactive)
;;   (save-excursion
;;     (let ((top (or min (point-min)))
;; 	  (bottom (or max (point-max)))
;; 	  (line-move-visual nil))
;;       (goto-char top)
;;       (while (<= (point) bottom)
;; 	(indent-line-to
;; 	 (* 4 (round (/ (float (current-indentation)) 4))))
;; 	(next-line) (end-of-line)))))


(define-key python-mode-map "\C-cp" '(lambda () (interactive) (insert "import ipdb; ipdb.set_trace()")))

(provide 'fd-python)