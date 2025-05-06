{ lib, config, pkgs, inputs, outputs, ... }@moduleArgs:

let
  # Helper function to create font size values (assuming 'adjust' was a typo)
  fontSize = size: toString size;

  # Emacs configuration
  my-emacs = let
    emacsPkg = (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (ps: [ ps.vterm ]);
  in emacsPkg // pkgs.symlinkJoin {
    name = "my-emacs";
    paths = [ emacsPkg ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs --set LSP_USE_PLISTS true
    '';
  };

  # Doom directories
  doomDir = "${config.xdg.configHome}/doom";
  doomLocalDir = "${config.xdg.dataHome}/doom";
  doomProfileLoadFile = "${config.xdg.cacheHome}/profile-load.el";

  # Combined dependencies
  my-emacs-deps = pkgs.buildEnv {
    name = "my-emacs-deps";
    pathsToLink = [ "/bin" "/share" ];
    paths = map lib.getBin (with pkgs; [
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
    ]);
  };

  # Editor script
  editorScript = pkgs.writeShellScriptBin "editor" ''
    if [ -n "$INSIDE_EMACS" ]; then
      ${my-emacs}/bin/emacsclient --quiet "$@"
    else
      ${my-emacs}/bin/emacsclient --create-frame --alternate-editor="" --quiet "$@"
    fi
  '';

in {
  config = {
    home = {
      sessionPath = [ "$HOME/.emacs.d/bin" ];
      sessionVariables = {
        EDITOR = "${editorScript}/bin/editor";
        VISUAL = "${editorScript}/bin/editor";
        DOOMDIR = doomDir;
        DOOMLOCALDIR = doomLocalDir;
        DOOMPROFILELOADFILE = doomProfileLoadFile;
      };

      packages = with pkgs; [
        my-emacs
        my-emacs-deps
        editorScript
      ];

      file.".emacs.d" = {
        source = inputs.doomemacs;
        onChange = let
          doomSyncScript = pkgs.writeShellScript "doom-sync" ''
            export PATH="$HOME/.emacs.d/bin:${my-emacs}/bin:$PATH"
            if [ -d "${doomDir}" ]; then
              doom --force sync -u
            else
              doom --force install
            fi
          '';
        in toString doomSyncScript;
      };
    };

    services.emacs = {
      enable = true;
      package = my-emacs;
      client.enable = false;
    };

    xdg = {
      desktopEntries.my-emacs = {
        name = "My Emacs";
        exec = "${my-emacs}/bin/emacs --with-profile default";
        icon = "emacs";
        type = "Application";
        terminal = false;
        categories = [ "Development" "TextEditor" ];
      };

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

            (setq ispell-program-name "${my-emacs-deps}/bin/hunspell"
                  ispell-dictionary "en_US,ru_RU"
                  ispell-local-dictionary-alist '(("en_US,ru_RU" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US,ru_RU") nil utf-8)
                  ispell-hunspell-dict-paths-alist '(("en_US" "${my-emacs-deps}/share/hunspell/en_US.aff")
                                                      ("ru_RU" "${my-emacs-deps}/share/hunspell/ru_RU.aff")))

            (add-hook 'text-mode-hook 'flyspell-mode)
            (add-hook 'prog-mode-hook 'flyspell-prog-mode)
          '';
        };

        "${doomDir}/custom.el".source = ./custom.el;

        "${doomDir}/init.el" = {
          text = ''
            ${builtins.readFile ./init.el}
            (setq exec-path (append '("${my-emacs-deps}/bin") exec-path))
          '';
          onChange = toString (pkgs.writeShellScript "doom-init-change" ''
            export PATH="$HOME/.emacs.d/bin:${my-emacs}/bin:$PATH"
            doom --force sync
          '');
        };

        "${doomDir}/packages.el" = {
          source = ./packages.el;
          onChange = toString (pkgs.writeShellScript "doom-packages-change" ''
            export PATH="$HOME/.emacs.d/bin:${my-emacs}/bin:$PATH"
            doom --force sync
          '');
        };
      };
    };

    programs.zsh.localVariables = {
      PATH = "$PATH:$HOME/.emacs.d/bin";
      DOOMDIR = doomDir;
      DOOMLOCALDIR = doomLocalDir;
      DOOMPROFILELOADFILE = doomProfileLoadFile;
    };
  };
}
