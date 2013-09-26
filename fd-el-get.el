;; EL-GET
(add-to-list 'load-path (concat dotemacs-dir "el-get/el-get"))

(unless (require 'el-get nil t)
  (url-retrieve
   "https://raw.github.com/dimitri/el-get/master/el-get-install.el"
   (lambda (s)
     (let (el-get-master-branch)
       (goto-char (point-max))
       (eval-print-last-sexp)))))

(setq my:el-get-packages
      '(;; Dependencies from who-kows-where
	dash
	s
	pkg-info
	request

	;; Python
	python
	django-mode
	jedi

	;; Auto Complete packages
	yasnippet
	yasnippet-snippets
	auto-complete

	;; themes I like
	naquadah-theme

	;; ido
	ido-mode-el
	ido-speed-hack
	ido-better-flex
	ido-ubiquitous
	smex

	;; Misc
	;;	slime
	multi-term
	yaml-mode
	autopair
	nrepl
	vimperator-mode
	c-eldoc
	dired-sort
	hide-region
	gist
	org-mode
	markdown-mode
	expand-region
	etags-table
	zencoding-mode
	git-emacs
	bm
	goto-last-change
	find-file-in-project
	undo-tree))

(setq
 el-get-sources
 '(el-get
   zencoding-mode
   python-pep8
   python-mode

   (:name yasnippet-snippets
	  :description "Some snippets."
	  :type github
	  :pkgname "AndreaCrotti/yasnippet-snippets"
	  :depends yasnippet
	  :post-init (add-to-list 'yas/root-directory
				    (concat el-get-dir
					    (file-name-as-directory "yasnippet-snippets"))))

   (:name org2blog
       :description "Blog from Org mode to wordpress"
       :type github
       :pkgname "punchagan/org2blog"
       :depends (metaweblog.el xml-rpc-el)
       :features org2blog)

   (:name python
	  :description "Python's flying circus support for Emacs"
	  :type github
	  :pkgname "fgallina/python.el"
	  :branch "emacs-24")

   (:name vimperator-mode
	  :description "Edit vimperator files"
	  :type github
	  :pkgname "xcezx/vimperator-mode")

   (:name undo-tree
	  :description "Visualize undo history as a tree"
	  :type github
	  :pkgname "emacsmirror/undo-tree")

   (:name etags-table
	  :description "Etags is smart enough to look for a table in fs."
	  :type github
	  :pkgname "fakedrake/etags-table")

   ;; This is temporary until the pull request is dealt with in upstream
   (:name find-file-in-project
	  :description "Find a file in the current project"
	  :type github
	  :pkgname "fakedrake/find-file-in-project")

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

   (:name bm
	  :description "Simple bookmark manager"
	  :type github
	  :pkgname "joodland/bm")

   (:name smex				; a better (ido like) M-x
	  :after (progn
		   (setq smex-save-file (my-expand-path ".smex-items"))
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

(provide 'fd-el-get)
