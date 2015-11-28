(require 'package)

(setq package-archives '(("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                         ("GELPA" . "http://internal-elpa.appspot.com/packages/")
                         ))

(package-initialize)

;; Automatically compile packages if they are not yet compiled
;; http://stackoverflow.com/questions/15342877/how-do-i-automatically-recompile-elpa-packages
(eval-when-compile '(require 'cl))
(require 'dash)
(require 's)

;; Org mode
;; This is on purpose not with other customizations.
;; It doesn't work if I put it there.
(load "~/.emacs.d/customizations/org-customizations.el")

(defun was-compiled-p (path)
  "Does the directory at PATH contain .elc files?"
  (--any-p (s-ends-with-p ".elc" it) (directory-files path)))

(defun no-dot-directories (directories)
  "Exclude the . and .. directory from a list."
  (--remove (or (string= "." (file-name-nondirectory it))
                (string= ".." (file-name-nondirectory it)))
            directories))

(defun ensure-packages-compiled ()
  "If any packages installed with package.el aren't compiled yet, compile them."
  (let* ((package-files (no-dot-directories (directory-files package-user-dir t)))
         (package-directories (-filter 'file-directory-p package-files)))
    (dolist (directory package-directories)
      (unless (was-compiled-p directory)
        (byte-recompile-directory directory 0)))))

(ensure-packages-compiled)

;; http://ethanschoonover.com/solarized
(load-theme 'solarized-dark t)

;;--- No Mouse Copy, Yank, Kill ---
(setq mouse-drag-copy-region nil)
(setq interprogram-paste-function 'x-selection-value)
(defun mouse-save-then-kill())
(defun mouse-yank-at-click())
(setq x-select-enable-clipboard t)

;; Indicate minibuffer depth: http://www.emacswiki.org/emacs/MinibufferDepthIndicator
(minibuffer-depth-indicate-mode 99)


;; Eshell customizations
(load "~/.emacs.d/customizations/eshell-customizations.el")

;; Evil Mode customizaations
(load "~/.emacs.d/customizations/evil-customizations.el")

;; Minibuffer Customizations
(load "~/.emacs.d/customizations/minibuffer-customizations.el")

;; In-buffer Customizations
(load "~/.emacs.d/customizations/inbuffer-customizations.el")

;; Open customization file
(global-set-key (kbd "C-x C-u")  (lambda () (interactive)
                                   (cd "~/.emacs.d/customizations/")
                                   (call-interactively 'find-file)))

;; Jabber accounts stored outside of source control
;; (load "~/jabber/secrets.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(grok-underline-policy (quote ((tag . hover) (link . hover) (declaration . hover) (reference . hover))))
 '(icicle-S-TAB-completion-methods-alist (quote (("apropos") ("scatter") ("Jaro-Winkler" . fuzzy-match))))
 '(icicle-TAB-completion-methods (quote (basic fuzzy vanilla)))
 '(icicle-file-sort (quote icicle-dirs-first-p))
 '(icicle-find-file-expand-directory-flag t)
 '(icicle-sort-orders-alist (quote (("by last use, dirs first" . icicle-dirs-and-latest-use-first-p) ("by last use as input" . icicle-latest-input-first-p) ("by abbrev frequency" . icicle-command-abbrev-used-more-p) ("by previous use alphabetically" . icicle-historical-alphabetic-p) ("by last use as input" . icicle-latest-input-first-p) ("by directories last" . icicle-dirs-last-p) ("by directories first" . icicle-dirs-first-p) ("by last use, dirs first" . icicle-dirs-and-latest-use-first-p) ("by file type" . icicle-file-type-less-p) ("by last file modification time" . icicle-latest-modification-first-p) ("by last file access time" . icicle-latest-access-first-p) ("by last use" . icicle-latest-use-first-p) ("by 2nd parts alphabetically" . icicle-2nd-part-string-less-p) ("case insensitive" . icicle-case-insensitive-string-less-p) ("proxy candidates first" . icicle-proxy-candidate-first-p) ("extra candidates first" . icicle-extra-candidates-first-p) ("special candidates first" . icicle-special-candidates-first-p) ("alphabetical" . icicle-case-string-less-p))))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(jabber-auto-reconnect t)
 '(jabber-avatar-cache-directory "~/jabber/avatar-cache")
 '(jabber-backlog-days 30.0)
 '(jabber-backlog-number 40)
 '(jabber-history-dir "~/jabber/history")
 '(jabber-history-enabled t)
 '(jabber-show-offline-contacts nil)
 '(python-indent-guess-indent-offset nil)
 '(python-indent-offset 2)
 '(tab-stop-list (quote (2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60)))
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-enter-indents-newline t)
 '(js2-indent-on-enter-key t))
 
;;;; Confiqure spell checking
(setq ispell-program-name "aspell")
(setq ispell-dictionary-alist
      '((nil
	 "[A-Za-z]" "[^A-Za-z]" "[']" nil
	 ("-B" "-d" "english" "--dict-dir"
	  "/usr/local/Cellar/aspell/0.60.6.1/lib/aspell-0.60")
	 nil iso-8859-1)))

;;;; Configure better buffer names : http://mnemonikk.org/2008/05/23/showing-the-current-directory-in-emacs-mode-line/#comment-221
(require 'uniquify)
 
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "|")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

;;;; Icicle locate http://www.emacswiki.org/emacs/Icicles_-_File-Name_Input#toc11
(global-set-key (kbd "C-x C-g") 'icicle-locate)

(global-set-key (kbd "C-x M-a")  'icicle-apropos-complete-and-narrow)

;;;; Find file in repository
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; Kill this buffer
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

;;;; Tramp
(require 'tramp)
(setq tramp-default-method "scp")
(setq password-cache-expiry 6000)

(defun sudo-find-file (file-name)
  "Like find file, but opens the file as root."
  (interactive "FSudo Find File: ")
  (let ((tramp-file-name (concat "/sudo:root@localhost:" (expand-file-name file-name))))
    (find-file tramp-file-name)))
; Then: alias sff 'sudo-find-file $1'

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(my-long-line-face ((((class color)) (:background "gray10"))) t)
 '(my-tab-face ((((class color)) (:background "grey10"))) t)
 '(my-trailing-space-face ((((class color)) (:background "gray10"))) t))

;;;; Global key bindings
(global-set-key (kbd "M-c") 'eshell)
(set-register ?e (cons 'file "~/.emacs")) ; "C-x r j e" to open .emacs
;;;; Fix universal-argument, which default key binding have been overriden by vim key binding
(global-unset-key (kbd "C-k"))
(global-set-key (kbd "C-k") 'universal-argument)

;; Enable line numbering
(require 'linum-relative)
(global-linum-mode 1)

;; Set emacs path to include /usr/local/bin . I know it's long, but I don't know why
;; to make it work fully I couldn't trim it
;; Use bash_profile for env variables:
(let ((path (shell-command-to-string ". ~/.bash_profile; echo -n $PATH")))
  (setenv "PATH" path)
  (setq exec-path 
        (append
         (split-string-and-unquote path ":")
         exec-path)))

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))
(setq exec-path-from-shell (append exec-path '("/usr/local/bin")))
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;; Add ~/bin to path
(setenv "PATH" (concat (getenv "PATH") ":/~/bin"))

;; Start emacsclient
(server-start)

;; Cmd as meta
(setq x-meta-keysym 'super)
(setq x-super-keysym 'meta)
(setq mac-command-modifier 'meta)
(setq mac-option-modifier nil)

;; Disable the menu bar
(dolist (mode '(menu-bar-mode tool-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

;; Key binding for eval region
(global-set-key (kbd "C-c e")  'eval-region)

;; Renaming current buffer
(global-set-key (kbd "C-x M-r")  'rename-buffer)


;; Open with default os method
;; Copied from: http://ergoemacs.org/emacs/emacs_dired_open_file_in_ext_apps.html
(defun ergoemacs-open-in-external-app ()
  "Open the current file or dired marked files in external app."
  (interactive)
  (let ( doIt
         (myFileList
          (cond
           ((string-equal major-mode "dired-mode") (dired-get-marked-files))
           (t (list (buffer-file-name))) ) ) )

    (setq doIt (if (<= (length myFileList) 5)
                   t
                 (y-or-n-p "Open more than 5 files?") ) )

    (when doIt
      (cond
       ((string-equal system-type "windows-nt")
        (mapc (lambda (fPath) (w32-shell-execute "open" (replace-regexp-in-string "/" "\\" fPath t t)) ) myFileList)
        )
       ((string-equal system-type "darwin")
        (mapc (lambda (fPath) (shell-command (format "open \"%s\"" fPath)) )  myFileList) )
       ((string-equal system-type "gnu/linux")
        (mapc (lambda (fPath) (let ((process-connection-type nil)) (start-process "" nil "xdg-open" fPath)) ) myFileList) ) ) ) ) )

(global-set-key (kbd "C-x M-o")  'ergoemacs-open-in-external-app)

;; Customize variable shortcut
(global-set-key (kbd "C-c C-v") 'customize-variable)


;;;; Desktop notifications from emacs
;; On Linux:
;; gsettings set com.canonical.notify-osd multihead-mode focus-follow
;; from console: notify-send "hello"

;; On Mac:
;; Install growlnotify from http://growl.info/downloads
;; From console growlnotify
(require 'notify)
;; To send notificaiton from emacs:
(notify "Emacs" "Initialization completed!")

;;;; Jabber mode config
(require 'jabber)

(defun notify-jabber-notify (from buf text proposed-alert)
  "(jabber.el hook) Notify of new Jabber chat messages via notify.el"
    (if (jabber-muc-sender-p from)
        (notify (format "(PM) %s"
                       (jabber-jid-displayname (jabber-jid-user from)))
               (format "%s: %s" (jabber-jid-resource from) text)))
      (notify (format "%s" (jabber-jid-displayname from))
             text))

(add-hook 'jabber-alert-message-hooks 'notify-jabber-notify)

;; Highlight urls
(add-hook 'jabber-chat-mode-hook 'goto-address)

;; Do not display connected/disconnected prompts
(setq jabber-alert-presence-message-function (lambda (who oldstatus newstatus statustext) nil))

(global-set-key (kbd "C-x C-a C-l") 'jabber-activity-switch-to)

(global-set-key (kbd "C-x C-a C-j") 'jabber-chat-with)
(global-set-key (kbd "C-x C-a C-c") 'jabber-connect-all)
(global-set-key (kbd "C-x C-a C-r") 'jabber-display-roster)

;; Make messages stop clobbering the echo area
(define-jabber-alert echo "Show a message in the echo area"
  (lambda (msg)
    (unless (minibuffer-prompt)
      (message "%s" msg))))

(defun git-grep (search)
  "git-grep the entire current repo"
  (interactive (list (completing-read "Search for: " nil nil nil (current-word))))
    (grep-find (concat "git --no-pager grep -P -n " search " `git rev-parse --show-toplevel`")))

(global-set-key (kbd "C-x M-g") 'git-grep)

(global-unset-key (kbd "C-c a"))
(global-unset-key (kbd "C-c x"))

(defun my-change-number-at-point (change)
  (interactive)
  (skip-chars-backward "0123456789")
  (or (looking-at "[0123456789]+")
      (error "No number at point"))
  (replace-match (number-to-string (funcall change (string-to-number (match-string 0))))))

(defun my-increment-number-at-point ()
  "Increment number at point like vim's C-a"
  (interactive)
  (my-change-number-at-point '1+))
(defun my-decrement-number-at-point ()
  "Decrement number at point like vim's C-x"
  (interactive)
  (my-change-number-at-point '1-))

(global-set-key (kbd "C-c a") 'my-increment-number-at-point)
(global-set-key (kbd "C-c x") 'my-decrement-number-at-point)
