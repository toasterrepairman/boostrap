{
  description = "Head tracking software with ONNX support";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        opentrack = pkgs.qt5.mkDerivation rec {
          pname = "opentrack";
          version = "2024.1.1";

          src = pkgs.fetchFromGitHub {
            owner = "opentrack";
            repo = "opentrack";
            rev = "6aae766520d7cbf493fce6b6f1595f8c96b71fbe";
            hash = "sha256-xN4Z1Cpmj8ktqWCQYPZTfqznHrYe28qlKkPoQxHRPJ8=";
          };

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
            ninja
            cmake
            copyDesktopItems
            qt5.wrapQtAppsHook
            onnxruntime.dev
          ];

          env.NIX_CFLAGS_COMPILE = "-Wall -Wextra -Wpedantic -ffast-math -O3";
          dontWrapQtApps = true;

          buildInputs = with pkgs; [
            qt5.qtbase
            qt5.qttools
            opencv4
            procps
            eigen
            xorg.libXdmcp
            libevdev
            onnxruntime.dev
          ] ++ lib.optionals stdenv.targetPlatform.isx86_64 [ wineWowPackages.stable ];

          nativeCheckInputs = [
            pkgs.onnxruntime
          ];

          cmakeFlags = [
            "-GNinja"
            "-DCMAKE_BUILD_TYPE=Release"
            # Onnxruntime configuration
            "-DONNXRuntime_DIR=${pkgs.onnxruntime}/lib/cmake/onnxruntime/"
            # "-DONNXRuntime_INCLUDE_DIR=${pkgs.onnxruntime}/include/"
          ] ++ pkgs.lib.optionals pkgs.stdenv.targetPlatform.isx86_64 [ "-DSDK_WINE=ON" ];

          postInstall = ''
            mkdir -p $out/share/applications
            cat > $out/share/applications/opentrack.desktop << EOF
            [Desktop Entry]
            Name=opentrack
            GenericName=Head tracking software
            Exec=opentrack
            Icon=$out/share/pixmaps/opentrack.png
            Terminal=false
            Type=Application
            Categories=Utility;
            EOF

            mkdir -p $out/share/pixmaps
            cp $src/gui/images/opentrack.png $out/share/pixmaps/
            wrapQtApp $out/bin/opentrack
          '';

          meta = with pkgs.lib; {
            homepage = "https://github.com/opentrack/opentrack";
            description = "Head tracking software with ONNX support";
            mainProgram = "PROTON_VERB='runinprefix' opentrack";
            changelog = "https://github.com/opentrack/opentrack/releases/tag/opentrack-${version}";
            license = licenses.isc;
            platforms = platforms.linux;
          };
        };
      in
      {
        packages = {
          default = opentrack;
          opentrack = opentrack;
        };
      }
    );
}
