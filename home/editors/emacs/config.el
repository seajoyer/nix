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
(use-package org-roam
  :custom
  (org-roam-directory (file-truename "~/org/cheat-sheet"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

;; Line numbers
(setq display-line-numbers-type t)

;; ══════════════════════════════════════════════════════════════════════
;;  UI & THEME CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Theme configuration
(setq custom-safe-themes t)
(setq doom-theme 'doom-tokyo-night)
;; (setq doom-theme 'doom-city-lights)
;; (setq doom-theme 'doom-old-hope)
;; (setq doom-theme 'doom-ir-black)
;; (setq doom-theme 'doom-challenger-deep)
;; (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'frappe

;; (after! doom-ui
;;   ;; set your favorite themes
;;   (setq! auto-dark-themes '((doom-tokyo-night) (doom-one-light)))
;;   (auto-dark-mode))

;; Transparent background
;; (set-frame-parameter nil 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))

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
  "^\\*doom:vterm-popup"
  :height 0.25
  :side 'bottom)

;; Margins and fringes configuration
(setq-default left-fringe-width 8)
(setq-default right-fringe-width 8)
(setq left-margin-width 1
      left-fringe-width 8
      right-fringe-width 8)
(set-fringe-mode '(8 . 8))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Enable pixel-precise scrolling
;; (pixel-scroll-precision-mode 1)

;; Configure pixel scrolling behavior
;; (setq pixel-scroll-precision-interpolate-page t
;;       pixel-scroll-precision-large-scroll-height 40.0)

;; Git gutter customization
(use-package git-gutter-fringe
  :config
  (fringe-helper-define 'git-gutter-fr:added nil
    "...XX..."
    "...XX..."
    "...XX..."
    "XXXXXXXX"
    "XXXXXXXX"
    "...XX..."
    "...XX..."
    "...XX...")

  (fringe-helper-define 'git-gutter-fr:deleted nil
    ".........."
    ".........."
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    "XXXXXXXXXX"
    ".........."
    "..........")

  (fringe-helper-define 'git-gutter-fr:modified nil
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"
    "..XXXXXX" "..XXXXXX" "..XXXXXX" "..XXXXXX"))

;; ══════════════════════════════════════════════════════════════════════
;;  FONT CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Use Iosevka for special font characters
(create-fontset-from-fontset-spec standard-fontset-spec) ;to make --daemon work
(add-hook 'org-mode-hook #'My/use-Iosevka)
(defun My/use-Iosevka ()
  "Use Iosevka for special symbols"
  (let ((my-font "IosevkaNerdFontComplete-")
        (font-sets '("fontset-default"
                     "fontset-standard"
                     "fontset-startup")))
    (mapcar
     (lambda (font-set)
       ;; all the characters in that range (which is the full possible range)
       (set-fontset-font font-set #x2605 my-font)
       (set-fontset-font font-set #xf0da my-font)
       (set-fontset-font font-set #x25cf my-font)
       (set-fontset-font font-set #xf5df my-font)
       (set-fontset-font font-set #xf7b8 my-font)
       (set-fontset-font font-set #xf192 my-font)
       (set-fontset-font font-set #xf9c9 my-font)
       (set-fontset-font font-set #xf10c my-font)
       (set-fontset-font font-set #xf05d my-font)
       (set-fontset-font font-set #xf28c my-font)
       (set-fontset-font font-set #xf05c my-font)
       (set-fontset-font font-set #xf28e my-font)
       (set-fontset-font font-set #xf8a3 my-font)
       (set-fontset-font font-set #xf8a6 my-font)
       (set-fontset-font font-set #xf8a9 my-font)
       (set-fontset-font font-set #xf096 my-font)
       (set-fontset-font font-set #xf046 my-font)
       (set-fontset-font font-set #xf252 my-font)
       (set-fontset-font font-set #xf5c8 my-font)
       (set-fontset-font font-set #xf461 my-font)
       (set-fontset-font font-set #xe005 my-font)
       (set-fontset-font font-set #x2718 my-font)
       (set-fontset-font font-set #x2714 my-font)
       (set-fontset-font "fontset-default" 'cyrillic "DejaVu Sans Mono")
       ;; for all characters without font specification
       ;; in another words it is a setting for lack of fallback font
       ;; if e.g. ℕ called DOUBLE-STRUCK CAPITAL N is not covered by our font
       ;; it will be displayed as placeholder-box,
       ;; because fallback for our font is now... our font :)
       (set-fontset-font font-set nil my-font))
     font-sets)))

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
;;  BUFFER MANAGEMENT
;; ══════════════════════════════════════════════════════════════════════

(defun my/revert-buffer-settings ()
  (interactive)
  (set-window-buffer nil (current-buffer))
  (set-window-margins (selected-window) 1 0)
  (set-window-fringes (selected-window) 8 8))

(add-hook! 'lsp-after-open-hook 'my/revert-buffer-settings)

;; ══════════════════════════════════════════════════════════════════════
;;  COMPLETION & NAVIGATION
;; ══════════════════════════════════════════════════════════════════════

;; Project management
(after! project
  (map! :leader
        :prefix "p"
        ;; :desc "Switch project"             "p" #'project-switch-project
        ;; :desc "Find file in project"       "f" #'project-find-file
        ;; :desc "Search project files"       "s" #'project-find-regexp
        ;; :desc "Project Dired"              "d" #'project-dired
        ;; :desc "Compile project"            "c" #'project-compile
        ;; :desc "Run project command"        "x" #'project-execute-extended-command
        ;; :desc "Add to project"             "a" #'project-add-known
        ;; :desc "Remove from projects"       "r" #'project-remove-known
        ;; :desc "List known projects"        "k" #'project-list-known
        ;; :desc "Switch to previous buffer"  "b" #'project-switch-to-buffer
        :desc "Find other file"            "h" #'projectile-find-other-file))


;; Marginalia and Embark
(use-package marginalia
  :config
  (marginalia-mode))


(use-package embark
  :bind
  (("C-c a" . embark-act))

  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

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

;; (use-package char-fold
;;   :custom
;;   (char-fold-symmetric t)
;;   (search-default-mode #'char-fold-to-regexp))

(use-package! reverse-im
  ;; :after char-fold
  ;; :bind
  ;; ("M-T" . reverse-im-translate-word)
  :custom
  ;; ;; use lax matching
  ;; (reverse-im-char-fold t)
  ;; ;; advice read-char to fix commands that use their own shortcut mechanism
  ;; (reverse-im-read-char-advice-function #'reverse-im-read-char-include)
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

(use-package preview-auto
  :after latex
  ;; :hook (LaTeX-mode . preview-auto-setup)
  :config
  (setq preview-protect-point t)
  (setq preview-locating-previews-message nil)
  (setq preview-leave-open-previews-visible t)
  (setq-default preview-scale-function
                (lambda () (* (/ 10.0 (preview-document-pt)) preview-scale)))

  (defun update-preview-scale ()
    (setq preview-scale (if (eq preview-image-type 'dvisvgm) 1.8 0.7)))
  (add-hook 'preview-auto-mode-hook #'update-preview-scale)

  (add-to-list 'preview-auto-extra-environments "tikzpicture")
  :custom
  (preview-auto-interval 1.0))

  ;; Uncomment the following only if you have followed the above
  ;; instructions concerning, e.g., hyperref:

  ;; (preview-LaTeX-command-replacements
  ;;  '(preview-LaTeX-disable-pdfoutput))
  

;; Optional: Use XeLaTeX instead of default engine
;; (setq-default TeX-engine 'xelatex)

;; Optional: Use LuaLaTeX instead of default engine
;; (setq-default TeX-engine 'luatex)

;; Optional: Disable asking for master file (useful for single-file documents)
;; (setq-default TeX-master t)

;; Optional: Clean auxiliary files after compilation
;; (setq TeX-clean-confirm nil)

;; Optional: Show compilation output in a split window
;; (setq TeX-show-compilation t)

;; (use-package! cape
;;  (add-hook! 'prog-mode-hook
;;     (defun +corfu-add-cape-file-h ()
;;       (add-hook 'completion-at-point-functions #'cape-file -10 t))))

;; ══════════════════════════════════════════════════════════════════════
;;  YASNIPPET CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; (use-package! yasnippet
;;   :hook ((LaTeX-mode . yas-minor-mode)
;;          (post-self-insert . my/yas-try-expanding-auto-snippets))
;;   :config
;;   (use-package! warnings
;;     :config
;;     (cl-pushnew '(yasnippet backquote-change)
;;                 warning-suppress-types
;;                 :test 'equal))

;;   (setq yas-triggers-in-field t)

;;   ;; Function that tries to autoexpand YaSnippets
;;   (defun my/yas-try-expanding-auto-snippets ()
;;     (when (and (boundp 'yas-minor-mode) yas-minor-mode)
;;       (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
;;         (yas-expand)))))

;; ;; CDLatex integration with YaSnippet
;; (use-package! cdlatex
;;   :hook ((cdlatex-tab . yas-expand)
;;          (cdlatex-tab . cdlatex-in-yas-field))
;;   :config
;;   (use-package! yasnippet
;;     :bind (:map yas-keymap
;;                 ("<tab>" . yas-next-field-or-cdlatex)
;;                 ("TAB" . yas-next-field-or-cdlatex))
;;     :config
;;     (defun cdlatex-in-yas-field ()
;;       ;; Check if we're at the end of the Yas field
;;       (when-let* ((_ (overlayp yas--active-field-overlay))
;;                   (end (overlay-end yas--active-field-overlay)))
;;         (if (>= (point) end)
;;             ;; Call yas-next-field if cdlatex can't expand here
;;             (let ((s (thing-at-point 'sexp)))
;;               (unless (and s (assoc (substring-no-properties s)
;;                                     cdlatex-command-alist-comb))
;;                 (yas-next-field-or-maybe-expand)
;;                 t))
;;           ;; otherwise expand and jump to the correct location
;;           (let (cdlatex-tab-hook minp)
;;             (setq minp
;;                   (min (save-excursion (cdlatex-tab)
;;                                        (point))
;;                        (overlay-end yas--active-field-overlay)))
;;             (goto-char minp) t))))

;;     (defun yas-next-field-or-cdlatex nil
;;       "Jump to the next Yas field correctly with cdlatex active."
;;       (interactive)
;;       (if
;;           (or (bound-and-true-p cdlatex-mode)
;;               (bound-and-true-p org-cdlatex-mode))
;;           (cdlatex-tab)
;;         (yas-next-field-or-maybe-expand)))))

;; ══════════════════════════════════════════════════════════════════════
;;  SPELL CHECKING
;; ══════════════════════════════════════════════════════════════════════

;; Use hunspell for spell checking
(setq ispell-program-name "hunspell")

;; Set up multi-language support (English + Russian)
(after! ispell
  (setq ispell-dictionary "en_US,ru_RU")
  (ispell-set-spellchecker-params)
  (ispell-hunspell-add-multi-dic "en_US,ru_RU"))

;; Optional: Performance tweaks
(setq ispell-silently-savep t)

;; ══════════════════════════════════════════════════════════════════════
;;  ORG MODE CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(use-package org-latex-preview
  :config
  ;; Increase preview width
  (plist-put org-latex-preview-appearance-options
             :page-width 0.8)

  ;; ;; Use dvisvgm to generate previews
  ;; ;; You don't need this, it's the default:
  ;; (setq org-latex-preview-process-default 'dvisvgm)
  
  ;; Turn on `org-latex-preview-mode', it's built into Org and much faster/more
  ;; featured than org-fragtog. (Remember to turn off/uninstall org-fragtog.)
  (add-hook 'org-mode-hook 'org-latex-preview-mode)

  ;; ;; Block C-n, C-p etc from opening up previews when using `org-latex-preview-mode'
  ;; (setq org-latex-preview-mode-ignored-commands
  ;;       '(next-line previous-line mwheel-scroll
  ;;         scroll-up-command scroll-down-command))

  ;; ;; Enable consistent equation numbering
  ;; (setq org-latex-preview-numbered t)

  (setq-default org-latex-preview-appearance-options
                '(:foreground auto :background "Transparent" :scale 1.0 :zoom 1.35 :page-width 0.6
                  :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))

  ;; Bonus: Turn on live previews.  This shows you a live preview of a LaTeX
  ;; fragment and updates the preview in real-time as you edit it.
  ;; To preview only environments, set it to '(block edit-special) instead
  (setq org-latex-preview-mode-display-live t)

  ;; Block C-n and C-p from opening up previews when using auto-mode
  (add-hook 'org-latex-preview-auto-blacklist 'next-line)
  (add-hook 'org-latex-preview-auto-blacklist 'previous-line)

  ;; More immediate live-previews -- the default delay is 1 second
  (setq org-latex-preview-mode-update-delay 1.0))

;; Org-mode customizations
(after! org
  ;; org LaTeX preview outlook
  (setq-default org-format-latex-options
                '(:foreground auto :background "Transparent" :scale 1.0 :zoom 1.35 :page-width 0.6
                  :matchers ("begin" "$1" "$" "$$" "\\(" "\\[")))

  ;; Scale headings
  (custom-set-faces!
    '(org-level-1 :height 1.0 :weight bold)
    '(org-level-2 :height 1.0 :weight semi-bold)
    '(org-level-3 :height 1.0 :weight medium)
    '(org-level-4 :height 1.0 :weight normal)
    '(org-level-5 :height 1.0)
    '(org-level-6 :height 1.0)
    '(org-level-7 :height 1.0)
    '(org-document-title :height 1.5 :underline nil))

  ;; src block configuration
  (setq org-src-fontify-natively t
        org-src-window-setup 'current-window ;; edit in current window
        org-src-strip-leading-and-trailing-blank-lines t
        org-src-preserve-indentation t ;; do not put two spaces on the left
        org-src-tab-acts-natively t)

  ;; Jupyter configuration
  (setq org-babel-default-header-args:jupyter-python '((:async . "no")
                                                       (:session . "py")
                                                       (:kernel . "python3"))))

;; Org-mode key bindings for Jupyter integration
(map! :after org
      :map org-mode-map
      ;; Bind key to execute Jupyter code to point
      :n "SPC j e" #'jupyter-org-execute-to-point
      ;; Bind key to insert Jupyter source block
      :n "SPC j i" #'jupyter-org-insert-src-block)

;; ══════════════════════════════════════════════════════════════════════
;;  TRAMP CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(after! tramp
  (setq tramp-default-method "ssh")
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path)

  ;; Enable SSH agent forwarding
  (setq tramp-use-ssh-controlmaster-options t)

  ;; Set a longer timeout
  (setq tramp-timeout-seconds 30)

  ;; Enable debug logging
  (setq tramp-verbose 6))

;; ══════════════════════════════════════════════════════════════════════
;;  PROGRAMMING LANGUAGE CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(after! lsp-clangd
  (setq lsp-clients-clangd-args
        '("-j=3"
          "--background-index"
          "--clang-tidy"
          "--completion-style=detailed"
          "--header-insertion=never"
          "--header-insertion-decorators=0"))
  (set-lsp-priority! 'clangd 2))

(setq doom-enable-tree-sitter-mode nil)

;; C++ indentation settings
(after! cc-mode
  ;; Define K&R style with a 4-space indent
  (c-add-style "k&r-4"
               '("k&r"
                 (c-basic-offset . 4) ; Set indent width to 4 spaces
                 (indent-tabs-mode . nil))) ; Use spaces instead of tabs

  ;; Set default style for C++ mode
  (add-hook 'c++-mode-hook
            (lambda ()
              (c-set-style "k&r-4"))))

;; Configure indent-bars
;; (use-package indent-bars
;;   :hook ((prog-mode) . indent-bars-mode)
;;   :config
;;   (setq indent-bars-color-by-depth nil)
;;   (setq indent-bars-highlight-current-depth '(:face default :blend 0.4)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq-local
             indent-tabs-mode nil ; make sure tabs-based indenting is on, even if we disable it globally
             indent-bars-no-descend-lists nil) ; elisp is mostly continued lists!  allow bars to descend inside
            (indent-bars-mode 0)))
