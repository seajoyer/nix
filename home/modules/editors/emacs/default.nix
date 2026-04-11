{ lib, config, pkgs, inputs, ... }:

let
  # Helper function for font sizes
  fontSize = size: toString size;

  doomDir = "${config.xdg.configHome}/doom";
  doomLocalDir = "${config.xdg.dataHome}/doom";
  doomProfileLoadFile = "${config.xdg.cacheHome}/profile-load.el";

  emacs-dependencies = with pkgs; [
    # Core utilities
    git
    fd
    ripgrep
    hunspell
    hunspellDicts.en_US
    hunspellDicts.ru_RU
    cmigemo
    shellcheck
    shfmt
    poppler-utils

    # Development tools
    gnumake
    cmake

    glslang
    sqlite
    nodejs
    nodePackages.js-beautify
    pipenv
    poetry
    ty
    python3Packages.pytest
    python3Packages.pyflakes
    python3Packages.uv
    python3Packages.isort

    # Formatting/linting
    nixfmt
    html-tidy
    stylelint

    # Documentation
    texliveFull
    graphviz
    multimarkdown
    texlivePackages.gost
    texlivePackages.biblatex-gost

    # GUI tools
    maim

    # Language servers
    cmake-language-server

    # Fonts
    emacs-all-the-icons-fonts
    nerd-fonts.symbols-only
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
    nerd-fonts.lilex
    inter
  ];

in lib.mkIf config.my.editors.emacs.enable {
  config = {
    home = {
      sessionPath = [ "$HOME/.emacs.d/bin" ];
      sessionVariables = {
        EDITOR = "emacsclient --alternate-editor=emacs";
        VISUAL = "emacsclient --alternate-editor=emacs";
        DOOMDIR = doomDir;
        DOOMLOCALDIR = doomLocalDir;
        DOOMPROFILELOADFILE = doomProfileLoadFile;
      };

      packages = emacs-dependencies;

      file.".emacs.d" = {
        source = inputs.doomemacs;
        onChange =
          let
            doomSyncScript = pkgs.writeShellScript "doom-sync" ''
              export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}"
              if [ -d "${doomDir}" ]; then
                doom --force sync -u
              else
                doom --force install
              fi
            '';
          in
          toString doomSyncScript;
      };
    };

    # Install and enable Emacs with the daemon service
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: [
        epkgs.vterm
        epkgs.treesit-grammars.with-all-grammars
      ];
    };

    services.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      client.enable = true;
      socketActivation.enable = true;
      startWithUserSession = false;
    };

    xdg = {
      configFile = {
        "${doomDir}/config.el" = {
          text = ''
            (setq doom-font (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size ${fontSize 19} :weight 'regular)
                  doom-variable-pitch-font (font-spec :family "Inter" :size ${fontSize 19} :weight 'regular)
                  doom-big-font (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size ${fontSize 24} :weight 'regular)
                  doom-symbol-font (font-spec :family "Symbols Nerd Font" :size ${fontSize 19})
                  doom-serif-font (font-spec :family "FreeSerif" :size ${fontSize 19} :weight 'regular)
                  nerd-icons-font-names '("JetBrainsMonoNFP-Regular.ttf")
                  nerd-icons-font-family "JetBrainsMonoNL Nerd Font Propo")

            ${builtins.readFile ./config.el}

            (setq lsp-use-plists t)
          '';
        };

        "${doomDir}/custom.el".source = ./custom.el;

        "${doomDir}/init.el" = {
          text = ''
            ${builtins.readFile ./init.el}
          '';
          onChange = toString (
            pkgs.writeShellScript "doom-init-change" ''
              export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}"
              doom --force sync
            ''
          );
        };

        "${doomDir}/packages.el" = {
          source = ./packages.el;
          onChange = toString (
            pkgs.writeShellScript "doom-packages-change" ''
              export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}"
              doom --force sync
            ''
          );
        };
      };
    };

    programs.zsh.localVariables = {
      PATH = "$PATH:$HOME/.emacs.d/bin:${pkgs.emacs-pgtk}";
      DOOMDIR = doomDir;
      DOOMLOCALDIR = doomLocalDir;
      DOOMPROFILELOADFILE = doomProfileLoadFile;
    };
  };
}
