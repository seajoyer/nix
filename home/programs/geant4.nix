{ config, pkgs, lib, ... }:

let
  # Define a custom Geant4 build with Qt support
  geant4WithQt = pkgs.geant4.overrideAttrs (oldAttrs: {
    # Explicitly set cmake flags to ensure Qt is enabled
    cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
      "-DGEANT4_USE_QT=ON"
      "-DGEANT4_USE_OPENGL_X11=ON"
      "-DGEANT4_USE_RAYTRACER_X11=ON"
    ];

    # Add Qt dependencies to buildInputs
    buildInputs = (oldAttrs.buildInputs or []) ++ [
      pkgs.qt5.qtbase
      pkgs.qt5.qtwayland
    ];

    # Add Qt to propagated build inputs
    propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [
      pkgs.qt5.qtbase
    ];

    # Ensure the Qt wrapper hook runs
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      pkgs.qt5.wrapQtAppsHook
    ];

    # Explicitly disable dontWrapQtApps if it's set
    dontWrapQtApps = false;

    # Add a post-build hook to verify Qt was enabled
    postBuild = (oldAttrs.postBuild or "") + ''
      echo "Checking if Qt support was enabled..."
      grep -q "GEANT4_USE_QT:BOOL=ON" build/CMakeCache.txt || echo "WARNING: Qt support may not be enabled!"
    '';
  });
