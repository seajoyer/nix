{ lib, config, pkgs, inputs, ... }:

let
  fontSize = size: toString size;

  doomDir             = "${config.xdg.configHome}/doom";
  doomLocalDir        = "${config.xdg.dataHome}/doom";
  doomProfileLoadFile = "${config.xdg.cacheHome}/profile-load.el";

  emacs-deps = with pkgs; [
    # core
    git fd ripgrep hunspell hunspellDicts.en_US hunspellDicts.ru_RU
    cmigemo shellcheck shfmt poppler-utils vips

    # build
    gnumake cmake glslang sqlite nodejs js-beautify
    pipenv poetry ty clang-tools libxml2 jdk
    python3Packages.python
    python3Packages.pytest python3Packages.pyflakes
    python3Packages.uv python3Packages.isort

    # formatting / linting
    nixfmt html-tidy stylelint

    # documentation
    texliveFull graphviz multimarkdown
    texlivePackages.gost texlivePackages.biblatex-gost

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
    export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}/bin"
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
    package      = pkgs.emacs-pgtk;
    extraPackages = epkgs: [
      epkgs.vterm
      epkgs.treesit-grammars.with-all-grammars
    ];
  };

  services.emacs = {
    enable               = true;
    package              = pkgs.emacs-pgtk;
    client.enable        = true;
    socketActivation.enable = true;
    startWithUserSession = false;
  };

  xdg.configFile = {
    "${doomDir}/config.el".text = ''
      (setq doom-font                (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size ${fontSize 19} :weight 'regular)
            doom-variable-pitch-font (font-spec :family "Inter"                            :size ${fontSize 19} :weight 'regular)
            doom-big-font            (font-spec :family "JetBrainsMonoNL Nerd Font Propo" :size ${fontSize 24} :weight 'regular)
            doom-symbol-font         (font-spec :family "Symbols Nerd Font"                :size ${fontSize 19})
            doom-serif-font          (font-spec :family "FreeSerif"                        :size ${fontSize 19} :weight 'regular)
            nerd-icons-font-names    '("JetBrainsMonoNFP-Regular.ttf")
            nerd-icons-font-family   "JetBrainsMonoNL Nerd Font Propo")

      ${builtins.readFile ./doom/config.el}

      (setq lsp-use-plists t)
    '';

    "${doomDir}/custom.el".source = ./doom/custom.el;

    "${doomDir}/init.el" = {
      text     = builtins.readFile ./doom/init.el;
      onChange = toString (pkgs.writeShellScript "doom-init-change" ''
        export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}/bin"
        doom --force sync
      '');
    };

    "${doomDir}/packages.el" = {
      source   = ./doom/packages.el;
      onChange = toString (pkgs.writeShellScript "doom-packages-change" ''
        export PATH="$HOME/.emacs.d/bin:$PATH:${pkgs.emacs-pgtk}/bin"
        doom --force sync
      '');
    };
  };

  programs.zsh.localVariables = {
    PATH                = "$PATH:$HOME/.emacs.d/bin:${pkgs.emacs-pgtk}/bin";
    DOOMDIR             = doomDir;
    DOOMLOCALDIR        = doomLocalDir;
    DOOMPROFILELOADFILE = doomProfileLoadFile;
  };
}
