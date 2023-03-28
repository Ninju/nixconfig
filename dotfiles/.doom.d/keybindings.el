;;; ../src/git/Ninju/nixconfig/dotfiles/.doom.d/keybindings.el -*- lexical-binding: t; -*-

(map! :n "z l" #'aw/aj-toggle-fold ;; overwrites evil-scroll-column-right
      :n "z ;" #'evil-scroll-column-right
      :n ", l" #'aw/aj-toggle-fold ;; my old keybinding

      :n ", a g" #'ag
      :n ", a r" #'ag-regexp
      :n ", a d" #'ag-dired
      :n ", a s" #'ag-dired-regexp
      :n ", a p" #'ag-project
      :n ", a k" #'ag-kill-other-buffers

      :v ", c /" #'comment-region
      :v ", c \\" #'uncomment-region

      :n "SPC" #'avy-goto-char

      :n ", [" #'previous-buffer
      :n ", ]" #'next-buffer)

(map! :mode #'lisp-mode
      :map 'normal
      ", c l" #'sly-compile-and-load-file
      ", c o" #'sly-eval-print-last-expression
      ", c O" #'sly-macroexpand-1-inplace
      ", c u" #'sly-eval-last-expression
      ", c U" #'sly-macroexpand-1
      ", c z" #'sly-mrepl)

(map! :mode #'sly-mrepl-mode
        :i "<up>"   #'sly-mrepl-previous-input-or-button
        :i "<down>" #'sly-mrepl-previous-input-or-button
        :n "<leader> c z" #'previous-buffer)
