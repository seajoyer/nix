;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;;; ══════════════════════════════════════════════════════════════════════
;;;                            Org Packages
;;; ══════════════════════════════════════════════════════════════════════

;; a recipe for org-latex-preview
;; (package! org :recipe
;;   (:host nil :repo "https://git.tecosaur.net/mirrors/org-mode.git" :remote "mirror" :fork
;;          (:host nil :repo "https://git.tecosaur.net/tec/org-mode.git" :branch "dev" :remote "tecosaur")
;;          :files
;;          (:defaults "etc")
;;          :build t :pre-build
;;          (with-temp-file "org-version.el"
;;            (require 'lisp-mnt)
;;            (let
;;                ((version
;;                  (with-temp-buffer
;;                    (insert-file-contents "lisp/org.el")
;;                    (lm-header "version")))
;;                 (git-version
;;                  (string-trim
;;                   (with-temp-buffer
;;                     (call-process "git" nil t nil "rev-parse" "--short" "HEAD")
;;                     (buffer-string)))))
;;              (insert
;;               (format "(defun org-release () \"The release version of Org.\" %S)\n" version)
;;               (format "(defun org-git-version () \"The truncate git commit hash of Org mode.\" %S)\n" git-version)
;;               "(provide 'org-version)\n"))))
;;   :pin nil)
;; (unpin! org)

(package! emacs-everywhere)
(package! org-mime)
;; (package! org-fragtog)
(package! org-superstar)
;; (package! org-modern)
;; (package! org-bullets)

;;; ══════════════════════════════════════════════════════════════════════
;;;                       UI & Aesthetic Packages
;;; ══════════════════════════════════════════════════════════════════════

(package! lv)
(package! helm)
(package! vundo)
(package! embark)
;;(package! ivy-rich)
(package! auto-dark)
(package! reverse-im)

;; Fun zone packages
(package! zone-nyan)
(package! nyan-mode)
(package! zone-sl)
(package! zone-rainbow)
(package! zone-tmux-clock)

;; Themes
(package! catppuccin-theme)
(package! idea-darkula-theme)
(package! kanagawa-themes)
(package! auto-dark)

;; Git UI enhancements
(package! rainbow-delimiters)
(package! git-gutter-fringe)

;; Font enhancements
(package! fira-code-mode)

;; Themes
(package! nano-theme)

;;; ══════════════════════════════════════════════════════════════════════
;;;                       Development Packages
;;; ══════════════════════════════════════════════════════════════════════

(package! clang-format+)
(package! aggressive-indent)
(package! realgud)

(package! preview-auto)
(package! preview-dvisvgm)
(package! yuck-mode)
(package! openfoam)
;; (package! lsp-java)

;; Snippets
;; (package! doom-snippets :ignore t)
;; (package! yasnippet-snippets)

(package! pdf-tools)

(package! leetcode)

(package! sqlup-mode)
(package! sql-indent)

(package! lammps-mode)
(package! kdl-mode)

;;; ══════════════════════════════════════════════════════════════════════
;;;                       Temporary Fixes
;;; ══════════════════════════════════════════════════════════════════════

(package! with-editor)

;; (package! with-editor
;;   :pin "bbc60f68ac190f02da8a100b6fb67cf1c27c53ab"
;;   :recipe (:host github :repo "magit/with-editor"))
