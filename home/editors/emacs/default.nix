{ lib, config, pkgs, inputs, ... }:

let
  # Helper function for font sizes
  fontSize = size: toString size;

  # Define Doom directories
  doomDir = "${config.xdg.configHome}/doom";
  doomLocalDir = "${config.xdg.dataHome}/doom";
  doomProfileLoadFile = "${config.xdg.cacheHome}/profile-load.el";

  # Dependencies for Emacs
  emacs-dependencies = with pkgs; [
    # Core utilities
    git fd ripgrep hunspell
    hunspellDicts.en_US hunspellDicts.ru_RU
    cmigemo shellcheck shfmt

    # Development tools
    gnumake cmake clang clang-tools glslang
    nodejs nodePackages.js-beautify
    pipenv python3Packages.pytest python3Packages.pyflakes python3Packages.black

    # Formatting/linting
    nixfmt-classic alejandra html-tidy stylelint

    # Documentation
    texliveFull graphviz multimarkdown

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

in {
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
        onChange = let
          doomSyncScript = pkgs.writeShellScript "doom-sync" ''
            export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}"
            if [ -d "${doomDir}" ]; then
              doom --force sync -u
            else
              doom --force install
            fi
          '';
        in toString doomSyncScript;
      };
    };

    # Install and enable Emacs with the daemon service
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: [ epkgs.vterm ];
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      startWithUserSession = true;
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

            (setq ispell-program-name "${pkgs.hunspell}/bin/hunspell"
                  ispell-dictionary "en_US,ru_RU"
                  ispell-local-dictionary-alist '(("en_US,ru_RU" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US,ru_RU") nil utf-8)
                  ispell-hunspell-dict-paths-alist '(("en_US" "${pkgs.hunspellDicts.en_US}/share/hunspell/en_US.aff")
                                                      ("ru_RU" "${pkgs.hunspellDicts.ru_RU}/share/hunspell/ru_RU.aff")))

            (add-hook 'text-mode-hook 'flyspell-mode)
            (add-hook 'prog-mode-hook 'flyspell-prog-mode)

            ;; Enable LSP plists for better performance
            (setq lsp-use-plists t)
          '';
        };

        "${doomDir}/custom.el".source = ./custom.el;

        "${doomDir}/init.el" = {
          text = ''
            ${builtins.readFile ./init.el}
          '';
          onChange = toString (pkgs.writeShellScript "doom-init-change" ''
            export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}"
            doom --force sync
          '');
        };

        "${doomDir}/packages.el" = {
          source = ./packages.el;
          onChange = toString (pkgs.writeShellScript "doom-packages-change" ''
            export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}"
            doom --force sync
          '');
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
