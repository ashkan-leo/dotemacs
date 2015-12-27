;; ======================================================================
;; NodeJs debugger functions

(require 'gud)

;; History of argument lists passed to ndb.
(defvar gud-ndb-history nil)

;; Last group is for return value, e.g. "> test.py(2)foo()->None"
;; Either file or function name may be omitted: "> <string>(0)?()"
(defvar gud-ndb-marker-regexp
  "^> \\([-a-zA-Z0-9_/.:\\]*\\|<string>\\)(\\([0-9]+\\))\\([a-zA-Z0-9_]*\\|\\?\\|<module>\\)()\\(->[^\n\r]*\\)?[\n\r]")

(defvar gud-ndb-marker-regexp-file-group 1)
(defvar gud-ndb-marker-regexp-line-group 2)
(defvar gud-ndb-marker-regexp-fnname-group 3)

(defvar gud-ndb-marker-regexp-start "^> ")

;; There's no guarantee that Emacs will hand the filter the entire
;; marker at once; it could be broken up across several strings.  We
;; might even receive a big chunk with several markers in it.  If we
;; receive a chunk of text which looks like it might contain the
;; beginning of a marker, we save it here between calls to the
;; filter.
(defun gud-ndb-marker-filter (string)
  (setq gud-marker-acc (concat gud-marker-acc string))
  (let ((output ""))

    ;; Process all the complete markers in this chunk.
    (while (string-match gud-ndb-marker-regexp gud-marker-acc)
      (setq

       ;; Extract the frame position from the marker.
       gud-last-frame
       (let ((file (match-string gud-ndb-marker-regexp-file-group
				 gud-marker-acc))
	     (line (string-to-number
		    (match-string gud-ndb-marker-regexp-line-group
				  gud-marker-acc))))
	 (if (string-equal file "<string>")
	     gud-last-frame
	   (cons file line)))

       ;; Output everything instead of the below
       output (concat output (substring gud-marker-acc 0 (match-end 0)))
;;	  ;; Append any text before the marker to the output we're going
;;	  ;; to return - we don't include the marker in this text.
;;	  output (concat output
;;		      (substring gud-marker-acc 0 (match-beginning 0)))

       ;; Set the accumulator to the remaining text.
       gud-marker-acc (substring gud-marker-acc (match-end 0))))

    ;; Does the remaining text look like it might end with the
    ;; beginning of another marker?  If it does, then keep it in
    ;; gud-marker-acc until we receive the rest of it.  Since we
    ;; know the full marker regexp above failed, it's pretty simple to
    ;; test for marker starts.
    (if (string-match gud-ndb-marker-regexp-start gud-marker-acc)
	(progn
	  ;; Everything before the potential marker start can be output.
	  (setq output (concat output (substring gud-marker-acc
						 0 (match-beginning 0))))

	  ;; Everything after, we save, to combine with later input.
	  (setq gud-marker-acc
		(substring gud-marker-acc (match-beginning 0))))

      (setq output (concat output gud-marker-acc)
	    gud-marker-acc ""))

    output))

(defcustom gud-ndb-command-name "ndb"
  "File name for executing the Python debugger.
This should be an executable on your path, or an absolute file name."
  :type 'string
  :group 'gud)

;;;###autoload
(defun ndb (command-line)
  "Run ndb on program FILE in buffer `*gud-FILE*'.
The directory containing FILE becomes the initial working directory
and source-file directory for your debugger."
  (interactive
   (list (gud-query-cmdline 'ndb)))

  (gud-common-init command-line nil 'gud-ndb-marker-filter)
  (set (make-local-variable 'gud-minor-mode) 'ndb)

  (gud-def gud-break  "break %d%f:%l"  "\C-b" "Set breakpoint at current line.")
  (gud-def gud-remove "clear %d%f:%l"  "\C-d" "Remove breakpoint at current line")
  (gud-def gud-step   "step"         "\C-s" "Step one source line with display.")
  (gud-def gud-next   "next"         "\C-n" "Step one line (skip functions).")
  (gud-def gud-cont   "continue"     "\C-r" "Continue with display.")
  (gud-def gud-finish "return"       "\C-f" "Finish executing current function.")
  (gud-def gud-up     "up"           "<" "Up one stack frame.")
  (gud-def gud-down   "down"         ">" "Down one stack frame.")
  (gud-def gud-print  "p %e"         "\C-p" "Evaluate NodeJs expression at point.")
  ;; Is this right?
  (gud-def gud-statement "! %e"      "\C-e" "Execute Python statement at point.")

  ;; (setq comint-prompt-regexp "^(.*ndb[+]?) *")
  (setq comint-prompt-regexp "^(Ndb) *")
  (setq paragraph-start comint-prompt-regexp)
  (run-hooks 'ndb-mode-hook))
