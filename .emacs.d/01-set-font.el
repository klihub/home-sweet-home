; Try to set a default font that will neither cause my eyes to bleed,
; nor puch a hole in my roof...

;(defun force-frame-font (frame)
;  (set-frame-parameter frame 'font "Droid Sans Mono-10"))

(defun force-frame-font (frame)
  (set-frame-parameter frame 'font "Monospace-10"))


; Force font on the current and all future frames.
(force-frame-font nil)
(push 'force-frame-font after-make-frame-functions)

