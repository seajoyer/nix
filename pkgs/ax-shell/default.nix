{ pkgs, lib, buildGoModule, fetchFromGitHub, python3Packages, ... }:

let
  # Define fabric-git Python package
  fabric-git = python3Packages.buildPythonPackage rec {
    pname = "fabric";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "Fabric-Development";
      repo = "fabric";
      rev = "main";
      sha256 = "sha256-zQFPTsk36R3nGyeJM9Zkh5uEJVkee4b51nWy513EkZU=";
    };

    # Add dependencies for fabric
    propagatedBuildInputs = with python3Packages; [ pygobject3 loguru ];

    # Ensure GI typelib path is available
    nativeBuildInputs = with pkgs; [ gobject-introspection wrapGAppsHook ];
  };

  # Define fabric-cli package
  fabric-cli = buildGoModule rec {
    pname = "fabric-cli";
    version = "1.0";

    src = fetchFromGitHub {
      owner = "Fabric-Development";
      repo = "fabric-cli";
      rev = "main";
      sha256 = "sha256-NatSzI0vbUxwvrUQnTwKUan0mZYJpH6oyCRaEr0JCB0=";
    };

    goPackagePath = "github.com/Fabric-Development/fabric-cli";

    vendorHash = "sha256-3ToIL4MmpMBbN8wTaV3UxMbOAcZY8odqJyWpQ7jkXOc=";

    nativeBuildInputs = with pkgs; [ meson ninja pkg-config git ];
    buildInputs = with pkgs; [ glib ];

    preBuild = ''
      # No need for any GOFLAGS or GOCACHE hacks: buildGoModule already
      # set GOFLAGS="-mod=vendor" and wired up GOCACHE/GOPATH for you.
    '';

    configurePhase = ''
      meson setup --buildtype=release --prefix=$out build
    '';

    buildPhase = ''
      meson compile -C build
    '';

    installPhase = ''
      meson install -C build
    '';

    meta = with lib; {
      description = "Command line interface for Fabric";
      homepage = "https://github.com/Fabric-Development/fabric-cli";
      license = licenses.mit;
      maintainers = [ ];
      platforms = platforms.linux;
    };
  };

  # Define zed-sans-font
  zed-sans-font = pkgs.stdenv.mkDerivation {
    name = "zed-sans-font-1.2.0";
    src = pkgs.fetchurl {
      url =
        "https://github.com/zed-industries/zed-fonts/releases/download/1.2.0/zed-sans-1.2.0.zip";
      sha256 = "sha256-64YcNcbxY5pnR5P3ETWxNw/+/JvW5ppf9f/6JlnxUME=";
    };
    nativeBuildInputs = [ pkgs.unzip ];
    unpackPhase = ''
      runHook preUnpack
      unzip $src -d source
      runHook postUnpack
    '';
    sourceRoot = "source";
    installPhase = ''
      mkdir -p $out/share/fonts/zed-sans
      cp -r . $out/share/fonts/zed-sans
    '';
  };

  # Define gray package
  gray = pkgs.stdenv.mkDerivation rec {
    pname = "gray";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "Fabric-Development";
      repo = "gray";
      rev = "main";
      sha256 = "sha256-s9v9fkp+XrKqY81Z7ezxMikwcL4HHS3KvEwrrudJutw=";
    };
    nativeBuildInputs = with pkgs; [
      gobject-introspection
      meson
      pkg-config
      ninja
      vala
    ];
    buildInputs = with pkgs; [ glib libdbusmenu-gtk3 gtk3 ];
    outputs = [ "out" "dev" ];
  };

  ax-shell = pkgs.stdenv.mkDerivation rec {
    pname = "ax-shell";
    version = "1.0";
    src = fetchFromGitHub {
      owner = "Axenide";
      repo = "Ax-Shell";
      rev = "main";
      sha256 = "sha256-Mo8bWj9yHhfkA4NtDTNMK0dN9UOh4ak/G2oang+fUA0=";
    };

    nativeBuildInputs = with pkgs; [
      makeWrapper
      wrapGAppsHook
      gobject-introspection
    ];

    buildInputs = with pkgs; [
      gtk-layer-shell
      brightnessctl
      cava
      cliphist
      imagemagick
      libnotify
      noto-fonts-emoji
      nvtopPackages.full
      playerctl
      swappy
      swww
      tesseract5
      tmux
      unzip
      wl-clipboard
      python3
      python3Packages.loguru
      python3Packages.numpy
      python3Packages.pillow
      python3Packages.psutil
      python3Packages.requests
      python3Packages.toml
      python3Packages.watchdog
      python3Packages.ijson
      python3Packages.setproctitle
      python3Packages.pygobject3
      gnome-bluetooth
      gtk3
      glib
      gdk-pixbuf
      pango
      cairo
      at-spi2-core
      harfbuzz
      zed-sans-font
      hypridle
      hyprlock
      hyprpicker
      gray
      fabric-cli
      gobject-introspection
      libdbusmenu-gtk3
      networkmanager
      matugen
      cinnamon-desktop
    ];

    # Add postPatch phase to fix the config file path
    postPatch = ''
      ls
      substituteInPlace config/data.py \
        --replace "CONFIG_FILE = get_relative_path('../config/config.json')" \
                  "CONFIG_FILE = os.path.expanduser('~/.config/Ax-Shell/config/config.json')"
      substituteInPlace modules/cavalcade.py \
        --replace 'with open(get_relative_path("../styles/colors.css"), "r") as f:' \
                  'with open("~/.config/Ax-Shell/styles/colors.css", "r") as f:'
    '';

    installPhase = ''
            mkdir -p $out/bin $out/share/ax-shell
            cp -r . $out/share/ax-shell
            mkdir -p $out/share/fonts/tabler-icons
            cp -r $out/share/ax-shell/assets/fonts/* $out/share/fonts/tabler-icons

            # Create wrapper scripts that handle setup and then run the application
            cat > $out/bin/ax-shell-config << 'EOF'
      #!/bin/bash
      # Setup function
      setup_ax_shell() {
          # Ensure the Ax-Shell config directory exists
          mkdir -p "$HOME/.config/Ax-Shell"

          # Copy config directory if it doesn't exist or is older than the package
          if [ ! -d "$HOME/.config/Ax-Shell/config" ] || [ "@out@/share/ax-shell/config" -nt "$HOME/.config/Ax-Shell/config" ]; then
              echo "Setting up Ax-Shell configuration..."
              cp -r "@out@/share/ax-shell/config" "$HOME/.config/Ax-Shell/"
              chmod -R u+w "$HOME/.config/Ax-Shell/config"
          fi

          # Copy assets directory if it doesn't exist or is older than the package
          if [ ! -d "$HOME/.config/Ax-Shell/assets" ] || [ "@out@/share/ax-shell/assets" -nt "$HOME/.config/Ax-Shell/assets" ]; then
              echo "Setting up Ax-Shell assets..."
              cp -r "@out@/share/ax-shell/assets" "$HOME/.config/Ax-Shell/"
              chmod -R u+w "$HOME/.config/Ax-Shell/assets"
          fi

          # Copy styles directory if it exists and doesn't exist in user config or is older
          if [ -d "@out@/share/ax-shell/styles" ] && ([ ! -d "$HOME/.config/Ax-Shell/styles" ] || [ "@out@/share/ax-shell/styles" -nt "$HOME/.config/Ax-Shell/styles" ]); then
              echo "Setting up Ax-Shell styles..."
              cp -r "@out@/share/ax-shell/styles" "$HOME/.config/Ax-Shell/"
              chmod -R u+w "$HOME/.config/Ax-Shell/styles"
          fi
      }

      # Run setup
      setup_ax_shell

      # Set environment variables
      export PYTHONPATH="@pythonPath@:$PYTHONPATH"
      export GI_TYPELIB_PATH="@giTypelibPath@:$GI_TYPELIB_PATH"

      # Run the application
      exec "@python@" "@out@/share/ax-shell/config/config.py" "$@"
      EOF

            cat > $out/bin/ax-shell << 'EOF'
      #!/bin/bash
      # Setup function
      setup_ax_shell() {
          # Ensure the Ax-Shell config directory exists
          mkdir -p "$HOME/.config/Ax-Shell"

          # Copy config directory if it doesn't exist or is older than the package
          if [ ! -d "$HOME/.config/Ax-Shell/config" ] || [ "@out@/share/ax-shell/config" -nt "$HOME/.config/Ax-Shell/config" ]; then
              echo "Setting up Ax-Shell configuration..."
              cp -r "@out@/share/ax-shell/config" "$HOME/.config/Ax-Shell/"
              chmod -R u+w "$HOME/.config/Ax-Shell/config"
          fi

          # Copy assets directory if it doesn't exist or is older than the package
          if [ ! -d "$HOME/.config/Ax-Shell/assets" ] || [ "@out@/share/ax-shell/assets" -nt "$HOME/.config/Ax-Shell/assets" ]; then
              echo "Setting up Ax-Shell assets..."
              cp -r "@out@/share/ax-shell/assets" "$HOME/.config/Ax-Shell/"
              chmod -R u+w "$HOME/.config/Ax-Shell/assets"
          fi

          # Copy styles directory if it exists and doesn't exist in user config or is older
          if [ -d "@out@/share/ax-shell/styles" ] && ([ ! -d "$HOME/.config/Ax-Shell/styles" ] || [ "@out@/share/ax-shell/styles" -nt "$HOME/.config/Ax-Shell/styles" ]); then
              echo "Setting up Ax-Shell styles..."
              cp -r "@out@/share/ax-shell/styles" "$HOME/.config/Ax-Shell/"
              chmod -R u+w "$HOME/.config/Ax-Shell/styles"
          fi
      }

      # Run setup
      setup_ax_shell

      # Set environment variables
      export PYTHONPATH="@pythonPath@:$PYTHONPATH"
      export GI_TYPELIB_PATH="@giTypelibPath@:$GI_TYPELIB_PATH"

      # Run the application
      exec "@python@" "@out@/share/ax-shell/main.py" "$@"
      EOF

            # Make the scripts executable
            chmod +x $out/bin/ax-shell-config $out/bin/ax-shell

            # Substitute the placeholders
            substituteInPlace $out/bin/ax-shell-config \
              --replace "@out@" "$out" \
              --replace "@python@" "${pkgs.python3}/bin/python" \
              --replace "@pythonPath@" "${
                pkgs.python3Packages.makePythonPath [
                  python3Packages.loguru
                  python3Packages.numpy
                  python3Packages.pillow
                  python3Packages.psutil
                  python3Packages.requests
                  python3Packages.toml
                  python3Packages.watchdog
                  python3Packages.ijson
                  python3Packages.setproctitle
                  python3Packages.pygobject3
                  fabric-git
                ]
              }" \
              --replace "@giTypelibPath@" "${pkgs.cinnamon-desktop}/lib/girepository-1.0:${pkgs.gtk3}/lib/girepository-1.0:${pkgs.glib}/lib/girepository-1.0:${pkgs.libdbusmenu-gtk3}/lib/girepository-1.0"

            substituteInPlace $out/bin/ax-shell \
              --replace "@out@" "$out" \
              --replace "@python@" "${pkgs.python3}/bin/python" \
              --replace "@pythonPath@" "${
                pkgs.python3Packages.makePythonPath [
                  python3Packages.loguru
                  python3Packages.numpy
                  python3Packages.pillow
                  python3Packages.psutil
                  python3Packages.requests
                  python3Packages.toml
                  python3Packages.watchdog
                  python3Packages.ijson
                  python3Packages.setproctitle
                  python3Packages.pygobject3
                  fabric-git
                ]
              }" \
              --replace "@giTypelibPath@" "${pkgs.cinnamon-desktop}/lib/girepository-1.0:${pkgs.gtk3}/lib/girepository-1.0:${pkgs.glib}/lib/girepository-1.0:${pkgs.libdbusmenu-gtk3}/lib/girepository-1.0"
    '';

    meta = with lib; {
      description = "A custom shell environment for Hyprland";
      homepage = "https://github.com/Axenide/Ax-Shell";
      license = licenses.mit;
      maintainers = [ ];
      platforms = platforms.linux;
    };
  };
in ax-shell
