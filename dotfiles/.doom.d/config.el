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
(setq doom-theme 'doom-tokyo-night)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/__emacs/org/")

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

      :n "SPC" #'avy-goto-char

      :n ", [" #'previous-buffer
      :n ", ]" #'next-buffer)

(map! :mode #'lisp-mode
      :map 'normal
      ", c l" #'sly-compile-and-load-file
      ", c o" #'sly-eval-print-last-expression
      ", c u" #'sly-eval-last-expression
      ", c z" #'sly-mrepl)

(map! :mode #'sly-mrepl-mode
        :i "<up>"   #'sly-mrepl-previous-input-or-button
        :i "<down>" #'sly-mrepl-previous-input-or-button
        :n "<leader> c z" #'previous-buffer)

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

;; Source -- https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html
(setq notes-dir "/home/alex/Documents/__emacs")
(setq gtd-dir (concat notes-dir "/gtd"))

(setq gtd-inbox-file (concat gtd-dir "/inbox.org"))
(setq gtd-tickler-file (concat gtd-dir "/tickler.org"))
(setq gtd-someday-file (concat gtd-dir "/someday.org"))
(setq gtd-gtd-file (concat gtd-dir "/gtd.org"))

(setq deft-directory (concat notes-dir "/deft_notes"))
(setq deft-extensions '("org" "txt"))
(setq deft-recursive t)

(setq retro-file (concat notes-dir "/retro.org"))

(setq org-directory (concat notes-dir "/org"))

(setq org-agenda-files (list gtd-inbox-file
                             gtd-gtd-file
                             gtd-tickler-file))

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline gtd-inbox-file "Tasks")
                               "* TODO %i%?")
                              ("T" "Tickler" entry
                               (file+headline gtd-tickler-file "Tickler")
                               "* %i%? \n %U")
                              ("r" "Retro" entry
                               (file+headline retro-file "Retro")
                               "* IDEA %i%? \n %U")))

(setq org-refile-targets '((gtd-gtd-file :maxlevel . 3)
                           (gtd-someday-file :level . 1)
                           (gtd-tickler-file :maxlevel . 2)))

(defun aw/org-tag-at-point-p (tagmatchstr)
  "Return non-nil if tag at point matches tagmatchstr

'tagmatchstr' is a string of the same format at 'org-tags-view'"
  (funcall (cdr (org-make-tags-matcher tagmatchstr))
           (org-get-todo-state)
           (org-get-tags-at)
           (org-reduced-level (org-current-level))))

(defun aw/org-agenda-skip-all-tags-except (tagmatchstr)
  "Skip current headline unless it has a tag matching the 'tagmatchstr'."
  (save-excursion
    (unless (org-at-heading-p) (org-back-to-heading))
    (let ((next-headline (save-excursion
                           (or (outline-next-heading) (point-max)))))
      (if (aw/org-tag-at-point-p tagmatchstr) nil next-headline))))

(defmacro aw/org-agenda-view-today (tags)
  "'tags' is 'org-view-tags' format matcher to filter the view"
  `(agenda ""
    ((org-agenda-span 1)
     (org-agenda-skip-function
      '(aw/org-agenda-skip-all-tags-except ,tags))
     (org-agenda-start-day "+0d")
     (org-deadline-warning-days 1)
     (org-agenda-overriding-header "Today"))))

(setq org-agenda-custom-commands
      '(("s" "Stand-up"
         ((tags "@standup"
                ((org-agenda-overriding-header "Stand-up Items")))
          (tags "@team"
                ((org-agenda-overriding-header "Raise with Team")))
          (todo "DONE"
                ((org-agenda-overriding-header "DONE")))
          (tags "+@work+TODO=\"TODO\""
                ((org-agenda-overriding-header "TODO")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-deadline-warning-days 1)
                   (org-agenda-overriding-header "Today")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "+1d")
                   (org-deadline-warning-days 0)
                   (org-agenda-overriding-header "Next 3 days")))))

        ("t" "Today"
         ((alltodo ""
                ((org-agenda-overriding-header "Focus")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-deadline-warning-days 1)
                   (org-agenda-overriding-header "Today")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "+1d")
                   (org-deadline-warning-days 0)
                   (org-agenda-overriding-header "Next 3 days")))))

        ("T" "All tasks"
         ((alltodo ""
                ((org-agenda-overriding-header "Focus")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-deadline-warning-days 1)
                   (org-agenda-overriding-header "Today")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "+1d")
                   (org-deadline-warning-days 0)
                   (org-agenda-overriding-header "Next 3 days")))))))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))

(defun org-current-is-todo ()
  (not (or (string= "DONE"     (org-get-todo-state))
           (string= "KILL"     (org-get-todo-state)))))

;; End Source -- https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html

(setq org-tag-alist '(("@work" . ?w)
                      ("@personal" . ?p)
                      ("@home" . ?h)
                      ("@office" . ?o)

                      ("_blocked" . ?b)
                      ("_delegated" . ?B)

                      ("reminder" . ?r)
                      ("project" . ?j)
                      ("productivity" . ?P)
                      ("idea" . ?i)
                      ("important" . ?I)
                      ("digital_cleanliness" . ?x)
                      ("errand" . ?e)
                      ("chore" . ?c)
                      ))

(setq org-todo-keywords
      '((sequence "IDEA" "DEF" "TODO" "NEXT" "IN-PROCESS" "|" "DONE" "KILL")))

(setq org-highest-priority ?A
      org-default-priority ?C
      org-lowest-priority  ?E)


;; Inspect 'doom-themes--colors' to see options:
;;   e.g. (doom-color 'red '256)
;;   e.g. (doom-color 'red '16)
(setq org-priority-faces
      '((?A :foreground "#f7768e")
        (?B :foreground "#ff9e64")
        (?C :foreground "#2ac3de")
        (?D :foreground "#e0af68")
        (?E :foreground "#bb9af7")))