in
{
  # Geant4 with all dependencies for development
  home.packages = with pkgs; [
    # Use our custom Geant4 build with Qt support
    geant4WithQt

    # Physics datasets
    geant4.data.G4NDL # Neutron data
    geant4.data.G4EMLOW # Electromagnetic low energy data
    geant4.data.G4PhotonEvaporation # Photon evaporation data
    geant4.data.G4RadioactiveDecay # Radioactive decay data
    geant4.data.G4PARTICLEXS # Particle cross-section data
    geant4.data.G4PII # Photoionization data
    geant4.data.G4SAIDDATA # SAID nucleon-nucleon data
    geant4.data.G4ABLA # ABLA nuclear de-excitation model
    geant4.data.G4INCL # INCL nuclear model
    geant4.data.G4TENDL # TENDL nuclear data
    geant4.data.G4ENSDFSTATE # ENSDF nuclear states

    # Material and surface datasets
    geant4.data.G4RealSurface # Surface reflection data
    geant4.data.G4CHANNELING # Crystal channeling data

    # Additional specialized datasets
    geant4.data.G4NUDEXLIB # Nuclear data exchange library
    geant4.data.G4URRPT # Updated RRPs data

    # Required development dependencies
    expat
    cmake
    clhep
    xercesc
    zlib

    # Qt dependencies - more targeted approach
    qt5.qtbase
    qt5.qtwayland
    qt5.qttools   # For Qt Designer and other tools
    qt5.qtsvg     # SVG support
    qt5.qt3d      # 3D visualization
    qt5.qtcharts  # Charts support
    qt5.wrapQtAppsHook

    # GUI dependencies for OpenGL and X11
    libGL
    libGLU
    xorg.libX11
    xorg.libXext
    xorg.libXmu
    xorg.xorgproto
    xorg.libICE
    xorg.libSM
    xorg.xset
    xlsfonts

    # Add X11 font packages to fix the missing font issues
    xorg.fontadobe75dpi # Adobe 75dpi fonts including Courier
    xorg.fontadobe100dpi # Adobe 100dpi fonts including Courier
    xorg.fontmiscmisc # Miscellaneous X11 fonts

    # Additional font packages that might be useful
    dejavu_fonts # DejaVu font family (good general purpose fonts)
    liberation_ttf # Liberation fonts (metric-compatible with common fonts)
    freefont_ttf # GNU FreeFont
  ];

  # Create a unified setup script
  home.file.".geant4-setup.sh" = {
    text = ''
      #!/usr/bin/env bash

      # Source Geant4 setup hook
      if [ -f "${geant4WithQt}/nix-support/setup-hook" ]; then
        source "${geant4WithQt}/nix-support/setup-hook"
      fi

      # Get Geant4 version dynamically
      GEANT4_VERSION=$(${geant4WithQt}/bin/geant4-config --version)
      GEANT4_DATA_DIR="share/Geant4-$GEANT4_VERSION/data"

      # Define Geant4 data paths with dynamic paths
      # Physics datasets
      export G4NEUTRONHPDATA="${pkgs.geant4.data.G4NDL}/$GEANT4_DATA_DIR/G4NDL4.7.1"
      export G4LEDATA="${pkgs.geant4.data.G4EMLOW}/$GEANT4_DATA_DIR/G4EMLOW8.6.1"
      export G4LEVELGAMMADATA="${pkgs.geant4.data.G4PhotonEvaporation}/$GEANT4_DATA_DIR/G4PhotonEvaporation6.1"
      export G4RADIOACTIVEDATA="${pkgs.geant4.data.G4RadioactiveDecay}/$GEANT4_DATA_DIR/G4RadioactiveDecay6.1.2"
      export G4PARTICLEXSDATA="${pkgs.geant4.data.G4PARTICLEXS}/$GEANT4_DATA_DIR/G4PARTICLEXS4.1"
      export G4PIIDATA="${pkgs.geant4.data.G4PII}/$GEANT4_DATA_DIR/G4PII1.3"
      export G4SAIDXSDATA="${pkgs.geant4.data.G4SAIDDATA}/$GEANT4_DATA_DIR/G4SAIDDATA2.0"
      export G4ABLADATA="${pkgs.geant4.data.G4ABLA}/$GEANT4_DATA_DIR/G4ABLA3.3"
      export G4INCLDATA="${pkgs.geant4.data.G4INCL}/$GEANT4_DATA_DIR/G4INCL1.2"
      export G4TENDLDATA="${pkgs.geant4.data.G4TENDL}/$GEANT4_DATA_DIR/G4TENDL1.4"
      export G4ENSDFSTATEDATA="${pkgs.geant4.data.G4ENSDFSTATE}/$GEANT4_DATA_DIR/G4ENSDFSTATE3.0"

      # Material and surface datasets
      export G4REALSURFACEDATA="${pkgs.geant4.data.G4RealSurface}/$GEANT4_DATA_DIR/G4RealSurface2.2"
      export G4CHANNELING="${pkgs.geant4.data.G4CHANNELING}/$GEANT4_DATA_DIR/G4CHANNELING1.0"

      # Additional specialized datasets
      export G4NUDEXLIBDATA="${pkgs.geant4.data.G4NUDEXLIB}/$GEANT4_DATA_DIR/G4NUDEXLIB1.0"
      export G4URRPTDATA="${pkgs.geant4.data.G4URRPT}/$GEANT4_DATA_DIR/G4URRPT1.1"

      # Visualization environment variables - CRITICAL FOR QT
      # These environment variables control Geant4's UI and visualization systems
      export G4UI_USE_QT=1
      export G4UI_USE_TCSH=1
      export G4VIS_USE_OPENGLQT=1
      export G4VIS_USE_OPENGLX=1
      export G4VIS_USE_RAYTRACERX=1
      export G4UI_NONE=0            # Don't use the "none" UI
      export G4UI_BUILD_QT_SESSION=1  # Force building of Qt session
      export G4VIS_BUILD_OPENGLQT_DRIVER=1  # Force building of OpenGL Qt driver
      export G4VIS_WINDOW_SIZE="1200x800"
      export G4VIS_WINDOW_POSITION="50+50"

      # Set explicit paths for all required dependencies
      # EXPAT
      export EXPAT_INCLUDE_DIR="${pkgs.expat.dev}/include"
      export EXPAT_LIBRARY="${pkgs.expat}/lib/libexpat.so"

      # ZLIB
      export ZLIB_INCLUDE_DIR="${pkgs.zlib.dev}/include"
      export ZLIB_LIBRARY="${pkgs.zlib}/lib/libz.so"
      export ZLIB_ROOT="${pkgs.zlib.dev}"

      # CLHEP
      export CLHEP_INCLUDE_DIR="${pkgs.clhep}/include"
      export CLHEP_LIBRARY="${pkgs.clhep}/lib/libCLHEP.so"

      # XERCES-C
      export XERCESC_INCLUDE_DIR="${pkgs.xercesc}/include"
      export XERCESC_LIBRARY="${pkgs.xercesc}/lib/libxerces-c.so"

      # X11 specific variables
      export X11_X11_INCLUDE_PATH="${pkgs.xorg.libX11.dev}/include"
      export X11_X11_LIB="${pkgs.xorg.libX11}/lib/libX11.so"
      export X11_Xext_INCLUDE_PATH="${pkgs.xorg.libXext.dev}/include"
      export X11_Xext_LIB="${pkgs.xorg.libXext}/lib/libXext.so"
      export X11_Xmu_INCLUDE_PATH="${pkgs.xorg.libXmu.dev}/include"
      export X11_Xmu_LIB="${pkgs.xorg.libXmu}/lib/libXmu.so"
      export X11_ICE_INCLUDE_PATH="${pkgs.xorg.libICE.dev}/include"
      export X11_ICE_LIB="${pkgs.xorg.libICE}/lib/libICE.so"
      export X11_SM_INCLUDE_PATH="${pkgs.xorg.libSM.dev}/include"
      export X11_SM_LIB="${pkgs.xorg.libSM}/lib/libSM.so"

      # OpenGL specific variables
      export OPENGL_INCLUDE_DIR="${pkgs.libGL.dev}/include"
      export OPENGL_opengl_LIBRARY="${pkgs.libGL}/lib/libGL.so"
      export OPENGL_glx_LIBRARY="${pkgs.libGL}/lib/libGLX.so"
      export OPENGL_gl_LIBRARY="${pkgs.libGL}/lib/libGL.so"
      export OPENGL_glu_LIBRARY="${pkgs.libGLU}/lib/libGLU.so"

      # Qt5 specific variables - critical for Qt visualization
      export Qt5Core_DIR="${pkgs.qt5.qtbase.dev}/lib/cmake/Qt5Core"
      export Qt5Gui_DIR="${pkgs.qt5.qtbase.dev}/lib/cmake/Qt5Gui"
      export Qt5Widgets_DIR="${pkgs.qt5.qtbase.dev}/lib/cmake/Qt5Widgets"
      export Qt5OpenGL_DIR="${pkgs.qt5.qtbase.dev}/lib/cmake/Qt5OpenGL"

      # Ensure Qt plugins are found
      export QT_PLUGIN_PATH="${pkgs.qt5.qtbase}/lib/qt-${pkgs.qt5.qtbase.version}/plugins:$QT_PLUGIN_PATH"
      export QML2_IMPORT_PATH="${pkgs.qt5.qtbase}/lib/qt-${pkgs.qt5.qtbase.version}/qml:$QML2_IMPORT_PATH"

      # Add to CMAKE_PREFIX_PATH for dependency resolution
      export CMAKE_PREFIX_PATH="${pkgs.qt5.qtbase.dev}/lib/cmake:${pkgs.expat}:${pkgs.expat.dev}:${pkgs.clhep}:${pkgs.xercesc}:${pkgs.zlib}:${pkgs.zlib.dev}:${pkgs.xorg.libX11}:${pkgs.xorg.libX11.dev}:${pkgs.xorg.libXext}:${pkgs.xorg.libXmu}:${pkgs.qt5.qtbase}:${pkgs.libGL}:${pkgs.libGL.dev}:${pkgs.libGLU}:$CMAKE_PREFIX_PATH"

      # Ensure pkg-config can find the packages too
      export PKG_CONFIG_PATH="${pkgs.expat.dev}/lib/pkgconfig:${pkgs.zlib.dev}/lib/pkgconfig:${pkgs.clhep}/lib/pkgconfig:${pkgs.xercesc}/lib/pkgconfig:${pkgs.qt5.qtbase.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"

      # Configure X11 font path to include the Adobe fonts needed by Geant4
      # This ensures X11 applications like Geant4 can find the required fonts
      xset +fp ${pkgs.xorg.fontadobe75dpi}/lib/X11/fonts/75dpi
      xset +fp ${pkgs.xorg.fontadobe100dpi}/lib/X11/fonts/100dpi
      xset fp rehash
    '';
    executable = true;
  };

  # Create a convenient wrapper script for CMake (kept as requested)
  home.file.".local/bin/geant4-cmake" = {
    text = ''
      #!/usr/bin/env bash
      source ~/.geant4-setup.sh

      cmake \
        -DGEANT4_USE_QT=ON \
        -DGEANT4_USE_OPENGL_X11=ON \
        -DGEANT4_USE_RAYTRACER_X11=ON \
        -DEXPAT_INCLUDE_DIR="$EXPAT_INCLUDE_DIR" \
        -DEXPAT_LIBRARY="$EXPAT_LIBRARY" \
        -DZLIB_INCLUDE_DIR="$ZLIB_INCLUDE_DIR" \
        -DZLIB_LIBRARY="$ZLIB_LIBRARY" \
        -DZLIB_ROOT="$ZLIB_ROOT" \
        -DCLHEP_INCLUDE_DIR="$CLHEP_INCLUDE_DIR" \
        -DCLHEP_LIBRARY="$CLHEP_LIBRARY" \
        -DXERCESC_INCLUDE_DIR="$XERCESC_INCLUDE_DIR" \
        -DXERCESC_LIBRARY="$XERCESC_LIBRARY" \
        -DX11_X11_INCLUDE_PATH="$X11_X11_INCLUDE_PATH" \
        -DX11_X11_LIB="$X11_X11_LIB" \
        -DX11_Xext_INCLUDE_PATH="$X11_Xext_INCLUDE_PATH" \
        -DX11_Xext_LIB="$X11_Xext_LIB" \
        -DX11_Xmu_INCLUDE_PATH="$X11_Xmu_INCLUDE_PATH" \
        -DX11_Xmu_LIB="$X11_Xmu_LIB" \
        -DX11_ICE_INCLUDE_PATH="$X11_ICE_INCLUDE_PATH" \
        -DX11_ICE_LIB="$X11_ICE_LIB" \
        -DX11_SM_INCLUDE_PATH="$X11_SM_INCLUDE_PATH" \
        -DX11_SM_LIB="$X11_SM_LIB" \
        -DQt5Core_DIR="$Qt5Core_DIR" \
        -DQt5Gui_DIR="$Qt5Gui_DIR" \
        -DQt5Widgets_DIR="$Qt5Widgets_DIR" \
        -DQt5OpenGL_DIR="$Qt5OpenGL_DIR" \
        -DOPENGL_INCLUDE_DIR="$OPENGL_INCLUDE_DIR" \
        -DOPENGL_opengl_LIBRARY="$OPENGL_opengl_LIBRARY" \
        -DOPENGL_glx_LIBRARY="$OPENGL_glx_LIBRARY" \
        -DOPENGL_gl_LIBRARY="$OPENGL_gl_LIBRARY" \
        -DOPENGL_glu_LIBRARY="$OPENGL_glu_LIBRARY" \
        -DCMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH" \
        "$@"
    '';
    executable = true;
  };

  # Updated wrapper script for running Geant4 applications with proper Qt/Wayland setup
  home.file.".local/bin/geant4-run" = {
    text = ''
      #!/usr/bin/env bash

      # Source the Geant4 setup script to ensure proper environment
      source ~/.geant4-setup.sh

      # Wayland/Qt compatibility settings - these are crucial for Qt in Wayland
      # Choose the appropriate platform plugin based on environment
      if [ -n "$WAYLAND_DISPLAY" ]; then
        # When running in Wayland
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
      elif [ -n "$DISPLAY" ]; then
        # Fallback to xcb when in X11
        export QT_QPA_PLATFORM=xcb
      fi

      # Needed for Qt visualization in Geant4
      export G4UI_USE_QT=1
      export G4VIS_USE_OPENGLQT=1
      export G4UI_BUILD_QT_SESSION=1

      # Force Geant4 to use Qt
      export G4UI_USE_EXECUTIVE=0
      export G4UI_USE_WIN32=0
      export G4UI_USE_XM=0
      export G4UI_NONE=0

      # Extra Qt environment settings to help Geant4 find Qt components
      export QT_DEBUG_PLUGINS=0  # Set to 1 for debugging Qt plugin loading
      export QT_QPA_PLATFORMTHEME=qt5ct

      # Debug output
      if [ "$1" = "--debug" ]; then
        shift
        export QT_DEBUG_PLUGINS=1
        echo "Running in debug mode with QT_DEBUG_PLUGINS=1"
        echo "Geant4 variables:"
        echo "G4UI_USE_QT=$G4UI_USE_QT"
        echo "G4VIS_USE_OPENGLQT=$G4VIS_USE_OPENGLQT"
        echo "QT_QPA_PLATFORM=$QT_QPA_PLATFORM"
      fi

      # Execute the provided command with all arguments
      exec "$@"
    '';
    executable = true;
  };

  # Adding a debug script to help troubleshoot Qt issues
  home.file.".local/bin/geant4-qt-debug" = {
    text = ''
      #!/usr/bin/env bash

      # This script helps diagnose Qt issues with Geant4
      source ~/.geant4-setup.sh

      echo "======================"
      echo "Geant4 Qt Debug Helper"
      echo "======================"

      # Check if Geant4 was built with Qt support
      echo "Checking Geant4 configuration..."
      FEATURES=$(${geant4WithQt}/bin/geant4-config --feature-flags)

      if echo "$FEATURES" | grep -q "qt"; then
        echo "✅ Geant4 was built with Qt support"
      else
        echo "❌ Geant4 was NOT built with Qt support!"
        echo "   You need to ensure your Geant4 override has enableQt=true"
        exit 1
      fi

      # Check for Qt libraries
      echo "Checking Qt libraries..."
      QT_LIB_COUNT=$(find ${pkgs.qt5.qtbase}/lib -name "libQt5*.so*" | wc -l)
      echo "Found $QT_LIB_COUNT Qt libraries"

      # Check Qt plugin path
      echo "Checking QT_PLUGIN_PATH..."
      if [ -n "$QT_PLUGIN_PATH" ]; then
        echo "✅ QT_PLUGIN_PATH is set to: $QT_PLUGIN_PATH"

        # Check if the paths exist
        for path in $(echo $QT_PLUGIN_PATH | tr ':' ' '); do
          if [ -d "$path" ]; then
            echo "   Path exists: $path"
            echo "   Contains $(find "$path" -type f | wc -l) files"
          else
            echo "❌ Path does not exist: $path"
          fi
        done
      else
        echo "❌ QT_PLUGIN_PATH is not set!"
      fi

      # Try to find platformthemes in the Qt installation
      echo "Looking for Qt platform plugins..."
      PLATFORM_PLUGINS=$(find ${pkgs.qt5.qtbase}/lib -path "*/plugins/platforms" -type d)
      if [ -n "$PLATFORM_PLUGINS" ]; then
        echo "✅ Found platform plugins at: $PLATFORM_PLUGINS"
        echo "   Available platforms:"
        find $PLATFORM_PLUGINS -type f -name "*.so" | sort
      else
        echo "❌ Could not find Qt platform plugins!"
      fi

      echo "======================"
      echo "Running a test command with debug output..."

      # Create a temporary macro file
      TEST_MACRO=$(mktemp /tmp/geant4_test_XXXXX.mac)
      echo "/gui/system" > $TEST_MACRO
      echo "/gui/listUI" >> $TEST_MACRO

      echo "Executing a simple Geant4 command to check UI systems..."

      # Look for a simple Geant4 example to run
      EXAMPLES=$(find ${geant4WithQt}/share/Geant4-*/examples -name "*.cc" | grep -v vis | head -1)
      if [ -n "$EXAMPLES" ]; then
        EXAMPLE_DIR=$(dirname $EXAMPLES)
        BUILD_DIR=$(find $EXAMPLE_DIR -name "build" -type d | head -1)

        if [ -n "$BUILD_DIR" ]; then
          EXAMPLE_BIN=$(find $BUILD_DIR -type f -executable | head -1)
          if [ -n "$EXAMPLE_BIN" ]; then
            echo "Using example: $EXAMPLE_BIN"
            QT_DEBUG_PLUGINS=1 G4UI_USE_QT=1 $EXAMPLE_BIN -m $TEST_MACRO
          else
            echo "❌ No executable found in $BUILD_DIR"
          fi
        else
          echo "❌ No build directory found in $EXAMPLE_DIR"
        fi
      else
        echo "❌ No Geant4 examples found to run a test"
        echo "You can try manually running: QT_DEBUG_PLUGINS=1 your_geant4_app"
      fi

      echo "======================"
      echo "Suggestions:"
      echo "1. Run 'geant4-run --debug your_app' to see detailed Qt plugin loading"
      echo "2. Check if the Qt platform plugin for your environment (xcb/wayland) exists"
      echo "3. Verify that Geant4 was built with Qt5 and not Qt6"
      echo "4. Make sure your application builds with Qt support enabled"

      # Cleanup
      rm -f $TEST_MACRO
    '';
    executable = true;
  };

  # Make sure ~/.local/bin is in PATH
  home.sessionPath = [ "$HOME/.local/bin" ];

  # Set essential environment variables to ensure Geant4 can find data
  home.sessionVariables = {
    # Use a dynamic approach via the setup script
    GEANT4_SETUP_SCRIPT = "$HOME/.geant4-setup.sh";
  };

  # Add a home-manager fonts configuration that gets properly activated for X applications
  fonts.fontconfig.enable = true;
}
