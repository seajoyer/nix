{ pkgs, ... }:

{
  imports = [
    # ./jupyter
    ./emacs
    ./vim
  ];

  home.packages = with pkgs;
    [
      texliveMedium
    ];
}
