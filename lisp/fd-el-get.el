;; EL-GET
(add-to-list 'load-path (concat dotemacs-dir "el-get/el-get"))

(require 'package)
(package-initialize)

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

	;; Elisp hepers
	f

	;; Python
	python
	django-mode
	jedi
	ein

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

	;; erc
	erc
	erc-highlight-nicknames
	;; erc-image

	;; Misc
	;;	slime
	;; helm
	;; nxhtml ; this is obsolete crap, stay away.
	realgud
	twiki-mode
	lua-mode
	textile-mode
	haskell-mode
	js2-mode
	coffee-mode
       ;;flymake-coffee-load
;;	slime
	;; swank-js
	json-mode
	graphviz-dot-mode
	cider
	ac-nrepl
	clojure-mode
	cscope
	cmake-mode
	multi-term
	yaml-mode
	autopair
	vimperator-mode
	c-eldoc
	dired-sort
	hide-region
	gist
	org-mode
	markdown-mode
	expand-region
	ggtags
	zencoding-mode
	git-emacs
	bm
	compilation-setup))

(setq
 el-get-sources
 '(el-get
   zencoding-mode
   python-pep8

   (:name yasnippet-snippets
	  :description "Some snippets."
	  :type github
	  :pkgname "AndreaCrotti/yasnippet-snippets"
	  :depends yasnippet
	  :post-init (add-to-list 'yas/root-directory
				  (concat el-get-dir
					  (file-name-as-directory "yasnippet-snippets"))))

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
   (:name compilation-setup
	  :description "Compilation that makes sense"
	  :type github
	  :pkgname "fakedrake/compilation-setup.el")

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

   (:name twiki-mode
	  :description "Major mode for editing Twiki wiki files
	  for emacs, plus 'twikish' command line tool to retrieve
	  and save twiki pages from text files."
	  :type github
	  :pkgname "christopherjwhite/emacs-twiki-mode")

   (:name smex				; a better (ido like) M-x
	  :after (progn
		   (setq smex-save-file (my-expand-path ".smex-items"))
		   (global-set-key (kbd "M-x") 'smex)
		   (global-set-key (kbd "M-X") 'smex-major-mode-commands)))

   (:name swank-js
	  :description "SLIME REPL and other development tools for in-browser JavaScript and Node.JS"
	  :type github
	  :pkgname "swank-js/swank-js"
	  :depends (js2-mode slime)
	  :after (let* ((slime-dir (el-get-package-directory "slime"))
			(swank-js-dir (el-get-package-directory "swank-js"))
			(slime-link (concat slime-dir "/contrib/slime-js.el"))
			(swank-el (concat swank-js-dir "/slime-js.el"))
			(npm-installed? (equal 0 (call-process-shell-command
						  "npm list -g swank-js")))
			(npm-install-cmd (format "npm install -g %s" swank-js-dir)))
		   ;; Make sur the file is there.
		   (unless (file-exists-p slime-link)
		     (make-symbolic-link swank-el slime-link))
		   (message "Installing swank-js: %s" npm-install-cmd)
		   (unless (or npm-installed?
			       (equal (call-process-shell-command npm-install-cmd) 0))
		     (error "Error during swank-js install to npm. (is prefix = .... in your ~/.npmrc?)")))
	  :features nil)

   (:name ido-ubiquitous
	  :description "Ido everywhere."
	  :type github
	  :pkgname "DarwinAwardWinner/ido-ubiquitous")

   (:name erc-image
	  :description "Image previews in erc."
	  :type github
	  :pkgname "kidd/erc-image.el")))

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
