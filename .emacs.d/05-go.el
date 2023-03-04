; (require 'go-mode-autoloads)

;(add-to-list 'load-path (concat (getenv "GOPATH")  "/src/github.com/golang/lint/misc/emacs"))
;(require 'golint)
;(load-file "~/.emacs.d/lisp/dap-go.el")
;(require 'dap-go)

(add-to-list 'load-path "~/.emacs.d/lisp/")
(add-to-list 'load-path "~/src/golang-et-al/go-mode.el")

(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))

(add-hook 'before-save-hook 'gofmt-before-save)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;(setq gofmt-command "goimports")
;(add-hook 'before-save-hook 'gofmt-before-save)

(add-to-list 'load-path "~/src/golang-et-al/go-dlv.el/")
(require 'go-dlv)
(require 'go-guru)
