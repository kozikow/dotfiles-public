;; Emacs customizations for editing web related files (js, css, html)
;; Some things are based on https://wiki.corp.google.com/twiki/bin/view/Main/EmacsJavaScript

;; to try:
;; https://github.com/fxbois/web-mode
;; https://github.com/magnars/angular-snippets.el
;; https://sites.google.com/a/google.com/gmail-frontend-engineering/setup-emacs-for-javascript-development

;; Javascript plugin
(require 'js2-mode)
(autoload 'js2-mode (format "js2-emacs%d" emacs-major-version) nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(grok-underline-policy (quote ((tag . hover) (link . hover) (declaration . hover) (reference . hover))))
 '(js2-bounce-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-enter-indents-newline t)
 '(js2-basic-offset 2)
 '(js2-indent-on-enter-key t))

;; javascript linter
(defun js-lint (num)
  "Run the js linter on the specified CL "
  (interactive "nCL: ")
  (compile
   (concat
    "--strict "
    "--unix_mode "
    "-c "
        (number-to-string num))))

;; Mutliweb mode
(require 'multi-web-mode)
(setq mweb-default-major-mode 'html-mode)
(setq mweb-tags '((php-mode "<\\?php\\|<\\? \\|<\\?=" "\\?>")
                  (js-mode "<script +\\(type=\"text/javascript\"\\|language=\"javascript\"\\)[^>]*>" "</script>")
                  (css-mode "<style +type=\"text/css\"[^>]*>" "</style>")))
(setq mweb-filename-extensions '("php" "htm" "html" "ctp" "phtml" "php4" "php5" "ng"))
(multi-web-global-mode 1)

(require 'fill-column-indicator)
(add-hook 'js2-mode-hook '(lambda () (setq fill-column 80) (fci-mode 1)))
