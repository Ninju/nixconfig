;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-Iosvkem)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(setq doom-leader-key ","
      doom-localleader-key "\\")

(setq evil-ex-substitute-global nil
      evil-ex-substitute-case 'smart)

;;- Company
(setq company-backends '(company-tabnine company-capf))

(after! company
  ;; Trigger completion immediately.
  (setq company-idle-delay 0)

  (setq company-minimum-prefix-length 1)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-numbers t))

;;- Dart
(set-lookup-handlers! 'dart-mode :async t
                          :definition #'dart-server-goto
                          :references #'dart-server-find-refs)

(use-package! dart-server
  :hook (dart-mode . dart-server)
  :config
  (setq dart-server-enable-analysis-server t))

(add-hook! 'dart-server-hook (lambda () (add-to-list company-backends #'company-dart)))
(add-hook! 'dart-server-hook 'flycheck-mode)

;;- Golang

(add-hook! go-mode
  (setq gofmt-command "goimports"))

(add-hook! 'prog-mode-hook (lambda () (yafolding-mode)))

(defun aj-toggle-fold ()
  "Toggle fold all lines larger than indentation on current line"
  (interactive)
  (let ((col 1))
    (save-excursion
      (back-to-indentation)
      (setq col (+ 1 (current-column)))
      (set-selective-display
       (if selective-display nil (or col 1))))))

(map! :n "z l" #'aj-toggle-fold ;; overwrites evil-scroll-column-right
      :n "z ;" #'evil-scroll-column-right
      :n ", l" #'aj-toggle-fold ;; my old keybinding

      :n ", a g" #'ag
      :n ", a r" #'ag-regexp
      :n ", a d" #'ag-dired
      :n ", a s" #'ag-dired-regexp
      :n ", a p" #'ag-project
      :n ", a k" #'ag-kill-other-buffers

      :v ", c /" #'comment-region
      :v ", c \\" #'uncomment-region

      :n "SPC" #'avy-goto-char)

(when (featurep 'ns)
  (defun ns-raise-emacs ()
    "Raise Emacs."
    (ns-do-applescript "tell application \"Emacs\" to activate"))

  (defun ns-raise-emacs-with-frame (frame)
    "Raise Emacs and select the provided frame."
    (with-selected-frame frame
      (when (display-graphic-p)
        (ns-raise-emacs))))

  (add-hook 'after-make-frame-functions 'ns-raise-emacs-with-frame)

  (when (display-graphic-p)
    (ns-raise-emacs)))

(defun my-markdown-filter (buffer)
  (princ
   (with-temp-buffer
     (let ((tmp (buffer-name)))
       (set-buffer buffer)
       (set-buffer (markdown tmp))
       (format "<!DOCTYPE html><html><title>Markdown preview</title><link rel=\"stylesheet\" href = \"https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/3.0.1/github-markdown.min.css\"/>
<body><article class=\"markdown-body\" style=\"box-sizing: border-box;min-width: 200px;max-width: 980px;margin: 0 auto;padding: 45px;\">%s</article></body></html>" (buffer-string))))
   (current-buffer)))

(defun my-markdown-preview ()
  "Preview markdown."
  (interactive)
  (unless (process-status "httpd")
    (httpd-start))
  (impatient-mode)
  (imp-set-user-filter 'my-markdown-filter)
  (imp-visit-buffer))

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)
