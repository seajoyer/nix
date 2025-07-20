;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ══════════════════════════════════════════════════════════════════════
;;  BASIC CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Personal information
(setq user-full-name "Dmitry Sidyuk"
      user-mail-address "seajoyer@gmail.com")

;; Add local modules directory to load path
(add-to-list 'load-path "~/.config/doom/local/")

;; Organization directory
(setq org-directory "~/org")
(setq org-roam-directory "~/org")

;; Line numbers
(setq display-line-numbers-type t)

;; ══════════════════════════════════════════════════════════════════════
;;  UI & THEME CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Theme configuration
(setq doom-theme 'catppuccin)
;; (setq catppuccin-flavor 'mocha) ;; or 'latte, 'macchiato, or 'frappe

;; Transparent background
(set-frame-parameter nil 'alpha-background 100)
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

;; Margins and fringes configuration
(setq-default left-fringe-width 8)
(setq-default right-fringe-width 8)
(setq left-margin-width 1
      left-fringe-width 8
      right-fringe-width 8)
(set-fringe-mode '(8 . 8))

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
        :desc "Switch project"             "p" #'project-switch-project
        :desc "Find file in project"       "f" #'project-find-file
        :desc "Search project files"       "s" #'project-find-regexp
        :desc "Project Dired"              "d" #'project-dired
        :desc "Compile project"            "c" #'project-compile
        :desc "Run project command"        "x" #'project-execute-extended-command
        :desc "Add to project"             "a" #'project-add-known
        :desc "Remove from projects"       "r" #'project-remove-known
        :desc "List known projects"        "k" #'project-list-known
        :desc "Switch to previous buffer"  "b" #'project-switch-to-buffer))

;; Marginalia and Embark
(use-package marginalia
  :config
  (marginalia-mode))

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

;; ══════════════════════════════════════════════════════════════════════
;;  NIX MODE CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(after! nix-mode
  (set-formatter! 'alejandra '("alejandra" "--quiet") :modes '(nix-mode)))
(setq-hook! 'nix-mode-hook +format-with-lsp nil)

;; ══════════════════════════════════════════════════════════════════════
;;  LATEX CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; AucTeX settings
(use-package! latex
  :hook ((LaTeX-mode . prettify-symbols-mode))
  :bind (:map LaTeX-mode-map
              ("C-S-e" . latex-math-from-calc))
  :config
  ;; Format math as a Latex string with Calc
  (defun latex-math-from-calc ()
    "Evaluate `calc' on the contents of line at point."
    (interactive)
    (cond ((region-active-p)
           (let* ((beg (region-beginning))
                  (end (region-end))
                  (string (buffer-substring-no-properties beg end)))
             (kill-region beg end)
             (insert (calc-eval `(,string calc-language latex
                                  calc-prefer-frac t
                                  calc-angle-mode rad)))))
          (t (let ((l (thing-at-point 'line)))
               (end-of-line 1) (kill-line 0)
               (insert (calc-eval `(,l
                                    calc-language latex
                                    calc-prefer-frac t
                                    calc-angle-mode rad))))))))

;; Auto-compile LaTeX to PDF on save
(defun my-auto-tex-to-pdf ()
  "When .tex file is saved, create a PDF and refresh the PDF buffer."
  (add-hook 'after-save-hook
            (lambda ()
              (when (eq major-mode 'latex-mode)
                (TeX-command "LaTeX" 'TeX-master-file -1)
                (when (file-exists-p (concat (TeX-master-file) ".pdf"))
                  (TeX-revert-document-buffer (concat (TeX-master-file) ".pdf")))))
            nil
            t))

(add-hook 'LaTeX-mode-hook 'my-auto-tex-to-pdf)

;; Preview configuration
(use-package! preview
  :after latex
  :hook ((LaTeX-mode . preview-larger-previews))
  :config
  (defun preview-larger-previews ()
    (setq preview-scale-function
          (lambda () (* 1.25)
            (funcall (preview-scale-from-face))))))

;; CDLatex settings
(use-package! cdlatex
  :hook (LaTeX-mode . cdlatex-mode)
  :bind (:map cdlatex-mode-map
              ("<tab>" . cdlatex-tab)))

;; ══════════════════════════════════════════════════════════════════════
;;  YASNIPPET CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

(use-package! yasnippet
  :hook ((LaTeX-mode . yas-minor-mode)
         (post-self-insert . my/yas-try-expanding-auto-snippets))
  :config
  (use-package! warnings
    :config
    (cl-pushnew '(yasnippet backquote-change)
                warning-suppress-types
                :test 'equal))

  (setq yas-triggers-in-field t)

  ;; Function that tries to autoexpand YaSnippets
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand)))))

;; CDLatex integration with YaSnippet
(use-package! cdlatex
  :hook ((cdlatex-tab . yas-expand)
         (cdlatex-tab . cdlatex-in-yas-field))
  :config
  (use-package! yasnippet
    :bind (:map yas-keymap
                ("<tab>" . yas-next-field-or-cdlatex)
                ("TAB" . yas-next-field-or-cdlatex))
    :config
    (defun cdlatex-in-yas-field ()
      ;; Check if we're at the end of the Yas field
      (when-let* ((_ (overlayp yas--active-field-overlay))
                  (end (overlay-end yas--active-field-overlay)))
        (if (>= (point) end)
            ;; Call yas-next-field if cdlatex can't expand here
            (let ((s (thing-at-point 'sexp)))
              (unless (and s (assoc (substring-no-properties s)
                                    cdlatex-command-alist-comb))
                (yas-next-field-or-maybe-expand)
                t))
          ;; otherwise expand and jump to the correct location
          (let (cdlatex-tab-hook minp)
            (setq minp
                  (min (save-excursion (cdlatex-tab)
                                       (point))
                       (overlay-end yas--active-field-overlay)))
            (goto-char minp) t))))

    (defun yas-next-field-or-cdlatex nil
      "Jump to the next Yas field correctly with cdlatex active."
      (interactive)
      (if
          (or (bound-and-true-p cdlatex-mode)
              (bound-and-true-p org-cdlatex-mode))
          (cdlatex-tab)
        (yas-next-field-or-maybe-expand)))))

;; ══════════════════════════════════════════════════════════════════════
;;  ORG MODE CONFIGURATION
;; ══════════════════════════════════════════════════════════════════════

;; Flyspell settings for Org mode
(defun flyspell-ignore-in-org-mode ()
  "Ignore spell checking in some org-mode regions like code blocks and tables."
  (setq flyspell-generic-check-word-predicate
        (lambda ()
          (let ((pos (point)))
            (not (or (nth 4 (syntax-ppss pos)) ;; comments
                     (org-in-src-block-p)      ;; code blocks
                     (org-at-table-p)))))))    ;; tables
(add-hook 'org-mode-hook 'flyspell-ignore-in-org-mode)

;; Org-mode customizations
(after! org
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

  ;; LaTeX preview scale
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.3))

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

;; Enable org-fragtog-mode in org-mode
(add-hook 'org-mode-hook 'org-fragtog-mode)

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
