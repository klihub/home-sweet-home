;; Find a big sledge-hammer and smash fscking electric-indent into a million pieces...
(when (fboundp 'electric-indent-mode) (electric-indent-mode -1))

;; Do not use TABs for indentation by default.
(setq-default indent-tabs-mode nil)

;;
;; Buffers open with files matching any of these patterns will
;; be set up to have indentation depth, tab-usage and whitespace
;; error marking as specified below in the entries.
;;
(setq indent-config              ;;  depth use-tabs mark-ws-errors
      '((".*/WebKit/Source/.*"      (4     true     nil ))
	(".*/linux/.*"              (8     true     nil ))
	(".*/rhythmbox/.*"          (8     true     nil ))
	(".*/murphy/.*"             (4     nil      true))
	(".*/speech-recognition/.*" (4     nil      true))
	(".*/winthorpe/.*"          (4     nil      true))
	(".*/pulseaudio/.*"         (4     nil      true))
      	(".*/policy-misc/.*"        (4     nil      true))
        (".*/iot-lib/.*"            (4     nil      true))
	(".*/iot-app-fw/.*"         (4     nil      true))
	(".*/ripncode/.*"           (4     nil      true))
        (".*/flatpak-utils/.*"      (4     nil      true))
        (".*/refkit-ostree.*/.*"    (4     nil      true))
        (".*/swup_handler.c"        (8     true     true))
        (".*/swupdate.*/.*"         (8     true     nil ))
	(".*.py"                    (4     true     true))
	(".*"                       (2     true     nil ))))

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
  (progn (print (format "Indentation TAB usage for %s: %s..."
                        (buffer-file-name) (car (cdr entry))))
         (car (cdr entry))))

;; Get whitespace error marking preference from an entry.
(defun get-mark-ws-pref (entry)
  "Get whitespace error marking preference from an entry."
  (progn (print (format "Marking whitespace error for %s: %s..."
                        (buffer-file-name) (car (cdr (cdr entry)))))
         (car (cdr (cdr entry)))))

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
(add-hook 'python-mode-hook 'preferred-indent-tabs-hook)
(add-hook 'python-mode-hook 'preferred-ws-marking-hook)

;; Go-mode is not derived from c-mode so we can't customize
;; it with the same infra. We settle for setting tab-width
;; to 4 in go-mode, and enabling whitespace mode with marking
;; trailing spaces only (without highlighting spaces).
(defun preferred-go-settings-hook ()
  (progn
    (setq tab-width 4)
    (setq whitespace-style '(face trailing))
    (whitespace-mode)))

(add-hook 'go-mode-hook 'preferred-go-settings-hook)
