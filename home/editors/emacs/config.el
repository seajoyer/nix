;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq user-full-name "Dmitry Sidiuk"
      user-mail-address "imgarison@gmail.com")


(add-to-list 'load-path "~/.config/doom/local/")


(setq org-directory "~/Projects/org/")


(setq doom-theme 'doom-tokyo-night)


;; ;; Doesn't work for some reason
;; (after! doom-ui
;;   ;; set your favorite themes
;;   (setq! auto-dark-dark-theme 'doom-tokyo-night
;;          auto-dark-light-theme 'doom-one-light)
;;   (auto-dark-mode 1))


;; Transparent background
(set-frame-parameter nil 'alpha-background 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))


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


;; vundo
(after! vundo (setq vundo-glyph-alist vundo-unicode-symbols))
(setq undo-limit 67108864) ; 64mb.
(setq undo-strong-limit 100663296) ; 96mb.
(setq undo-outer-limit 1006632960) ; 960mb.

;; (use-package! all-the-icons-ivy-rich
;;   :init (all-the-icons-ivy-rich-mode 1))

;; (use-package! highlight-indent-guides
;;   :hook (prog-mode . highlight-indent-guides-mode)
;;   :config (setq highlight-indent-guides-method 'bitmap
;;                 highlight-indent-guides-responsive 'top
;;                 highlight-indent-guides-bitmap-function 'highlight-indent-guides--bitmap-dots
;;                 highlight-indent-guides-delay 0))
;; (setq highlight-indent-guides-auto-enabled nil)

;; Adjust margins and fringe widths…
(setq-default left-fringe-width 8)
(setq-default right-fringe-width 8)

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

(setq left-margin-width 1
      left-fringe-width 8
      right-fringe-width 8)
(set-fringe-mode '(8 . 8))

(setq flycheck-indication-mode 'left-margin)

(defun my/set-flycheck-margins ()
  (flycheck-redefine-standard-error-levels "❱")
  (flycheck-set-indication-mode 'left-margin)
  (setq left-fringe-width 8 right-fringe-width 8
        left-margin-width 1 right-margin-width 0 left-margin 1)
  (flycheck-refresh-fringes-and-margins))
(add-hook 'flycheck-mode-hook #'my/set-flycheck-margins)

;; (add-hook! +dap-running-session-mode (set-window-buffer nil (current-buffer)))
;; (add-hook! 'dap-breakpoints-changed-hook (set-window-buffer nil (current-buffer)))

(defun my/revert-buffer-settings ()
  (interactive)
  ;; (set-fringe-mode '(8 . 8))
  (set-window-buffer nil (current-buffer))
  (set-window-margins (selected-window) 1 0)
  (set-window-fringes (selected-window) 8 8))

;; (add-hook! 'doom-switch-buffer-hook 'my/revert-buffer-settings)
;; (add-hook! 'dap-breakpoints-changed-hook 'my/revert-buffer-settings)
(add-hook! 'lsp-after-open-hook 'my/revert-buffer-settings)

;; (require 'icons-in-terminal)
;; (insert (icons-in-terminal 'oct_flame)) ; C-h f icons-in-terminal[RET] for more info

;; (use-package! procress
;;   :straight (:host github :repo "haji-ali/procress")
;;   :commands procress-auctex-mode
;;   :init
;;   (add-hook 'LaTeX-mode-hook #'procress-auctex-mode)
;;   :config
;;   (procress-load-default-svg-images))

;;-- Modeline --

;; (use-package! nyan-mode
;;   :config
;;   ;; (nyan-cat-face-number 4)
;;   (nyan-toggle-wavy-trail)
;;   (nyan-toggle-wavy-trail)
;;   (nyan-animate-nyancat t)
;;   :hook
;;   (doom-modeline-mode . nyan-mode))
;; (use-package! parrot
;;   :config (setq parrot-num-rotations 3)
;;   (parrot-mode))
;; (parrot-set-parrot-type 'default)

;; (after! doom-modeline (doom-modeline-def-modeline 'main ;
;;                         '(bar workspace-name window-number modals matches follow buffer-info remote-host buffer-position word-count parrot selection-info)
;;                         '(objed-state misc-info persp-name battery grip irc mu4e gnus github debug repl lsp minor-modes input-method indent-info buffer-encoding major-mode process vcs checker time "  ")))

(setq display-line-numbers-type t)

;; Smooth scrolling
;; (setq pixel-scroll-precision-large-scroll-height nil)
;; (defun filter-mwheel-always-coalesce (orig &rest args)
;;   "A filter function suitable for :around advices that ensures only
;;    coalesced scroll events reach the advised function."
;;   (if mwheel-coalesce-scroll-events
;;       (apply orig args)
;;     (setq mwheel-coalesce-scroll-events t)))

;; (defun filter-mwheel-never-coalesce (orig &rest args)
;;   "A filter function suitable for :around advices that ensures only
;;    non-coalesced scroll events reach the advised function."
;;   (if mwheel-coalesce-scroll-events
;;       (setq mwheel-coalesce-scroll-events nil)
;;     (apply orig args)))
;; (advice-add 'pixel-scroll-precision :around #'filter-mwheel-never-coalesce)
;; (advice-add 'mwheel-scroll          :around #'filter-mwheel-always-coalesce)
;; (advice-add 'mouse-wheel-text-scale :around #'filter-mwheel-always-coalesce)

;;-- Control --

;; (use-package! ivy-rich
;;   :init (ivy-rich-mode 1)
;;   (setcdr (assq t ivy-format-functions-alist) #'ivy-format-function-line))

;; (use-package! vertico
;;   :config (vertico-mouse-mode)
;;           (vertico-grid-mode))

(all-the-icons-completion-mode)
(add-hook 'marginalia-mode-hook #'all-the-icons-completion-marginalia-setup)

;; (use-package! fira-code-mode
;;   :config (fira-code-mode-set-font)
;;   :custom (fira-code-mode-disabled-ligatures '("[]" "#{" "#(" "#_" "#_(" "x")) ;; List of ligatures to turn off
;;   :hook prog-mode) ;; Enables fira-code-mode automatically for programming major modes

;; use Iosevka for special font characters
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


;; Org mode
;; (after! org (load! "~/.doom.d/local/org-mode-config.el"))

(with-eval-after-load 'evil-maps
  (define-key evil-motion-state-map "<tab>" nil)
  (define-key evil-motion-state-map (kbd "%") 'evil-jump-item))

;; LaTeX
;; AucTeX settings - almost no changes
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

;; A function to automiticaly compile pdf on save
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

;; Yasnippet settings
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
  ;; The double quoting is NOT a typo!
  (defun my/yas-try-expanding-auto-snippets ()
    (when (and (boundp 'yas-minor-mode) yas-minor-mode)
      (let ((yas-buffer-local-condition ''(require-snippet-condition . auto)))
        (yas-expand)))))

;; CDLatex integration with YaSnippet: Allow cdlatex tab to work inside Yas
;; fields
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

;; org-mode with LaTeX
(add-hook 'org-mode-hook 'org-fragtog-mode)
(setq org-latex-packages-alist
      '(("" "graphicx" t)
        ("" "longtable" nil)
        ("" "float" nil)))

;; Array/tabular input with org-tables and cdlatex
(use-package! org-table
  :after cdlatex
  :bind (:map orgtbl-mode-map
              ("<tab>" . lazytab-org-table-next-field-maybe)
              ("TAB" . lazytab-org-table-next-field-maybe))
  :init
  (add-hook 'cdlatex-tab-hook 'lazytab-cdlatex-or-orgtbl-next-field 90)
  ;; Tabular environments using cdlatex
  (add-to-list 'cdlatex-command-alist '("smat" "Insert smallmatrix env"
                                        "\\left( \\begin{smallmatrix} ? \\end{smallmatrix} \\right)"
                                        lazytab-position-cursor-and-edit
                                        nil nil t))
  (add-to-list 'cdlatex-command-alist '("bmat" "Insert bmatrix env"
                                        "\\begin{bmatrix} ? \\end{bmatrix}"
                                        lazytab-position-cursor-and-edit
                                        nil nil t))
  (add-to-list 'cdlatex-command-alist '("pmat" "Insert pmatrix env"
                                        "\\begin{pmatrix} ? \\end{pmatrix}"
                                        lazytab-position-cursor-and-edit
                                        nil nil t))
  (add-to-list 'cdlatex-command-alist '("tbl" "Insert table"
                                        "\\begin{table}\n\\centering ? \\caption{}\n\\end{table}\n"
                                        lazytab-position-cursor-and-edit
                                        nil t nil))
  :config
  ;; Tab handling in org tables
  (defun lazytab-position-cursor-and-edit ()
    ;; (if (search-backward "\?" (- (point) 100) t)
    ;;     (delete-char 1))
    (cdlatex-position-cursor)
    (lazytab-orgtbl-edit))

  (defun lazytab-orgtbl-edit ()
    (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'lazytab-orgtbl-replace)
    (orgtbl-mode 1)
    (open-line 1)
    (insert "\n|"))

  (defun lazytab-orgtbl-replace (_)
    (interactive "P")
    (unless (org-at-table-p) (user-error "Not at a table"))
    (let* ((table (org-table-to-lisp))
           params
           (replacement-table
            (if (texmathp)
                (lazytab-orgtbl-to-amsmath table params)
              (orgtbl-to-latex table params))))
      (kill-region (org-table-begin) (org-table-end))
      (open-line 1)
      (push-mark)
      (insert replacement-table)
      (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
      (orgtbl-mode -1)
      (advice-remove 'orgtbl-ctrl-c-ctrl-c #'lazytab-orgtbl-replace)))

  (defun lazytab-orgtbl-to-amsmath (table params)
    (orgtbl-to-generic
     table
     (org-combine-plists
      '(:splice t
        :lstart ""
        :lend " \\\\"
        :sep " & "
        :hline nil
        :llend "")
      params)))

  (defun lazytab-cdlatex-or-orgtbl-next-field ()
    (when (and (bound-and-true-p orgtbl-mode)
               (org-at-table-p)
               (looking-at "[[:space:]]*\\(?:|\\|$\\)")
               (let ((s (thing-at-point 'sexp)))
                 (not (and s (assoc s cdlatex-command-alist-comb)))))
      (call-interactively #'org-table-next-field)
      t))

  (defun lazytab-org-table-next-field-maybe ()
    (interactive)
    (if (bound-and-true-p cdlatex-mode)
        (cdlatex-tab)
      (org-table-next-field))));; (after! latex (load! "~/.doom.d/local/TeX-config.el"))


;; Programming
;; lsp mode
(defun my/configure-lsp()
  (setq c-basic-offset 4
        lsp-keymap-prefix "C-c l"

        lsp-completion-show-detail t
        lsp-completion-show-kind t

        lsp-enable-dap-auto-configure t

        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t

        ;; lsp-headerline-breadcrumb-mode nil
        ;; lsp-headerline-breadcrumb-enable nil
        ;; lsp-headerline-breadcrumb-enable-diagnostics t
        ;; lsp-headerline-breadcrumb-enable-symbol-numbers t

        ;; lsp-ui-doc-show-with-cursor nil
        ;; lsp-ui-doc-use-webkit nil
        ;; lsp-ui-doc-delay 0.2
        lsp-ui-doc-show-with-mouse t
        lsp-ui-doc-max-height 20
        lsp-ui-doc-max-width 200
        lsp-ui-doc-webkit-max-width-px 800

        lsp-modeline-code-actions-enable t

        ;; setq company-clang-insert-arguments t
        lsp-enable-snippet t)
  )

(add-hook! 'lsp-mode-hook #'my/configure-lsp)

(after! lsp-mode
  (setq c-basic-offset 4
        lsp-keymap-prefix "C-c l"
        lsp-completion-show-kind nil
        lsp-completion-show-detail t
        lsp-enable-dap-auto-configure t
        ;; lsp-headerline-breadcrumb-mode nil
        ;; lsp-headerline-breadcrumb-enable nil
        ;; lsp-headerline-breadcrumb-enable-diagnostics t
        ;; lsp-headerline-breadcrumb-enable-symbol-numbers t

        lsp-modeline-code-actions-enable t
        ;; setq company-clang-insert-arguments t
        lsp-enable-snippet t
        lsp-ui-sideline-enable t
        lsp-ui-sideline-show-hover nil
        lsp-ui-sideline-show-diagnostics t
        lsp-ui-sideline-show-code-actions t
        ;; lsp-ui-doc-show-with-cursor nil
        ;; lsp-ui-doc-use-webkit nil
        ;; lsp-ui-doc-delay 0.2
        lsp-ui-doc-show-with-mouse t
        lsp-ui-doc-max-height 20
        lsp-ui-doc-max-width 200
        lsp-ui-doc-webkit-max-width-px 800

        lsp-modeline-code-actions-enable t

        ;; setq company-clang-insert-arguments t
        lsp-enable-snippet t)
  )


;; (after! format
;;   (set-formatter! 'clang-format
;;     '("clang-format"
;;       "-style={IndentWidth: 4}"
;;       ("-assume-filename=%S" (or buffer-file-name mode-result "")))))


;; (add-hook 'c-mode-hook
;;           (lambda ()
;;             ;; (set-formatter! 'clang-format "clang-format -style={IndentWidth: 4} ")
;;             (c-set-style "k&r")
;;             (setq tab-width 4
;;                   c-basic-offset 4
;;                   evil-shift-width 4
;;                   lsp-enable-indentation nil
;;                   clang-format-style "{IndentWidth: 4}")
;;             (message "Indents have been adjusted.")))
;; (add-hook 'c-mode-common-hook #'clang-format+-mode)

;; -- treemacs --
;; (after! treemacs (load! "~/.doom.d/local/treemacs-theme.el")
;;                  (treemacs-load-theme "nerd-icons"))

(after! treemacs
  (setq treemacs-fringe-indicator-mode 'only-when-focused)
  (lsp-treemacs-sync-mode 1))
;; (load! "~/.doom.d/local/treemacs-hydras.el")


;; -- dap-mode --
(require 'dap-mode)

(use-package! dap-mode
  :custom
  (dap-auto-configure-mode t)
  (dap-auto-configure-features '(controls tooltip repl locals))

  (defun my/hide-debug-windows (session)
    "Hide debug windows when all debug sessions are dead."
    (unless (-filter 'dap--session-running (dap--get-sessions))
      (and (get-buffer dap-ui--repl-buffer)
           (kill-buffer dap-ui--repl-buffer)
           (get-buffer dap-ui--locals-buffer)
           (kill-buffer dap-ui--locals-buffer)
           (get-buffer dap-ui--breakpoints-buffer)
           (kill-buffer dap-ui--breakpoints-buffer)
           (get-buffer dap-ui--expressions-buffer)
           (kill-buffer dap-ui--expressions-buffer)
           (get-buffer dap-ui--debug-window-buffer)
           (kill-buffer dap-ui--debug-window-buffer))))

  (add-hook 'dap-terminated-hook 'my/hide-debug-windows)

  :after lsp-mode

  :config
  (require 'cl)
  (require 'cl-lib)
  (require 'dap-ui)
  (require 'dap-mode)
  (require 'dap-python)
  (require 'dap-cpptools)

  (setq dap-python-debugger 'debugpy)
  (setq dap-netcore-download-url "https://github.com/Samsung/netcoredbg/releases/download/2.0.0-895/netcoredbg-linux-arm64.tar.gz")

  (dap-register-debug-template "cpptools::Run Configuration"
                               (list :name "cpptools::Run Configuration"
                                     :type "cppdbg"
                                     :request "launch"
                                     ;; :targetArchitecture "x86_64"
                                     :program "${workspaceFolder}/build/bin"
                                     :args ["-q"]
                                     :stopAtEntry "false"
                                     :cwd "${workspaceFolder}"
                                     :environment []
                                     :externalConsole "false"
                                     :MIMode "gdb"))

  (dap-register-debug-template "Python"
                               (list :type "python"
                                     :args "-i"
                                     :cwd nil
                                     :env '(("DEBUG" . "1"))
                                     :target-module nil ;;(expand-file-name "~/src/myapp/.env/bin/myapp")
                                     :request "launch"
                                     :name "Python"))

  (dap-register-debug-template "NetCoreDdg Launch"
                               (list :type "coreclr"
                                     :request "launch"
                                     :mode "launch"
                                     :name "NetCoreDbg Launch"
                                     :dap-compilation "dotnet build"
                                     :program "/home/dmitry/Projects/C#/Lab2-1/bin/Debug/net6.0/Lab2-1.dll"))

  :hook (dap-debug . flycheck-mode))

(with-eval-after-load 'dap-ui
  (setq dap-ui-buffer-configurations
        `((,dap-ui--locals-buffer . ((side . right) (slot . 1) (window-width . 0.22)))
          (,dap-ui--expressions-buffer . ((side . right) (slot . 2) (window-width . 0.22)))
          (,dap-ui--sessions-buffer . ((side . right) (slot . 3) (window-width . 0.22)))
          (,dap-ui--breakpoints-buffer . ((side . right) (slot . 4) (window-width . ,treemacs-width) (window-height . 0.20)))
          (,dap-ui--debug-window-buffer . ((side . bottom) (slot . 3) (window-width . 0.22)))
          (,dap-ui--repl-buffer . ((side . bottom) (slot . 0) (window-height . 0.22))))))

(defun my/buffer-to-side-window ()
  "Place the current buffer in the side window at the bottom."
  (interactive)
  (let ((buf (current-buffer)))
    (display-buffer-in-side-window
     buf '((window-height . 0.25)
           (side . bottom)
           (slot . 2)))
    (delete-window)))

;; `((,dap-ui--locals-buffer . ((side . right) (slot . 1) (window-width . 0.20)))
;;   (,dap-ui--expressions-buffer . ((side . right) (slot . 2) (window-width . 0.20)))
;;   (,dap-ui--sessions-buffer . ((side . right) (slot . 3) (window-width . 0.20)))
;;   (,dap-ui--breakpoints-buffer . ((side . left) (slot . 2) (window-width . ,treemacs-width)))
;;   (,dap-ui--debug-window-buffer . ((side . bottom) (slot . 3) (window-width . 0.20)))
;;   (,dap-ui--repl-buffer . ((side . bottom) (slot . 1) (window-height . 0.45))))

(defun my/stop-debugging-mode ()
  "Deletes all DAP sessiaons and windows"
  (interactive)
  (when (get-buffer dap-ui--repl-buffer)  (kill-buffer dap-ui--repl-buffer))
  (when (get-buffer dap-ui--locals-buffer)  (kill-buffer dap-ui--locals-buffer))
  (when (get-buffer dap-ui--breakpoints-buffer)  (kill-buffer dap-ui--breakpoints-buffer))
  (when (get-buffer dap-ui--expressions-buffer)  (kill-buffer dap-ui--expressions-buffer))
  (when (get-buffer dap-ui--debug-window-buffer)  (kill-buffer dap-ui--debug-window-buffer))
  (my/set-flycheck-margins)
  (my/revert-buffer-settings)
  (dap-delete-all-sessions))

;; Arguments given to clangd server. See https://emacs-lsp.github.io/lsp-mode/lsp-mode.html#lsp-clangd
(setq lsp-clients-clangd-args '(
                                ;; If set to true, code completion will include index symbols that are not defined in the scopes
                                ;; (e.g. namespaces) visible from the code completion point. Such completions can insert scope qualifiers
                                "--all-scopes-completion"
                                ;; Index project code in the background and persist index on disk.
                                "--background-index"
                                ;; Enable clang-tidy diagnostics
                                "--clang-tidy"
                                ;; Whether the clang-parser is used for code-completion
                                ;;   Use text-based completion if the parser is not ready (auto)
                                "--completion-parse=auto"
                                ;; Granularity of code completion suggestions
                                ;;   One completion item for each semantically distinct completion, with full type information (detailed)
                                "--completion-style=detailed"
                                ;; clang-format style to apply by default when no .clang-format file is found
                                "--fallback-style=WebKit"
                                ;; When disabled, completions contain only parentheses for function calls.
                                ;; When enabled, completions also contain placeholders for method parameters
                                "--function-arg-placeholders"
                                ;; Add #include directives when accepting code completions
                                ;;   Include what you use. Insert the owning header for top-level symbols, unless the
                                ;;   header is already directly included or the symbol is forward-declared
                                "--header-insertion=iwyu"
                                ;; Prepend a circular dot or space before the completion label, depending on whether an include line will be inserted or not
                                "--header-insertion-decorators"
                                ;; Enable index-based features. By default, clangd maintains an index built from symbols in opened files.
                                ;; Global index support needs to enabled separatedly
                                "--index"
                                ;; Attempts to fix diagnostic errors caused by missing includes using index
                                "--suggest-missing-includes"
                                ;; Number of async workers used by clangd. Background index also uses this many workers.
                                "-j=4"))

(after! lsp-clangd (set-lsp-priority! 'clangd 2))


(after! vterm
  (set-popup-rule! "^\\*doom:\\(?:v?term\\|e?shell\\)-popup" :vslot -5 :size 0.22 :select t :modeline nil :quit nil :ttl nil)
  (add-to-list 'display-buffer-alist '(".*cppdbg:.*" (display-buffer-below-selected) (window-height . 0.22) (window-parameters))))


(add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)


(defun screenshot-svg ()
  "Save a screenshot of the current frame as an SVG image.
 Saves to a temp file and puts the filename in the kill ring."
  (interactive)
  (let* ((filename (make-temp-file "Emacs" nil ".svg"))
         (data (x-export-frames nil 'svg)))
    (with-temp-file filename
      (insert data))
    (kill-new filename)
    (message filename)))

;; (use-package! pdf-tools
;;   :init (pdf-tools-install))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
