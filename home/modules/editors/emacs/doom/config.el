;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ══════════════════════════════════════════════════════════════════════
;;  BASIC CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Personal information
(setq user-full-name "Dmitry Sidiuk"
      user-mail-address "seajoyer@gmail.com")

;; Add local modules directory to load path
(add-to-list 'load-path "~/.config/doom/local/")

;; Organization directory
(setq org-directory "~/org")

;; Line numbers
(setq display-line-numbers-type 'relative)

;; ══════════════════════════════════════════════════════════════════════
;;  UI & THEME CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Theme configuration
(setq custom-safe-themes t)
(setq doom-theme 'doom-old-hope)
;; (setq doom-theme 'doom-tokyo-night)
;; (setq doom-theme 'doom-city-lights)
;; (setq doom-theme 'doom-ir-black)
;; (setq doom-theme 'doom-challenger-deep)
;; (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'frappe

;; Transparent background
(add-to-list 'default-frame-alist '(alpha-background . 95))

;; Terminal background fix
(defun set-background-for-terminal (&optional frame)
  (interactive)
  (or frame (setq frame (selected-frame)))
  "unsets the background color in terminal mode"
  (unless (display-graphic-p frame)
    (set-face-background 'hl-line "unspecified-bg" frame)
    (set-face-background 'line-number "unspecified-bg" frame)
    (set-face-background 'default "unspecified-bg" frame)))
(add-hook 'after-make-frame-functions 'set-background-for-terminal)
(add-hook 'window-setup-hook 'set-background-for-terminal)

(set-popup-rule!
  "^\\*doom:vterm-popup:"
  :height 0.25
  :side 'bottom)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; ══════════════════════════════════════════════════════════════════════
;;  FLYCHECK CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(setq flycheck-indication-mode 'left-margin)

(defun my/set-flycheck-margins ()
  (flycheck-redefine-standard-error-levels "❱")
  (flycheck-set-indication-mode 'left-margin)
  (setq left-fringe-width 8 right-fringe-width 8
        left-margin-width 1 right-margin-width 0 left-margin 1)
  (flycheck-refresh-fringes-and-margins))
(add-hook 'flycheck-mode-hook #'my/set-flycheck-margins)

;; ══════════════════════════════════════════════════════════════════════
;;  COMPLETION & NAVIGATION
;; ══════════════════════════════════════════════════════════════════════

;; Project management
(after! project
  (map! :leader
        :prefix "p"))

;; ══════════════════════════════════════════════════════════════════════
;;  UNDO CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; vundo - visual undo
(after! vundo (setq vundo-glyph-alist vundo-unicode-symbols))
(setq undo-limit 67108864) ; 64mb
(setq undo-strong-limit 100663296) ; 96mb
(setq undo-outer-limit 1006632960) ; 960mb

;; ══════════════════════════════════════════════════════════════════════
;;  KEYBINDINGS
;; ══════════════════════════════════════════════════════════════════════

;; Fix tab in evil-mode and remap % to evil-jump-item
(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map "<tab>" nil)
  (define-key evil-motion-state-map (kbd "%") 'evil-jump-item))

(use-package! reverse-im
  :defer 2
  :custom
  (reverse-im-input-methods "russian-computer")
  :config
  (reverse-im-mode t))

;; ══════════════════════════════════════════════════════════════════════
;;  LATEX CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Auto-compile LaTeX on save
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (add-hook 'after-save-hook
                      (lambda () (TeX-command-run-all nil))
                      nil 'make-it-local)))

;; Use pdf-tools to view PDF
(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

;; Auto-revert PDF buffer when file changes
(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; Enable source correlation (synctex) for forward/inverse search
(setq TeX-source-correlate-mode t
      TeX-source-correlate-method 'synctex)

;; Set default PDF viewer to pdf-tools
(setq +latex-viewers '(pdf-tools))

(setq lsp-tex-server 'texlab)

;; (use-package! preview-auto
;;   :after latex
;;   :config
;;   (setq preview-visibility-style t)
;;   (setq preview-locating-previews-message nil)
;;   (setq-default preview-scale-function
;;                 (lambda () (* (/ 10.0 (preview-document-pt)) preview-scale)))

;;   (defun update-preview-scale ()
;;     (setq preview-scale (if (eq preview-image-type 'dvisvgm) 1.8 0.7)))
;;   (add-hook 'preview-auto-mode-hook #'update-preview-scale)

;;   (add-to-list 'preview-auto-extra-environments "tikzpicture")
;;   :custom
;;   (preview-auto-interval 1.0))

;; ══════════════════════════════════════════════════════════════════════
;;  SPELL CHECKING
;; ══════════════════════════════════════════════════════════════════════

(use-package! jinx
  :hook ((text-mode prog-mode conf-mode) . jinx-mode)
  :init
  ;; Tell Enchant which backend to use for our dictionaries.
  ;; This must be set BEFORE jinx loads so the module picks it up.
  (setenv "ENCHANT_ORDERING" "*:hunspell")
  :config
  (setq jinx-languages "en_US ru_RU"
        jinx-delay 0.2)

  ;; Doom uses SPC s s for spell-correct-word by default; rebind to jinx.
  (map! :leader
        (:prefix "s"
         :desc "Correct word (jinx)"     "s" #'jinx-correct
         :desc "Correct all in buffer"   "S" #'jinx-correct-all
         :desc "Languages (jinx)"        "l" #'jinx-languages))

  ;; Convenient keys (mirroring flyspell's traditional bindings)
  (map! :map jinx-mode-map
        "M-$"   #'jinx-correct
        "C-M-$" #'jinx-languages))

;; Better completion UI for jinx-correct when using vertico
(after! vertico-multiform
  (add-to-list 'vertico-multiform-categories
               '(jinx grid (vertico-grid-annotate . 20)))
  (vertico-multiform-mode 1))

;; ══════════════════════════════════════════════════════════════════════
;;  ORG MODE CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(use-package! org-latex-preview
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)

  (add-hook 'org-mode-hook 'org-latex-preview-mode)

  (setq-default org-latex-preview-appearance-options
                '(:foreground auto :background "Transparent" :scale 1.0 :zoom 1.35 :page-width 0.6
                  :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))

  (setq org-latex-preview-mode-display-live t)

  (add-hook 'org-latex-preview-auto-blacklist 'next-line)
  (add-hook 'org-latex-preview-auto-blacklist 'previous-line)

  (setq org-latex-preview-mode-update-delay 1.0))

;; Org-mode customizations
(after! org
  (setq-default org-format-latex-options
                '(:foreground auto :background "Transparent" :scale 1.0 :zoom 1.35 :page-width 0.6
                  :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))

  ;; src block configuration
  (setq org-src-fontify-natively t
        org-src-window-setup 'current-window ;; edit in current window
        org-src-strip-leading-and-trailing-blank-lines t
        org-src-preserve-indentation t ;; do not put two spaces on the left
        org-src-tab-acts-natively t)

  ;; Jupyter configuration
  (setq org-babel-default-header-args:jupyter-python '((:async   . "no")
                                                       (:session . "py")
                                                       (:kernel  . "python3"))))

;; ══════════════════════════════════════════════════════════════════════
;;  TRAMP CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(after! tramp
  (setq tramp-default-method "ssh")
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

  ;; Enable SSH agent forwarding
  (setq tramp-use-ssh-controlmaster-options t))

;; ══════════════════════════════════════════════════════════════════════
;;  PROGRAMMING LANGUAGE CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(setq lsp-sqls-workspace-config-path nil)

(after! sql
  (setq sql-product 'postgres)
  (setq sql-connection-alist
        '((local-pg
           (sql-product 'postgres)
           (sql-server "localhost")
           (sql-port 5432)
           (sql-user "dmitry")
           (sql-database "project")))))

(add-hook 'sql-mode-hook #'lsp)
(add-hook 'sql-mode-hook #'sqlup-mode)
(add-hook 'sql-mode-hook #'sqlind-minor-mode)

(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=3"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

;; C++ indentation settings
(after! cc-mode
  (c-add-style "k&r-4"
               '("k&r"
                 (c-basic-offset . 4)
                 (indent-tabs-mode . nil)))

  (add-hook 'c++-mode-hook
            (lambda ()
              (c-set-style "k&r-4"))))
