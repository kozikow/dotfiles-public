;; Note: move some of this into *my-emacs-lib-dir*/eshell/profile ? See
;; the function eshell-script-initialize in em-script.el.

(setq eshell-history-size 1024)
(setq eshell-prompt-regexp "^[^#$]*[#$] ")

(load "em-hist")                        ; So the history vars are defined
(setq eshell-cmpl-cycle-completions nil
      eshell-save-history-on-exit t
      eshell-cmpl-dir-ignore "\\`\\(\\.\\.?\\|CVS\\|\\.svn\\|\\.git\\)/\\'")
 
;; (defun eshell/ef (fname-regexp &rest dir) (ef fname-regexp default-directory))

;;; ---- path manipulation

(defun pwd-repl-home (pwd)
  (interactive)
  (let* ((home (expand-file-name (getenv "HOME")))
         (home-len (length home)))
    (if (and
         (>= (length pwd) home-len)
         (equal home (substring pwd 0 home-len)))
        (concat "~" (substring pwd home-len))
      pwd)))

(defun curr-dir-git-branch-string (pwd)
  "Returns current git branch as a string, or the empty string if
PWD is not in a git repo (or the git command is not found)."
  (interactive)
  (when (and (eshell-search-path "git")
             (locate-dominating-file pwd ".git"))
    (let ((git-output (shell-command-to-string (concat "git branch | grep '\\*' | sed -e 's/^\\* //'"))))
      (concat "[g:"
              (if (> (length git-output) 0)
                  (substring git-output 0 -1)
                "(no branch)")
              "] "))))

(defun curr-dir-svn-string (pwd)
  (interactive)
  (when (and (eshell-search-path "svn")
             (locate-dominating-file pwd ".svn"))
    (concat "[s:"
            (cond ((string-match-p "/trunk\\(/.*\\)?" pwd)
                   "trunk")
                  ((string-match "/branches/\\([^/]+\\)\\(/.*\\)?" pwd)
                   (match-string 1 pwd))
                  (t
                   "(no branch)"))
            "] ")))

(setq eshell-prompt-function
      (lambda ()
        (concat
         (or (curr-dir-git-branch-string (eshell/pwd))
             (curr-dir-svn-string (eshell/pwd)))
         ((lambda (p-lst)
            (if (> (length p-lst) 3)
                (concat
                 (mapconcat (lambda (elm) (if (zerop (length elm)) ""
                                            (substring elm 0 1)))
                            (butlast p-lst 3)
                            "/")
                 "/"
                 (mapconcat (lambda (elm) elm)
                            (last p-lst 3)
                            "/"))
              (mapconcat (lambda (elm) elm)
                         p-lst
                         "/")))
          (split-string (pwd-repl-home (eshell/pwd)) "/"))
         "$ ")))

;; ; From http://www.emacswiki.org/cgi-bin/wiki.pl/EshellWThirtyTwo
;; ; Return nil, otherwise you'll see the return from w32-shell-execute
;; (defun eshell/open (file)
;;   "Invoke (w32-shell-execute \"Open\" FILE) and substitute slashes for
;; backslashes"
;;   (w32-shell-execute "Open" (substitute ?\\ ?/ (expand-file-name file)))
;;   nil)

(add-hook 'eshell-mode-hook
          '(lambda ()
             (local-set-key "\C-c\C-q" 'eshell-kill-process)
             (local-set-key "\C-c\C-k" 'compile)))

;; (add-hook 'eshell-post-command-hook
;;           '(lambda ()
;;              (notify "finished" "bb")
;;              ))

;; scroll to the bottom on output
(setq eshell-scroll-to-bottom-on-output t)
(setq eshell-scroll-show-maximum-output t)

;; eshell history save like bash history save
(setq eshell-hist-ignoredups t)

;; Helm shell history
(add-hook 'eshell-mode-hook
          #'(lambda ()
              (define-key eshell-mode-map
                (kbd "M-r")
                'helm-eshell-history)))

;; Helm Shell command completion
;; (add-hook 'shell-mode-hook 'pcomplete-shell-setup)
;; (add-hook 'shell-mode-hook
;;           #'(lambda ()
;;               (define-key shell-mode-map [remap pcomplete] 'helm-shell-pcomplete)))

;; Helm with pcomplete
;; (add-hook 'eshell-mode-hook
;;           #'(lambda ()
;;               (define-key eshell-mode-map
;;                 [remap eshell-pcomplete]
;;                 'helm-esh-pcomplete)))

(global-set-key (kbd "<f1>") 'eshell)

(eval-after-load 'esh-opt
  '(progn
     (require 'em-cmpl)
     (require 'em-prompt)
     (require 'em-term)
     ;; TODO: for some reason requiring this here breaks it, but
     ;; requiring it after an eshell session is started works fine.
     ;; (require 'eshell-vc)
     (setenv "PAGER" "cat")
     (set-face-attribute 'eshell-prompt nil :foreground "turquoise1")
     (add-hook 'eshell-mode-hook ;; for some reason this needs to be a hook
	       '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-bol)))
     (add-to-list 'eshell-visual-commands "ssh")
     (add-to-list 'eshell-visual-commands "tail")
     (add-to-list 'eshell-command-completions-alist
		  '("gunzip" "gz\\'"))
     (add-to-list 'eshell-command-completions-alist
		  '("tar" "\\(\\.tar|\\.tgz\\|\\.tar\\.gz\\)\\'"))
     (add-to-list 'eshell-output-filter-functions 'eshell-handle-ansi-color)
     ))

(add-to-list 'load-path "~/.emacs.d/raw_packages/pcmpl-args.el")
(require 'pcmpl-args)

;; Start from ~ . Other methods wasn't working for me.
(add-hook 'eshell-mode-hook
          '(lambda ()
             (cd "~")))

;; Add directory tracking to eshell: http://www.emacswiki.org/emacs/ShellDirtrackByProcfs
(defun track-shell-directory/procfs ()
    (shell-dirtrack-mode 0)
    (add-hook 'comint-preoutput-filter-functions
              (lambda (str)
                (prog1 str
                  (when (string-match comint-prompt-regexp str)
                    (cd (file-symlink-p
                         (format "/proc/%s/cwd" (process-id
                                                 (get-buffer-process
                                                  (current-buffer)))))))))
              nil t))

(add-hook 'shell-mode-hook 'track-shell-directory/procfs)

;; Killing the malfunctioning eshell buffer
;; http://comments.gmane.org/gmane.emacs.bugs/72504
(global-set-key (kbd "C-x x")  (lambda()
                                   (let ((inhibit-read-only t)) (kill-this-buffer))
                                   ))

;; Eshell notify
(setq notify-delay '(0 0 0))
(load "~/.emacs.d/customizations/eshell-notify.el")
