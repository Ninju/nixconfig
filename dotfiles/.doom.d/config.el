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
(setq doom-font (font-spec :family "Hack" :size 16 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tokyo-night)

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

(remove-hook 'doom-first-input-hook #'evil-snipe-mode)
(setq doom-leader-key ","
      doom-localleader-key ";")

(setq evil-ex-substitute-global nil
      evil-ex-substitute-case 'smart)

;;- Company
(setq company-backends '(company-tabnine company-capf))

(after! company
  ;; Trigger completion immediately.
  (setq company-idle-delay 0)

  (setq company-minimum-prefix-length 1)

  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (setq company-show-quick-access t))

(add-hook! 'prog-mode-hook (lambda () (yafolding-mode)))

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

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(defconst aw/user-init-dir "~/.doom.d/")

(defun load-user-file (file)
  (interactive "f")
  "Load a file in current user's configuration directory"
  (load-file (expand-file-name file aw/user-init-dir)))

(global-display-fill-column-indicator-mode t)


(add-to-list 'auto-mode-alist '("\\.sqlx?\\'" . sql-mode))
(load-user-file "functions.el")
(load-user-file "keybindings.el")
(load-user-file "markdown.el")
(load-user-file "org.el")
(load-user-file "lang/golang.el")
