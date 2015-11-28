(require 'package)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("org" . "http://orgmode.org/elpa/")
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

;; Google Customizations
(load "~/.emacs.d/customizations/web-customizations.el")

;; Open customization file
(global-set-key (kbd "C-x C-u")  (lambda () (interactive)
                                   (cd "~/.emacs.d/customizations/")
                                   (call-interactively 'find-file)))

(load "~/secrets.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(debug-ignored-errors nil)
 '(debug-on-error t)
 '(eval-expression-debug-on-error t)
 '(icicle-S-TAB-completion-methods-alist (quote (("apropos") ("scatter") ("Jaro-Winkler" . fuzzy-match))))
 '(icicle-TAB-completion-methods (quote (basic fuzzy vanilla)))
 '(icicle-file-sort (quote icicle-dirs-first-p))
 '(icicle-find-file-expand-directory-flag t)
 '(icicle-sort-orders-alist (quote (("by last use, dirs first" . icicle-dirs-and-latest-use-first-p) ("by last use as input" . icicle-latest-input-first-p) ("by abbrev frequency" . icicle-command-abbrev-used-more-p) ("by previous use alphabetically" . icicle-historical-alphabetic-p) ("by last use as input" . icicle-latest-input-first-p) ("by directories last" . icicle-dirs-last-p) ("by directories first" . icicle-dirs-first-p) ("by last use, dirs first" . icicle-dirs-and-latest-use-first-p) ("by file type" . icicle-file-type-less-p) ("by last file modification time" . icicle-latest-modification-first-p) ("by last file access time" . icicle-latest-access-first-p) ("by last use" . icicle-latest-use-first-p) ("by 2nd parts alphabetically" . icicle-2nd-part-string-less-p) ("case insensitive" . icicle-case-insensitive-string-less-p) ("proxy candidates first" . icicle-proxy-candidate-first-p) ("extra candidates first" . icicle-extra-candidates-first-p) ("special candidates first" . icicle-special-candidates-first-p) ("alphabetical" . icicle-case-string-less-p))))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 ;; '(jabber-alert-presence-message-function (lambda (who oldstatus newstatus statustext) nil))
 '(jabber-backlog-days 30.0)
 '(jabber-backlog-number 40)
 '(jabber-history-enabled t)
 '(tab-stop-list (quote (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))
 

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

;;;; Find file in repository
(global-set-key (kbd "C-x f") 'find-file-in-repository)

;; Kill this buffer
(global-set-key (kbd "C-x C-k") 'kill-this-buffer)

;;;; Tramp
(require 'tramp)
(setq tramp-default-method "scp")

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
 )

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
;; Highlight links
(add-hook 'jabber-chat-mode-hook 'goto-address)

(defun notify-jabber-notify (from buf text proposed-alert)
  "(jabber.el hook) Notify of new Jabber chat messages via notify.el"
  (when (or jabber-message-alert-same-buffer
            (not (memq (selected-window) (get-buffer-window-list buf))))
    (if (jabber-muc-sender-p from)
        (notify (format "(PM) %s"
                       (jabber-jid-displayname (jabber-jid-user from)))
               (format "%s: %s" (jabber-jid-resource from) text)))
      (notify (format "%s" (jabber-jid-displayname from))
             text)))

(add-hook 'jabber-alert-info-message-hooks 'notify-jabber-notify)

(add-hook 'jabber-alert-message-hooks 'notify-jabber-notify)

