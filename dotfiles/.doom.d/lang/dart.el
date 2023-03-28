;;; ../src/git/Ninju/nixconfig/dotfiles/.doom.d/lang/dart.el -*- lexical-binding: t; -*-

(set-lookup-handlers! 'dart-mode :async t
                          :definition #'dart-server-goto
                          :references #'dart-server-find-refs)

(use-package! dart-server
  :hook (dart-mode . dart-server)
  :config
  (setq dart-server-enable-analysis-server t))

(add-hook! 'dart-server-hook (lambda () (add-to-list company-backends #'company-dart)))
(add-hook! 'dart-server-hook 'flycheck-mode)
