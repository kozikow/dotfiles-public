(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/org/work.org"
                             "~/org/home.org"))

(setq org-default-notes-file "~/org/notes.org")
(define-key global-map "\C-cr" 'org-capture)
(setq org-capture-templates
      '(
        ("t" "Todo" entry (file+headline "~/org/todo.org" "Uncategorized")
         "* TODO %?\n  %i\n  %a")
        ("p" "Personal" entry (file+headline "~/org/personal.org" "Uncategorized")
         "* %i\n  %a")
        ("w" "Work" entry (file+headline "~/org/work.org" "Uncategorized")
         "* %i\n  %a")
        ))

;; Shortcut to focus on current subtree in org mode
(global-set-key (kbd "C-c C-f")  (lambda()
                                   (org-narrow-to-subtree)
                                   (widen)))

(global-set-key (kbd "C-c C-g")  (lambda()
                                   (interactive)
                                   (shell-command "python ~/github/dotfiles/syncer.py")
                                   (find-alternate-file buffer-file-name)))
