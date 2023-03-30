;;; ../src/git/Ninju/nixconfig/dotfiles/.doom.d/org.el -*- lexical-binding: t; -*-

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Documents/__emacs/org/")


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
                               "* EVENT %i%? \n %U")
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
          (todo "+@work+TODO=\"DONE\""
                ((org-agenda-overriding-header "DONE")))
          (tags "+@work+TODO=\"TODO\""
                ((org-agenda-overriding-header "TODO")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-agenda-skip-function
                    '(aw/org-agenda-skip-all-tags-except "+@work"))
                   (org-deadline-warning-days 1)
                   (org-agenda-overriding-header "Today")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "+1d")
                   (org-agenda-skip-function
                    '(aw/org-agenda-skip-all-tags-except "+@work"))
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
                   ((org-agenda-overriding-header "All Tasks")))
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

        ("w" "@work tasks"
         ((tags "+@work-_blocked"
                ((org-agenda-overriding-header "Work TODOs")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (tags "+@work+_blocked"
                ((org-agenda-overriding-header "Blocked")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-agenda-skip-function
                    '(aw/org-agenda-skip-all-tags-except "+@work"))
                   (org-deadline-warning-days 1)
                   (org-agenda-overriding-header "Today")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-skip-function
                    '(aw/org-agenda-skip-all-tags-except "+@work"))
                   (org-agenda-start-day "+1d")
                   (org-deadline-warning-days 0)
                   (org-agenda-overriding-header "Next 3 days")))))

        ("p" "@personal tasks"
         ((tags "@personal"
                ((org-agenda-overriding-header "Personal TODOs")
                 (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))
          (agenda ""
                  ((org-agenda-span 1)
                   (org-agenda-start-day "+0d")
                   (org-agenda-skip-function
                    '(aw/org-agenda-skip-all-tags-except "+@personal"))
                   (org-deadline-warning-days 1)
                   (org-agenda-overriding-header "Today")))
          (agenda ""
                  ((org-agenda-span 3)
                   (org-agenda-start-day "+1d")
                   (org-agenda-skip-function
                    '(aw/org-agenda-skip-all-tags-except "+@personal"))
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
  (or (string= "TODO"       (org-get-todo-state))
      (string= "IN-PROCESS" (org-get-todo-state))))

(defun org-current-is-not-todo ()
  (not (org-current-is-todo)))

;; End Source -- https://emacs.cafe/emacs/orgmode/gtd/2017/06/30/orgmode-gtd.html

(setq org-tag-alist '(("@work" . ?w)
                      ("@personal" . ?p)
                      ("@home" . ?h)
                      ("@office" . ?o)

                      ("_blocked" . ?b)
                      ("_delegated" . ?B)

                      ("chore" . ?c)
                      ("clean" . ?x)
                      ("decision" . ?d)
                      ("digital_cleanliness" . ?x)
                      ("errand" . ?e)
                      ("idea" . ?i)
                      ("important" . ?I)
                      ("productivity" . ?P)
                      ("project" . ?j)
                      ("reminder" . ?r)
                      ))


(setq org-todo-keyword-faces
      '(("PROJECT"        . +org-todo-project)
        ("IDEA"           . +org-todo-project)

        ("[-]"        . +org-todo-active)
        ("STRT"       . +org-todo-active)
        ("GOAL"       . +org-todo-active)
        ("IN-PROCESS" . +org-todo-active)

        ("[?]"        . +org-todo-onhold)
        ("WAIT"       . +org-todo-onhold)
        ("HOLD"       . +org-todo-onhold)

        ("PROJ"       . +org-todo-project)

        ("NO"         . +org-todo-cancel)
        ("DISCARDED"  . +org-todo-cancel)
        ("CANCELLED"  . +org-todo-cancel)
        ("KILL"       . +org-todo-cancel)))

(setq org-todo-keywords
      '((sequence "IDEA"    "GOAL"       "|" "ACHIEVED" "MISSED" "DISCARDED")
        (sequence "PROJECT"              "|" "COMPLETE"          "CANCELLED")
        (sequence "TODO"    "IN-PROCESS" "|" "DONE" "KILL")))

;; Brian Tracy: ABCDE method for prioritisation
;; https://www.briantracy.com/blog/time-management/the-abcde-list-technique-for-setting-priorities/
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
