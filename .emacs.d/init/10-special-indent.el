;; Turn off electric indent for C*- and shell, modes.
(add-hook 'c-mode-hook (lambda () (electric-indent-local-mode -1)))
(add-hook 'c++-mode-hook (lambda () (electric-indent-local-mode -1)))
(add-hook 'sh-mode-hook (lambda () (electric-indent-local-mode -1)))

;; Nah... stopped working, try with a sledgehammer.
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Do not use TABs for indentation by default.
(setq-default indent-tabs-mode nil)

;;
;; Buffers open with files matching any of these patterns will
;; be set up to have indentation depth, tab-usage and whitespace
;; error marking as specified below in the entries.
;;
(setq indent-config              ;;  depth use-tabs mark-ws-errors
      '((".*/WebKit/Source/.*"      (4     true     nil))
	(".*/linux/.*"              (8     true     nil))
	(".*/rhythmbox/.*"          (8     true     nil))
	(".*/murphy/.*"             (4     nil      true))
	(".*/speech-recognition/.*" (4     nil      true))
	(".*/winthorpe/.*"          (4     nil      true))
	(".*/pulseaudio/.*"         (4     nil      true))
      	(".*/policy-misc/.*"        (4     nil      true))
        (".*/iot-lib/.*"            (4     nil      true))
	(".*/iot-app-fw/.*"         (4     nil      true))
        (".*/flatpak-utils/.*"      (4     nil      true))
        (".*/refkit-ostree.*/.*"    (4     nil      true))
        (".*/network-check/.*"      (4     nil      true))
        (".*/swupdate/.*"           (8     true     nil))
	(".*"                       (2     true     nil))))

;; Determine preference table entry for a file.
(defun get-file-prefs (file-name config)
  "Determine preference table entry for file name."
  (if config
      (if (string-match (car (car config)) file-name)
          (car (cdr (car config)))
        (get-file-prefs file-name (cdr config)))
    '(2 true nil)))

;; Get indentation preference from an entry.
(defun get-depth-pref (entry)
  "Get indentation depth preference from an entry."
  (progn (print (format "Indentation depth for %s: %d..."
                        (buffer-file-name) (car entry)))
         (car entry)))

;; Get tab-usage preference from an entry
(defun get-tabs-pref (entry)
  "Get tab usage preference from an entry."
  (progn (print (format "Indentation TAB usage for %s: %S..."
                        (buffer-file-name) (car (cdr entry))))
         (car (cdr entry))))

;; Get whitespace error marking preference from an entry.
(defun get-mark-ws-pref (entry)
  "Get whitespace error marking preference from an entry."
  (car (cdr (cdr entry))))

;; Mode hook function to set custom indentation depth.
(defun preferred-indent-depth-hook ()
  (if (buffer-file-name)
      (setq c-basic-offset
	    (get-depth-pref (get-file-prefs (buffer-file-name) indent-config)))))

;; Mode hook function to set whether tabs are used for indentation.
(defun preferred-indent-tabs-hook ()
  (if (buffer-file-name)
      (setq indent-tabs-mode
	    (get-tabs-pref (get-file-prefs (buffer-file-name) indent-config)))))

;; Mode hook function to set up whitespace error annotation.
(defface mark-whitespace-face
  '((t (:background "red")))
  "Used to mark incorrectly used whitespace.")

(defvar mark-whitespace-keywords
  '(("\t" . 'mark-whitespace-face)))

(defun activate-ws-marking ()
  (print (format "Activating WS-marking for buffer %s..." (buffer-file-name)))
  (font-lock-add-keywords nil mark-whitespace-keywords)
  (setq show-trailing-whitespace t))

(defun preferred-ws-marking-hook ()
  (if (buffer-file-name)
      (if (get-mark-ws-pref (get-file-prefs (buffer-file-name) indent-config))
          (activate-ws-marking))))


;; Finally hook everything up
(add-hook 'c-mode-hook 'preferred-indent-depth-hook)
(add-hook 'c-mode-hook 'preferred-indent-tabs-hook)
(add-hook 'c-mode-hook 'preferred-ws-marking-hook)
(add-hook 'c++-mode-hook 'preferred-indent-depth-hook)
(add-hook 'c++-mode-hook 'preferred-indent-tabs-hook)
(add-hook 'c++-mode-hook 'preferred-ws-marking-hook)
