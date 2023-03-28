;;; ../src/git/Ninju/nixconfig/dotfiles/.doom.d/functions.el -*- lexical-binding: t; -*-

(defun aw/aj-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))
