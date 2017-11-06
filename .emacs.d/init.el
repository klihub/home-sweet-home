; If you want to load an explicit set of your modules, set ini-modules
; to the list of modules to be loaded. Use module names relative to
; ~/.emacs.d.
;
; If you do not specify any modules, all of them will be loaded.
;(setq ini-modules '("strip-bars.el"))

; Add ~/.emacs.d to our load-path.
(add-to-list 'load-path "~/.emacs.d/lisp/")

; By default load all modules.
(if (not (boundp 'ini-modules))
    (setq ini-modules (directory-files "~/.emacs.d/init" nil "[0-9]+-*.*.el$")))

; Loader function - loop through all given modules loading each of them.
(defun load-inifiles (modules)
  "Load the given set of initialization modules from ~/.emacs.d/init."
  (while modules
    (progn (print (format "Processing init module %s..."
                          (concat "~/.emacs.d/init/" (car modules))))
           (if (not (string= (car modules) "init.el"))
               (load-file (concat "~/.emacs.d/init/" (car modules))))
           (setq modules (cdr modules)))))

; Load given or found modules.
(load-inifiles ini-modules)
