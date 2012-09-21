(require 'cl)

;; EL-GET
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'exec-path "~/bin/")


;; Ensure that personal.el exists
(cond ((not (file-readable-p "~/.emacs.d/personal.el"))
       (progn
	 (copy-file "~/.emacs.d/dummy-personal.el" "~/.emacs.d/personal.el")
	 (message "Copied dummy personal preferences to personal.el"))))

(load-file   "~/.emacs.d/personal.el")


(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp)))))

(setq my:el-get-packages
      '(
	;; Python
	ipython
	python-mode
	python-pep8
	pylookup

	;; Auto Complete packages
	yasnippet
	auto-complete

	;; themes I like
	tomorrow-night-paradise-theme
	naquadah-theme
	obsidian-theme

	;; ido
	ido-mode-el
	ido-speed-hack
	ido-better-flex
	ido-ubiquitous
	smex

	;; Misc
	markdown-mode
	expand-region
	etags-table
	zencoding-mode
	git-emacs
	visual-basic-mode
	bm
	goto-last-change
	find-file-in-project
	xml-rpc lisppaste
	undo-tree))

(setq
 el-get-sources
 '(el-get
   zencoding-mode
   python-pep8
   python-mode
   git-emacs
   visual-basic-mode

   (:name obsidian-theme
	  :description "My theme"
	  :type github
	  :pkgname "fakedrake/obsidian-theme")

   ;; This is temporary until the pull request is dealt with in upstream
   (:name find-file-in-project
	  :description "Find a file in the current project"
	  :type github
	  :pkgname "fakedrake/find-file-in-project"
	  :compile "find-file-in-project.el")

   (:name ido-better-flex
	  :description "Better flex matching for ido"
	  :type github
	  :pkgname "orfelyus/ido-better-flex"
	  :compile "ido-better-flex.el")

   (:name ido-mode-el
	  :description "Better flex matching for ido"
	  :type github
	  :pkgname "orfelyus/ido-mode-el"
	  :compile "ido.el")

   (:name ido-speed-hack
	  :description "Better flex matching for ido"
	  :type github
	  :pkgname "orfelyus/ido-speed-hack"
	  :compile "ido-speed-hack.el")

   (:name yasnippet
	  :website "https://github.com/capitaomorte/yasnippet.git"
	  :description "YASnippet is a template system for Emacs."
	  :type github
	  :pkgname "capitaomorte/yasnippet"
	  :features "yasnippet"
	  :compile "yasnippet.el")

   (:name yasnippet
	  :website "https://github.com/capitaomorte/yasnippet.git"
	  :description "YASnippet is a template system for Emacs."
	  :type github
	  :pkgname "capitaomorte/yasnippet"
	  :features "yasnippet"
	  :compile "yasnippet.el")

   (:name bm
	  :description "Simple bookmark manager"
	  :type github
	  :pkgname "joodland/bm")

   (:name smex				; a better (ido like) M-x
	  :after (progn
		   (setq smex-save-file "~/.emacs.d/.smex-items")
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))
   (:name goto-last-change		; move pointer back to last change
	  :after (progn
		   ;; when using AZERTY keyboard, consider C-x C-_
		   (global-set-key (kbd "C-x C-/") 'goto-last-change)))))

;;
;; Some recipes require extra tools to be installed
;;
;; Note: el-get-install requires git, so we know we have at least that.
;;
(when (el-get-executable-find "cvs")
  (add-to-list 'el-get-sources 'emacs-goodies-el)) ; the debian addons for emacs

(when (el-get-executable-find "svn")
  (loop for p in '(psvn    		; M-x svn-status
		   yasnippet		; powerful snippet mode
		   )
	do (add-to-list 'el-get-sources p)))

(el-get 'sync my:el-get-packages)

;; on to the visual settings
(require 'naquadah-theme)
(load-theme 'naquadah t)
(let ((comment "IndianRed2"))
  (custom-theme-set-faces
   'naquadah
   `(mode-line ((t (:height 1.1 :background "gray30"))))
   `(minibuffer-prompt ((t (:foreground "orange1"))))
   `(region ((t (:background "gray25"))))

   ;; Development
   `(font-lock-comment-face ((t (:foreground ,comment))))
   `(font-lock-function-name-face ((t (:foreground "orange1" :bold t))))
   `(font-lock-doc-face ((t (:foreground ,comment))))
   `(font-lock-doc-string-face ((t (:foreground ,comment))))
   `(link ((t (:foreground  "#729fcf" :underline t))))

   ;; ERC
   `(erc-prompt-face ((t (:background "#f57900" :bold t :foreground "gray10"))))))

(line-number-mode 1)	; have line numbers and
(column-number-mode 1)	; column numbers in the mode line
(mouse-avoidance-mode 'banish)
(tool-bar-mode -1)	; no tool bar with icons
(scroll-bar-mode -1)	; no scroll bars
(add-hook 'find-file-hook (lambda () (setq show-trailing-whitespace t)))
(global-linum-mode 1)	; add line numbers on the left

;; CLIPBOARD
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value
      x-select-enable-primary t)

;; full screen
(defun fullscreen ()
  (interactive)
  (set-frame-parameter nil 'fullscreen
		       (if (frame-parameter nil 'fullscreen) nil 'fullboth)))
(global-set-key [f11] 'fullscreen)

;; Ido mode
(require 'ido)
(require 'ido-speed-hack)
(require 'ido-better-flex)
(require 'ido-ubiquitous)
(ido-mode t)
(setq ido-save-directory-list-file "~/.emacs.d/.ido.last")
(setq ido-enable-flex-matching t)
(setq ido-auto-merge-work-directories-length -1)
(ido-everywhere t)
;; This is mainly for just swapped letters. It sometimes doesnt catch
;; entire words
(ido-better-flex/enable)
;; (setq ido-file-extensions-order '(".c" ".cpp" ".h" ".py" ".txt" ".emacs" ".xml" ".el" ".ini" ".cfg" ".cnf"))



;; Basic stuff
(require 'uniquify)

(setq-default
 frame-title-format
 (list '((buffer-file-name " %f" (dired-directory
                                  dired-directory
                                  (revert-buffer-function " %b"
                                                          ("%b - Dir:  " default-directory)))))))

(require 'server)
(if (server-running-p)
    (message "Skipping server creation, one already exists")
  (server-start))
(delete-selection-mode t)
(show-paren-mode t)
(electric-pair-mode t)
(global-hl-line-mode t)
(set-face-attribute 'default nil :height 90)
(setq backup-directory-alist '(("." . "~/.emacs.d/backup/")))
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(setq require-final-newline 'query)
(set-input-method 'greek)
(toggle-input-method)
(setq scroll-step 1)
(global-set-key "\C-Z" 'revert-buffer)
(add-hook 'term-mode-hook (lambda() (yas-minor-mode -1))) ;; fix tabcompletion

(add-to-list 'auto-mode-alist '("[.]zcml" . nxml-mode))
(add-to-list 'auto-mode-alist '("[.]pt" . html-mode))

;; Indent buffer
(defun indent-buffer ()
  "Indents an entire buffer using the default intenting scheme."
  (interactive)
  (save-excursion
    (delete-trailing-whitespace)
    (indent-region (point-min) (point-max) nil)))
(global-set-key "\C-x\\" 'indent-buffer)

;; YASnippet
(require 'yasnippet)
(setq yas-snippet-dirs "~/.emacs.d/el-get/yasnippet/snippets/")
(yas--initialize)
(yas/load-directory yas-snippet-dirs)



;; Auto Complete
(require 'auto-complete)
(require 'auto-complete-config)
;; (require 'auto-complete+)
;; (require 'auto-complete-extension)
;; (require 'auto-complete-yasnippet)
;; (require 'auto-complete-etags)
;; (require 'ac-python)
;; (require 'auto-complete-emacs-lisp)
(set-default 'ac-sources '(ac-source-abbrev ac-source-dictionary ac-source-filename ac-source-words-in-same-mode-buffers))
(add-to-list 'ac-dictionary-directories (expand-file-name "dictionaries"))
(add-to-list 'ac-modes '(org-mode))
(setq ac-use-fuzzy t)
(ac-config-default)

;; ORG mode
(add-hook 'org-mode-hook
          '(lambda ()
             (define-key org-mode-map "\M-j" 'org-meta-return)))
(add-hook 'org-mode-hook
          '(lambda ()
             (define-key org-mode-map [(tab)] nil)))
(require 'org)

;; Set up org-mode capture system
(if (and (file-exists-p my-orgmode-agenda-dir)
	 (eq t (car (file-attributes my-orgmode-agenda-dir)))) ; It is actually a directory
    (setq org-default-notes-file (concat my-orgmode-agenda-dir my-notes-file))
  (message (format "Ormode directory is not valid: %s" my-orgmode-agenda-dir)))

;; Org mode key bindings
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;; Org agenda
(setq org-agenda-files (list my-orgmode-agenda-dir)
      org-hierarchical-todo-statistics nil
      org-support-shift-select 'always)

;; Python
(setq py-mode-map python-mode-map)
(setq ipython-command "/usr/bin/ipython2")
(setq ipython-completion-command-string "print(';'.join(__IP.Completer.all_completions('%s')))\n")
(require 'python-mode)
(require 'ipython)
(define-key python-mode-map "\C-cp" '(lambda () (interactive) (insert "import ipdb; ipdb.set_trace()")))
(define-key python-mode-map "\C-ch" 'pylookup-lookup)


;; desktop
(require 'desktop)
(desktop-save-mode t)
(setq desktop-buffers-not-to-save
      (concat "\\("
	      "^nn\\.a[0-9]+\\|\\.log\\|(ftp)\\|^tags\\|^TAGS"
	      "\\|\\.emacs.*\\|\\.diary\\|\\.newsrc-dribble\\|\\.bbdb"
	      "\\)$"))
(add-to-list 'desktop-modes-not-to-save 'dired-mode)
(add-to-list 'desktop-modes-not-to-save 'Info-mode)
(add-to-list 'desktop-modes-not-to-save 'info-lookup-mode)
(add-to-list 'desktop-modes-not-to-save 'fundamental-mode)

(setq history-length 250)
(add-to-list 'desktop-globals-to-save 'file-name-history)
(setq make-backup-files nil)


;; UNDO TREE
(require 'undo-tree)
(global-undo-tree-mode t)

;; RECENT FILES
(require 'recentf)
(recentf-mode t)
(setq recentf-max-saved-items 100)
(defun steve-ido-choose-from-recentf ()
  "Use ido to select a recently opened file from the `recentf-list'"
  (interactive)
  (find-file (ido-completing-read "Open file: " recentf-list nil t)))
(global-set-key [(meta f11)] 'steve-ido-choose-from-recentf)

;; ERC
;; check channels
(require 'erc)

(erc-track-mode t)
(setq erc-track-exclude-types '("JOIN" "NICK" "PART" "QUIT" "MODE"
				"324" "329" "332" "333" "353" "477"))
;; don't show any of this
(setq erc-hide-list '("JOIN" "PART" "QUIT" "NICK"))

;; joining && autojoing

;; make sure to use wildcards for e.g. freenode as the actual server
;; name can be be a bit different, which would screw up autoconnect
(erc-autojoin-mode t)
(setq erc-autojoin-channels-alist
      '((".*\\.freenode.net" "#emacs")
	(".*\\.freenode.net" "#archlinux")))

(defun fakedrake-erc-start-or-switch ()
  "Connect to ERC, or switch to last active buffer"
  (interactive)
  (if (get-buffer "irc.freenode.net:6667") ;; ERC already active?
      (erc-track-switch-buffer 1) ;; yes: switch to last active
    (when (y-or-n-p "Start ERC? ") ;; no: maybe start ERC
      (erc :server "irc.freenode.net" :port 6667 :nick my-freenode-nick :full-name my-freenode-fullname :password my-freenode-password))))

(defun my-destroy-erc ()
  "Kill all erc buffers!!"
  (interactive)
  (save-excursion
    (dolist (i (buffer-list))
      (with-current-buffer i
	(cond
	 ((eq major-mode 'erc-mode) (kill-buffer (current-buffer))))))))
;; switch to ERC with Ctrl+c e
(global-set-key (kbd "C-c e s") 'fakedrake-erc-start-or-switch) ;; ERC
(global-set-key (kbd "C-c e k") 'my-destroy-erc)


(require 'lisppaste)


;; BOOKMARKS
(require 'bm)
(setq bm-highlight-style nil)
(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)

;; ETAGS
(require 'etags-table)
(setq etags-table-search-up-depth 10)
(add-to-list 'ido-ubiquitous-command-exceptions 'find-tag)

;; Expand region
(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-+") 'er/contract-region)


;; Find file in project
(require 'find-file-in-project)
(global-set-key (kbd "C-x f") 'find-file-in-project)
(setq ffip-full-paths t)

(put 'narrow-to-region 'disabled nil)


(defun djcb-zoom (n)
  "with positive N, increase the font size, otherwise decrease it"
  (set-face-attribute 'default (selected-frame) :height
		      (+ (face-attribute 'default :height) (* (if (> n 0) 1 -1) 10)))
  (message (format "Font size: %d" (face-attribute 'default :height))))

(global-set-key (kbd "M-+")      '(lambda nil (interactive) (djcb-zoom 1)))
(global-set-key (kbd "M--")      '(lambda nil (interactive) (djcb-zoom -1)))

;; PATH in emacs
(defun set-exec-path-from-shell-PATH ()
  (interactive)
  (let ((path-from-shell (car (reverse (split-string (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(if window-system (set-exec-path-from-shell-PATH))
