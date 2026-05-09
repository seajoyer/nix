{
  pkgs,
  lib,
  config,
  ...
}:

lib.mkIf config.my.shell.yazi.enable {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    shellWrapperName = "y";

    extraPackages = with pkgs; [
      ffmpeg
      poppler
      fd
      ripgrep
      fzf
      zoxide
      imagemagick
      ripdrag
    ];

    settings = {
      mgr = {
        show_hidden = true;
        show_symlink = true;
        sort_by = "natural";
      };
      preview = {
        max_width = 1000;
        max_height = 1000;
      };
      opener = {
        edit = [
          {
            run = ''$EDITOR "$@"'';
            block = true;
          }
        ];
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<C-d>" ];
          run = "plugin drag";
          desc = "Drag Files";
        }
      ];
    };

    initLua = ''
      require("full-border"):setup()
    '';

    plugins = {
      full-border = pkgs.yaziPlugins.full-border;
      mount = pkgs.yaziPlugins.mount;
      drag = pkgs.yaziPlugins.drag;
    };
  };
}
