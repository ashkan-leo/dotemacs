;; Terminals
;;
;; TODO: Have an org mode style buffer switcher.

(autoload 'multi-term "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)

(setq multi-term-program "/bin/zsh") ;; or use zsh...

(defun fd-term-beginning-of-line ()
  (interactive)
  (term-send-raw-string (kbd "C-a")))

(defalias 'fd-replace 'replace-regexp-in-string)

;; The cursor position does not really match very well with the
;; terminal cursor position. Here is a helper to match them.
(defmacro fd-term-map-key (key &optional mkey)
  "Map key to mkey. If mkey is nil map to self."
  `(define-key term-raw-map (kbd ,key)
     ',(if mkey
	   `(lambda () (interactive) (term-send-raw-string
				      ,(read-kbd-macro (fd-replace "M-" "ESC "
								   mkey)))))))

(defun fd-term-mode-hook ()
  (setq autopair-dont-activate t)
  ;; Add your keyboard mappings here.
  (fd-term-map-key "M-b" "M-b")
  (fd-term-map-key "M-f" "M-f")
  (fd-term-map-key "M-DEL" "M-DEL")
  (fd-term-map-key "M-m" "C-a")
  (fd-term-map-key "<M-left>" "M-b")
  (fd-term-map-key "<M-right>" "M-f")
  (fd-term-map-key "<C-left>" "M-b")
  (fd-term-map-key "<C-right>" "M-f"))

(defun kill-all-terminals (&optional dont-ask)
  "Kill all terminal buffers asking just once. If dont-ask is
non-nil do not ask the user."
  (interactive)
  (when (or dont-ask (y-or-n-p "Kill all terminal buffers?"))
    (let ((kill-buffer-query-functions))
      (mapcar 'kill-buffer (fd-mode-buffers 'term-mode)))))

;; only needed if you use autopair
(add-hook 'term-mode-hook 'fd-term-mode-hook)

(defun ido-term-buffer()
  (interactive)
  (ido-for-mode "Term buffer: " 'term-mode))

(global-set-key (kbd "C-c t") 'ido-term-buffer)
(global-set-key (kbd "C-c T") 'multi-term) ;; create a new one

(add-to-list 'ido-ignore-buffers
	     (format "\*%s<[0-9]*>\*" multi-term-buffer-name))

(defadvice term-send-raw (after update-current-directory activate)
  (let* ((pid (process-id (get-buffer-process (current-buffer))))
         (cwd (file-truename (format "/proc/%d/cwd" pid))))
    (cd cwd)))


;; XXX: this was supposed to not allow me to switch when killing buffers
;;
;; (defadvice switch-to-buffer (around bury-terminal activate)
;;   (if (eq major-mode 'term-mode)
;;       (let ((term (current-buffer)))
;; 	ad-do-it
;; 	(message (format "Burying term buffer %s" (buffer-name term)))
;; 	(bury-buffer term))
;;     ad-do-it))

(provide 'fd-term)
