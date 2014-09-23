(require 'js2-mode)
(require 'slime-js)
(setq slime-js-swank-command "/usr/sbin/npm")

(defvar fd-js-etags-gen-command (replace-in-string
				 "find . \! -name '.*' -regex '.*\.jsm?' |
xargs etags --language=none
--regex='/.*?\\([a-zA-Z0-9_]*\\)[ \\n\\t]*=[ \\t]*function[ \\n\\t]*(/\\1/'
--regex='/[ \\t]*\\([a-zA-Z0-9_]*\\)[ \\n\\t]*:/\\1/'
--regex='/[ \\t,;]*function[ \\t\\n]*\\([a-zA-Z0-9_]*\\)[ \\t\\n]*(/\\1/'
--regex='/^var[ \\t\\n]*\\([a-zA-Z0-9_]*\\)/\\1/'
" "\n" " ")
  "Find assigned functions, defined functions, object/dictionary
  properties that are preceeded by spaces and top level
  variables")


(defun fd-js-mode-hook ()
  "Hooks for all clojure."
  (slime-js-minor-mode 1)
  (setq-local etags-table-create-table-command-string
	      fd-js-etags-gen-command))


(add-hook 'js2-mode-hook 'fd-js-mode-hook)

(provide 'fd-javascript)
