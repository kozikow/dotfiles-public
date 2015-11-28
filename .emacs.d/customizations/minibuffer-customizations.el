(global-set-key (kbd "C-S-f") 'helm-ag)

;;;; Ido mode. Configure later.
;; (setq ido-enable-flex-matching t)
;;;; (setq ido-everywhere t)
;;;; (ido-mode 1)

;; ;; ;;;; Helm mode
(require 'helm-config)
;; (helm-mode 1)

;; Icicles
(require 'icicles)
(icy-mode 1)
(require 'lacarte)

(global-set-key [M-x] 'lacarte-execute-command)
(global-set-key [f10] 'lacarte-execute-menu-command)

;; (global-set-key (kbd "C-x c g") 'helm-do-grep)
;; (global-set-key (kbd "C-x c o") 'helm-occur)
;; (global-set-key (kbd "M-x") 'helm-M-x)

;; ;;;; Ido directory history
;; (defun eshell-get-dir-from-dir-ring (dir-name)
;;   "Interactively select directory from eshell-last-dir-ring"
;;   (interactive (list (flet ((iswitchb-make-buflist
;;                              (default)
;;                              (setq iswitchb-buflist (ring-elements eshell-last-dir-ring))))
;;                        (iswitchb-read-buffer "Change to directory: "))))
;;   dir-name)

;; (defun eshell-electric-insert-dir ()
;;   "Handy when copying and moving files to, or changing to a certain
;; directory. On the prompt, type a space, a colon (`:') and call this function,
;; preferably bound to the TAB key."
;;   (interactive)
;;   (if (save-excursion
;;         (goto-char (- (point) 2))
;;         (if (looking-at " :")
;;             t
;;           nil))
;;       (let ((dir (call-interactively 'eshell-get-dir-from-dir-ring)))
;;         (delete-char -1)
;;         (insert (pcomplete-quote-argument dir)))
;;     (pcomplete)))

;; ;; ;;;; Display IDO results vertically, rather than horizontally
;; (setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))

;; ;; ;;;; C-n and C-p ido key binding
;; (defun ido-define-keys () ;; C-n/p is more intuitive in vertical layout
;;   (define-key ido-completion-map (kbd "C-n") 'ido-next-match)
;;   (define-key ido-completion-map (kbd "C-p") 'ido-prev-match))
;; (add-hook 'ido-setup-hook 'ido-define-keys)
