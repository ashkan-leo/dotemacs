
;; CLIPBOARD
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value
      x-select-enable-primary t)

(defun clipboard-contents-normal (line-info)
  (if line-info
      (format "%s:%d" filename (current-line))
    filename))

(defvar clipboard-contents-fn 'clipboard-contents-normal
  "Given LINE-INFO non-nil return a string to be copied to clipboard")

(defun my-put-file-name-on-clipboard (&optional arg)
  "Put the current file name on the clipboard. With prefix copy
have <fname>:<linum>"
  (interactive "*P")
  (let* ((filename (file-truename
		    (if (equal major-mode 'dired-mode)
			default-directory
		      (buffer-file-name))))
	 (clip (funcall clipboard-contents-fn arg)))
    (when filename
      (save-excursion
	(with-temp-buffer
	  (insert clip)
	  (clipboard-kill-region (point-min) (point-max)))
	(message (format "Copied '%s'" clip))))))

(global-set-key (kbd "C-x y") 'my-put-file-name-on-clipboard)

(provide 'fd-clipboard)
