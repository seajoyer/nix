{pkgs, ...}:

{
  home.packages = with pkgs; [
    hyprpolkitagent
  ];
}
