{ pkgs, ... }:

{
  imports = [
    ./emacs
    ./vim
  ];

  home.packages = with pkgs; [
    clang-tools

    direnv
    nssTools
    mkcert

    jdk
    libgcc
    cmake

    gnumake
    sfml

    texliveFull
    texlab

    fira-code
    roboto
    symbola

    nil
    libxml2
    sqlfluff
    sql-formatter

    (python3.withPackages (
      ps: with ps; [
        distro
        notebook
        numpy
        tabulate
        matplotlib
        seaborn
        scikit-learn
        pandas
        scipy
        lxml
        # torch-bin
        # torchvision-bin
      ]
    ))

    devenv
    libtool
    vips
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.sqls = {
    enable = true;

    settings = {
      lowercaseKeywords = false;
      connections = [
        {
          alias = "local-pg";
          driver = "postgresql";
          dataSourceName = "host=127.0.0.1 port=5432 user=dmitry dbname=project sslmode=disable";
        }
      ];
    };
  };
}
