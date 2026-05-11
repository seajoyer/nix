{ lib, config, pkgs, inputs, ... }:

let
  emacsPkg = pkgs.emacs-pgtk;
  treesitGrammars = (pkgs.emacsPackagesFor emacsPkg).treesit-grammars.with-all-grammars;

  fontSize = size: toString size;

  doomDir             = "${config.xdg.configHome}/doom";
  doomLocalDir        = "${config.xdg.dataHome}/doom";
  doomProfileLoadFile = "${config.xdg.cacheHome}/profile-load.el";

  emacs-deps = with pkgs; [
    # core
    git fd ripgrep hunspell hunspellDicts.en_US hunspellDicts.ru_RU
    cmigemo shellcheck shfmt poppler-utils vips gcc

    # build
    gnumake cmake glslang sqlite nodejs js-beautify
    pipenv poetry ty clang-tools libxml2 jdk
    python3Packages.python
    python3Packages.pytest python3Packages.pyflakes
    python3Packages.uv python3Packages.isort

    # formatting / linting
    nixfmt-rfc-style html-tidy stylelint

    # documentation
    graphviz multimarkdown
    (texlive.combine {
    inherit (pkgs.texlive) scheme-medium gost biblatex-gost;
    })

    # GUI helpers
    maim

    # language servers
    cmake-language-server nil

    # fonts
    emacs-all-the-icons-fonts
    nerd-fonts.symbols-only nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka nerd-fonts.lilex
    inter
  ];

  doomSyncScript = pkgs.writeShellScript "doom-sync" ''
    export PATH="$HOME/.emacs.d/bin:$PATH:${emacsPkg}/bin"
    if [ -d "${doomDir}" ]; then
      doom --force sync -u
    else
      doom --force install
    fi
  '';
in
lib.mkIf config.my.editors.emacs.enable {
  home = {
    sessionPath = [ "$HOME/.emacs.d/bin" ];

    sessionVariables = {
      EDITOR              = "emacsclient --alternate-editor=emacs";
      VISUAL              = "emacsclient --alternate-editor=emacs";
      DOOMDIR             = doomDir;
      DOOMLOCALDIR        = doomLocalDir;
      DOOMPROFILELOADFILE = doomProfileLoadFile;
    };

    packages = emacs-deps;

    file.".emacs.d" = {
      source   = inputs.doomemacs;
      onChange = toString doomSyncScript;
    };
  };

  programs.emacs = {
    enable       = true;
    package      = emacsPkg;
    extraPackages = epkgs: [
      epkgs.vterm
    ];
  };

  services.emacs = {
    enable               = true;
    package              = emacsPkg;
    client.enable        = true;
    socketActivation.enable = true;
    startWithUserSession = false;
  };

  xdg.configFile = {
    "${doomDir}/config.el".text = ''
    (defun my/setup-fonts (&optional _frame)
    "Apply font and fontset configuration. Safe to call from a frame hook."
    (when (display-graphic-p)
        ;; Doom variables you already had:
        (setq doom-font                (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size ${fontSize 16} :weight 'regular)
            doom-variable-pitch-font (font-spec :family "Inter"                             :size ${fontSize 16} :weight 'regular)
            doom-big-font            (font-spec :family "JetBrainsMonoNL Nerd Font Propo"   :size ${fontSize 20} :weight 'regular)
            doom-symbol-font         (font-spec :family "Symbols Nerd Font"                 :size ${fontSize 16})
            doom-serif-font          (font-spec :family "FreeSerif"                         :size ${fontSize 16} :weight 'regular)
            nerd-icons-font-names    '("JetBrainsMonoNFP-Regular.ttf")
            nerd-icons-font-family   "JetBrainsMonoNL Nerd Font Propo")

    ;; Cyrillic fallback.
    (set-fontset-font t 'cyrillic (font-spec :family "DejaVu Sans Mono"))

    ;; Symbol/icon fallback for the private-use ranges that Nerd Font icons live in.
    ;; This is the right way — much cleaner than enumerating individual codepoints.
    (set-fontset-font t '(#xe000 . #xf8ff)   (font-spec :family "Symbols Nerd Font Mono") nil 'prepend)
    (set-fontset-font t '(#xf0000 . #xfffff) (font-spec :family "Symbols Nerd Font Mono") nil 'prepend)

    ;; Force Doom to redo its font work now that we have a real frame.
    (when (fboundp 'doom/reload-font)
      (doom/reload-font))))

(if (daemonp)
    (add-hook 'server-after-make-frame-hook #'my/setup-fonts)
  (my/setup-fonts))

      ;; Point Doom at the Nix-built tree-sitter grammars.
      (with-eval-after-load 'treesit
          (add-to-list 'treesit-extra-load-path "${treesitGrammars}/lib/"))
      ;; Never let Doom shell out to `cc` to build grammars at runtime.
      (setq treesit-language-source-alist nil)

      ${builtins.readFile ./doom/config.el}

      (setq lsp-use-plists t)
    '';

    "${doomDir}/custom.el".source = ./doom/custom.el;

    "${doomDir}/init.el" = {
      text     = builtins.readFile ./doom/init.el;
      onChange = toString (pkgs.writeShellScript "doom-init-change" ''
        export PATH="$HOME/.emacs.d/bin:$PATH:${emacsPkg}/bin"
        doom --force sync
      '');
    };

    "${doomDir}/packages.el" = {
      source   = ./doom/packages.el;
      onChange = toString (pkgs.writeShellScript "doom-packages-change" ''
        export PATH="$HOME/.emacs.d/bin:$PATH:${emacsPkg}/bin"
        doom --force sync
      '');
    };
  };

  programs.zsh.sessionVariables = {
    PATH                = "$PATH:$HOME/.emacs.d/bin:${emacsPkg}/bin";
    DOOMDIR             = doomDir;
    DOOMLOCALDIR        = doomLocalDir;
    DOOMPROFILELOADFILE = doomProfileLoadFile;
  };
}
