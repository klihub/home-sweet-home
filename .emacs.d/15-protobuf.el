(require 'protobuf-mode)

(add-to-list 'auto-mode-alist '("\\.proto\\'" . protobuf-mode))

(defconst custom-protobuf-style
  '((c-basic-offset . 4)
    (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
   (lambda () (c-add-style "custom-protobuf-style" custom-protobuf-style t)))
