{ lib, config, pkgs, inputs, outputs, ... }@moduleArgs:

let
  my-emacs = let
    emacsPkg = with pkgs;
      (emacsPackagesFor emacs29).emacsWithPackages
      (ps: with ps; [ vterm ]);
  in emacsPkg // (pkgs.symlinkJoin {
    name = "my-emacs";
    paths = [ emacsPkg ];
    nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
    postBuild = ''
      wrapProgram $out/bin/emacs \
        --set LSP_USE_PLISTS true
    '';
  });

in {
    config = with config.my; {
        home = {
            sessionPath = [ "~/.emacs.d/bin" ];
            sessionVariables = with config.xdg; # buggy with zsh, workaround is below
            let
                EDITOR = pkgs.writeShellScript "editor" ''
                    if [ -n "$INSIDE_EMACS" ]; then
                      ${my-emacs}/bin/emacsclient --quiet "$@"
                    else
                      ${my-emacs}/bin/emacsclient --create-frame --alternate-editor="" --quiet "$@"
                    fi
                '';
                VISUAL = EDITOR;
            in rec {
                inherit EDITOR VISUAL;
                DOOMDIR = "${configHome}/doom";
                DOOMLOCALDIR = "${dataHome}/doom";
		DOOMPROFILELOADFILE = "${cacheHome}/profile-load.el";
            };

	    file = {
                ".emacs.d" = {
                    source = inputs.doomemacs;
                    onChange = "${pkgs.writeShellScript "doom-change" ''
                        export PATH="$HOME/.emacs.d/bin/:${my-emacs}/bin:$PATH"
                        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
                        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
			export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}";

                        if [ -d "$DOOMDIR" ]; then
                          doom --force sync -u
                        else
                          doom --force install
                        fi
                    ''}";
                };
            };


	    packages = with pkgs; [
	        my-emacs 
		(writeShellScriptBin "edit"
                    (toString config.home.sessionVariables.EDITOR))
	    ];
        };
        
        services = {
            emacs = {
                enable = true;
                package = my-emacs;
                client.enable = true;
            };
        }; 
        
        xdg = {
	    desktopEntries = {
                my-emacs = {
                    name = "My Emacs";
                    exec = "${pkgs.emacs29-pgtk}/bin/emacs --with-profile default";
                    icon = "emacs";
                    type = "Application";
                    terminal = false;
                    categories = [ "System" ];
                };
	    };
	    configFile = with config.xdg; {
                "${configHome}/doom/config.el" = {
		    text = ''

(setq doom-font                (font-spec :family "JetBrainsMono Nerd Font Propo" :size ${toString (adjust 24)} :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Inter"                         :size ${toString (adjust 24)} :weight 'regular)
      doom-big-font            (font-spec :family "JetBrainsMono Nerd Font Propo" :size ${toString (adjust 30)} :weight 'regular)
      doom-symbol-font         (font-spec :family "Symbols Nerd Font"             :size ${toString (adjust 24)}                 )
      doom-serif-font          (font-spec :family "FreeSerif"                     :size ${toString (adjust 24)} :weight 'regular)
      nerd-icons-font-names   '("JetBrainsMonoNerdFontPropo-Regular.ttf") 
      nerd-icons-font-family    "JetBrainsMono Nerd Font Propo")

${builtins.readFile ./config.el};

	            '';
          	};

                "${configHome}/doom/custom.el".source = ./custom.el;
                
                "${configHome}/doom/init.el" = {
                    text = ''
		        ${builtins.readFile ./init.el}

		        ;; Doom emacs dependencies
		        (setq exec-path (append '("${
                            pkgs.buildEnv {
                                name = "my-emacs-deps";
                                pathsToLink = [ "/bin" ];
                                paths = map lib.getBin (with pkgs; [
                                    git
                                    # emacs-lsp-booster
                                    texlive.combined.scheme-medium
				    (ripgrep.override { withPCRE2 = true; })
                                    black
                                    isort
				    fd
				    gnumake
				    cmake
				    glslang
				    sqlite
				    cmigemo
				    shellcheck
				    shfmt
				    multimarkdown
				    clang-tools
                                    pipenv
                                    python3
                                    python3Packages.pytest
                                    python3Packages.nose
                                    python3Packages.pyflakes
                                    # python3Packages.python-lsp-server
                                    # python3Packages.grip
                                    # multimarkdown

				    emacs-all-the-icons-fonts
                                    (nerdfonts.override {
                                        fonts = [
					    "NerdFontsSymbolsOnly"
                                            "JetBrainsMono"
                                            "Iosevka"
                                        ];
                                    })
				    inter
                                ]);
                            }
                        }/bin") exec-path))
		    '';
                    onChange = "${pkgs.writeShellScript "doom-config-init-change" ''
                        export PATH="~/.emacs.d/bin:${my-emacs}/bin:$PATH"
                        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
                        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
			export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}";

                        doom --force sync
                    ''}";
                };
                
                "${configHome}/doom/packages.el" = {
                    source = ./packages.el;
                    onChange = "${pkgs.writeShellScript "doom-config-packages-change" ''
                        export PATH="~/.emacs.d/bin:${my-emacs}/bin:$PATH"
                        export DOOMDIR="${config.home.sessionVariables.DOOMDIR}"
                        export DOOMLOCALDIR="${config.home.sessionVariables.DOOMLOCALDIR}"
			export DOOMPROFILELOADFILE="${config.home.sessionVariables.DOOMPROFILELOADFILE}";

                        doom --force sync
                    ''}";
                };
	    };
        };
        programs.zsh.localVariables = with config.xdg; {
            PATH = "$PATH:$HOME/.emacs.d/bin";
            DOOMDIR = "${configHome}/doom";
            DOOMLOCALDIR = "${dataHome}/doom";
	    DOOMPROFILELOADFILE = "${cacheHome}/profile-load.el";
        };
    };
}
