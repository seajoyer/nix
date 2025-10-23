;;; init.el -*- lexical-binding: t; -*-

;; This file controls what Doom modules are enabled and what order they load
;; in. Remember to run 'doom sync' after modifying it!

;; NOTE Press 'SPC h d h' (or 'C-h d h' for non-vim users) to access Doom's
;;      documentation. There you'll find a link to Doom's Module Index where all
;;      of our modules are listed, including what flags they support.

;; NOTE Move your cursor over a module's name (or its flags) and press 'K' (or
;;      'C-c c k' for non-vim users) to view its documentation. This works on
;;      flags as well (those symbols that start with a plus).
;;
;;      Alternatively, press 'gd' (or 'C-c c d') on a module to browse its
;;      directory (for easy access to its source code).

(doom!
       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                   Input and Language Support
       ;;; ══════════════════════════════════════════════════════════════════════
       :input
       ;;bidi              ; (tfel ot) thgir etirw uoy gnipleh
       chinese             ; 中文支持
       japanese            ; 日本語支持
       ;;layout            ; auie,ctsrnm is the superior home row

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                          Completion
       ;;; ══════════════════════════════════════════════════════════════════════
       :completion
       (corfu +icons       ; Flexible completion at point
              +orderless
              +dabbrev)
       ;; (company +tng)   ; The ultimate code completion backend
       ;; (helm +icons)    ; The *other* search engine for love and life
       ;; ido              ; The other *other* search engine...
       ;; (ivy +icons)     ; A search engine for love and life
       ;;       ;; +fuzzy
       ;;       ;; +prescient)
       (vertico +icons)    ; The search engine of the future

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                        UI Enhancements
       ;;; ══════════════════════════════════════════════════════════════════════
       :ui
       deft                ; Notational velocity for Emacs
       doom                ; What makes DOOM look the way it does
       doom-dashboard      ; A nifty splash screen for Emacs
       doom-quit           ; DOOM quit-message prompts when you quit Emacs
       (emoji +unicode)    ; 🙂
       hl-todo             ; Highlight TODO/FIXME/NOTE/DEPRECATED/HACK/REVIEW
       indent-guides    ; Highlighted indent columns
       (ligatures +fira)   ; Ligatures and symbols to make your code pretty again
       minimap             ; Show a map of the code on the side
       modeline            ; Snazzy, Atom-inspired modeline, plus API
       ;;nav-flash         ; Blink cursor line after big motions
       ;;neotree           ; A project drawer, like NERDTree for vim
       ophints             ; Highlight the region an operation acts on
       (popup +defaults)   ; Tame sudden yet inevitable temporary windows
       ;;tabs              ; A tab bar for Emacs
       (treemacs +lsp)     ; A project drawer, like neotree but cooler
       unicode             ; Extended unicode support for various languages
       (vc-gutter +pretty) ; VCS diff in the fringe
       vi-tilde-fringe     ; Fringe tildes to mark beyond EOB
       window-select       ; Visually switch windows
       workspaces          ; Tab emulation, persistence & separate workspaces
       zen                 ; Distraction-free coding or writing

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                      Editing Enhancements
       ;;; ══════════════════════════════════════════════════════════════════════
       :editor
       (evil +everywhere)  ; Come to the dark side, we have cookies
       file-templates      ; Auto-snippets for empty files
       fold                ; (Nigh) universal code folding
       format              ; Automated prettiness
       ;;god               ; Run Emacs commands without modifier keys
       ;;lispy             ; Vim for lisp, for people who don't like vim
       multiple-cursors    ; Editing in many places at once
       ;;objed             ; Text object editing for the innocent
       ;;parinfer          ; Turn lisp into python, sort of
       rotate-text         ; Cycle region at point between text candidates
       snippets            ; My elves. They type so I don't have to
       word-wrap           ; Soft wrapping with language-aware indent

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                    Emacs Core Enhancements
       ;;; ══════════════════════════════════════════════════════════════════════
       :emacs
       (dired +icons)      ; Making dired pretty [functional]
       electric            ; Smarter, keyword-based electric-indent
       tramp               ; Remote file editing
       (ibuffer +icons)    ; Interactive buffer management
       undo                ; Persistent, smarter undo for your inevitable mistakes
       vc                  ; Version-control and Emacs, sitting in a tree

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                      Terminal Emulators
       ;;; ══════════════════════════════════════════════════════════════════════
       :term
       ;;eshell            ; The elisp shell that works everywhere
       ;;shell             ; Simple shell REPL for Emacs
       ;;term              ; Basic terminal emulator for Emacs
       vterm               ; The best terminal emulation in Emacs

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                 Syntax and Spell Checking
       ;;; ══════════════════════════════════════════════════════════════════════
       :checkers
       syntax              ; Tasing you for every semicolon you forget
       (spell +flyspell    ; Tasing you for misspelling mispelling
              +hunspell)
       ;; grammar          ; Tasing grammar mistake every you make

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                     Tools and Utilities
       ;;; ══════════════════════════════════════════════════════════════════════
       :tools
       ;;ansible
       ;;biblio            ; Writes a PhD for you (citation needed)
       ;;collab            ; Buffers with friends
       (debugger +lsp)     ; FIXME stepping through code, to help you add bugs
       direnv              ; Environment management
       ;;docker
       ;;editorconfig      ; Let someone else argue about tabs vs spaces
       ;;ein               ; Tame Jupyter notebooks with emacs
       (eval +overlay)     ; Run code, run (also, repls)
       (lookup +dictionary ; Navigate your code and its documentation
               +offline
               +docsets)
       (lsp +peek)         ; M-x vscode
       magit               ; A git porcelain for Emacs
       make                ; Run make tasks from Emacs
       ;;pass              ; Password manager for nerds
       pdf                 ; PDF enhancements
       rgb                 ; Create color strings
       ;;prodigy           ; FIXME managing external services & code builders
       ;;terraform         ; Infrastructure as code
       ;;tmux              ; An API for interacting with tmux
       tree-sitter         ; Syntax and parsing, sitting in a tree...
       upload              ; Map local to remote projects via ssh/ftp

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                         OS Integration
       ;;; ══════════════════════════════════════════════════════════════════════
       :os
       (:if (featurep :system 'macos) macos)  ; Improve compatibility with macOS
       tty                 ; Improve the terminal Emacs experience

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                     Programming Languages
       ;;; ══════════════════════════════════════════════════════════════════════
       :lang
       ;;agda              ; Types of types of types of types...
       ;;beancount         ; Mind the GAAP
       (cc +lsp
           +tree-sitter)           ; C > C++ == 1
       ;;clojure           ; Java with a lisp
       ;;common-lisp       ; If you've seen one lisp, you've seen them all
       ;;coq               ; Proofs-as-programs
       ;;crystal           ; Ruby at the speed of c
       ;; (csharp +lsp
       ;;         +dotnet) ; Unity, .NET, and mono shenanigans
       ;;csharp            ; Unity, .NET, and mono shenanigans
       ;;data              ; Config/data formats
       ;;(dart +flutter)   ; Paint ui and not much else
       ;;dhall
       ;;elixir            ; Erlang done right
       ;;elm               ; Care for a cup of TEA?
       emacs-lisp          ; Drown in parentheses
       ;;erlang            ; An elegant language for a more civilized age
       ;;ess               ; Emacs speaks statistics
       ;;factor
       ;;faust             ; DSP, but you get to keep your soul
       ;;fortran           ; In FORTRAN, GOD is REAL (unless declared INTEGER)
       ;;fsharp            ; ML stands for Microsoft's Language
       ;;fstar             ; (Dependent) types and (monadic) effects and Z3
       ;;gdscript          ; The language you waited for
       ;;(go +lsp)         ; The hipster dialect
       ;;(graphql +lsp)    ; Give queries a REST
       ;;(haskell +lsp)    ; A language that's lazier than I am
       ;;hy                ; Readability of scheme w/ speed of python
       ;;idris             ; A language you can depend on
       json                ; At least it ain't XML
       (java +lsp)         ; The poster child for carpal tunnel syndrome
       (javascript +lsp
                   +tree-sitter)   ; All(hope(abandon(ye(who(enter(here))))))
       ;;julia             ; A better, faster MATLAB
       ;;kotlin            ; A better, slicker Java(Script)
       (latex +fold         ; Writing papers in Emacs has never been so fun
              +lsp
              +cdlatex)
       ;;lean              ; For folks with too much to prove
       ;;ledger            ; Be audit you can be
       ;;lua               ; One-based indices? One-based indices
       markdown            ; Writing docs for people to ignore
       ;;nim               ; Python + lisp at the speed of c
       (nix +lsp
            +tree-sitter)  ; I hereby declare "nix geht mehr!"
       ;;ocaml             ; An objective camel
       (org +dragndrop     ; Organize your plain life in plain text
            +pomodoro
            +jupyter
            +pretty
            +roam
            +noter)
       ;;php               ; Perl's insecure younger brother
       ;;plantuml          ; Diagrams for confusing people more
       ;;purescript        ; Javascript, but functional
       (python +lsp        ; Beautiful is better than ugly
               +pyright
               +tree-sitter)
       ;;qt                ; The 'cutest' gui framework ever
       ;;racket            ; A DSL for DSLs
       ;;raku              ; The artist formerly known as perl6
       ;;rest              ; Emacs as a REST client
       ;;rst               ; ReST in peace
       ;;(ruby +rails)     ; 1.step {|i| p "Ruby is #{i.even? ? 'love' : 'life'}"}
       ;;rust              ; Fe2O3.unwrap().unwrap().unwrap().unwrap()
       ;;scala             ; Java, but good
       ;;(scheme +guile)   ; A fully conniving family of lisps
       (sh +lsp            ; She sells {ba,z,fi}sh shells on the C xor
           +fish
           +powershell)
       ;;sml
       ;;solidity          ; Do you need a blockchain? No.
       ;;swift             ; Who asked for emoji variables?
       ;;terra             ; Earth and Moon in alignment for performance.
       web                 ; The tubes
       ;;yaml              ; JSON, but readable
       ;;zig               ; C, but simpler

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                            Email
       ;;; ══════════════════════════════════════════════════════════════════════
       :email
       ;;(mu4e +org +gmail)
       ;;notmuch
       ;;(wanderlust +gmail)

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                            Apps
       ;;; ══════════════════════════════════════════════════════════════════════
       :app
       calendar
       ;;emms
       ;;everywhere        ; *leave* Emacs!? You must be joking
       ;;irc               ; How neckbeards socialize
       ;;(rss +org)        ; Emacs as an RSS reader

       ;;; ══════════════════════════════════════════════════════════════════════
       ;;;                           Config
       ;;; ══════════════════════════════════════════════════════════════════════
       :config
       ;;literate
       (default +bindings +smartparens))
