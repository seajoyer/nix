;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;;; ══════════════════════════════════════════════════════════════════════
;;;                            Org Packages
;;; ══════════════════════════════════════════════════════════════════════

(package! org-mime)
(package! org-fragtog)
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

;; Fun zone packages
(package! zone-nyan)
(package! nyan-mode)
(package! zone-sl)
(package! zone-rainbow)
(package! zone-tmux-clock)

;; Themes
(package! catppuccin-theme)
(package! idea-darkula-theme)
(package! auto-dark)

;; Git UI enhancements
(package! git-gutter-fringe)

;; Font enhancements
(package! fira-code-mode)

;;; ══════════════════════════════════════════════════════════════════════
;;;                       Development Packages
;;; ══════════════════════════════════════════════════════════════════════

(package! clang-format+)
(package! aggressive-indent)
(package! realgud)

;; LaTeX and document editing
(package! auctex)
(package! cdlatex)
(package! yuck-mode)
(package! openfoam)
;; (package! lsp-java)

;; Snippets
;; (package! doom-snippets :ignore t)
;; (package! yasnippet-snippets)

;; PDF tools
(package! pdf-tools)

;; Coding practice
(package! leetcode)

;;; ══════════════════════════════════════════════════════════════════════
;;;                       Temporary Fixes
;;; ══════════════════════════════════════════════════════════════════════

(package! with-editor
  :pin "bbc60f68ac190f02da8a100b6fb67cf1c27c53ab"
  :recipe (:host github :repo "magit/with-editor"))
