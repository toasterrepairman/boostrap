{
  description = "ALVR - Stream VR games from your PC to your headset via Wi-Fi";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            allowUnfree = true; # Required for CUDA packages
            cudaSupport = true;
          };
        };

        alvr = pkgs.rustPlatform.buildRustPackage rec {
          pname = "alvr";
          version = "20.13.0";

          src = pkgs.fetchFromGitHub {
            owner = "alvr-org";
            repo = "ALVR";
            tag = "v${version}";
            fetchSubmodules = true;
            hash = "sha256-h7/fuuolxbNkjUbqXZ7NTb1AEaDMFaGv/S05faO2HIc=";
          };

          useFetchCargoVendor = true;
          cargoHash = "sha256-A0ADPMhsREH1C/xpSxW4W2u4ziDrKRrQyY5kBDn//gQ=";

          patches = [
            (pkgs.replaceVars ./fix-finding-libs.patch {
              ffmpeg = pkgs.lib.getDev pkgs.ffmpeg;
              x264 = pkgs.lib.getDev pkgs.x264;
            })
          ];

          env = {
            NIX_CFLAGS_COMPILE = toString [
              "-lbrotlicommon"
              "-lbrotlidec"
              "-lcrypto"
              "-lpng"
              "-lssl"
            ];
            # CUDA environment variables
            CUDA_PATH = "${pkgs.cudatoolkit}";
            CUDA_ROOT = "${pkgs.cudatoolkit}";
          };

          RUSTFLAGS = map (a: "-C link-arg=${a}") ([
            "-Wl,--push-state,--no-as-needed"
            "-lEGL"
            "-lwayland-client"
            "-lxkbcommon"
            "-Wl,--pop-state"
          ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
            # CUDA runtime linking
            "-L${pkgs.cudatoolkit}/lib"
            "-L${pkgs.cudatoolkit}/lib64"
            "-lcuda"
            "-lcudart"
            "-lnvidia-encode"
            "-lnvidia-ml"
          ]);

          nativeBuildInputs = with pkgs; [
            rust-cbindgen
            pkg-config
            rustPlatform.bindgenHook
            autoAddDriverRunpath
            # CUDA build tools
            cudatoolkit
          ];

          buildInputs = with pkgs; [
            # Original dependencies
            alsa-lib
            brotli
            bzip2
            celt
            jack2
            lame
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
            libdrm
            libglvnd
            libogg
            libpng
            libtheora
            libunwind
            libva
            libvdpau
            libxkbcommon
            openssl
            openvr
            pipewire
            soxr
            vulkan-headers
            vulkan-loader
            wayland
            xvidcore

            # Enhanced ffmpeg with CUDA support
            ffmpeg-full

            # Standard x264 (CUDA acceleration handled by ffmpeg)
            x264

            # CUDA libraries for hardware acceleration
            cudatoolkit
            cudaPackages.libcublas
            cudaPackages.libcufft
            cudaPackages.libcurand
            cudaPackages.libcusolver
            cudaPackages.libcusparse
            cudaPackages.cudnn

            # Nvidia Video Codec SDK (if available)
            # Note: This might not be available in nixpkgs, but NVENC/NVDEC
            # support should be provided through the CUDA-enabled ffmpeg

            # Additional media libraries with hardware acceleration
            libva # VAAPI support
            intel-media-driver # Intel GPU support (for hybrid systems)
          ];

          postBuild = ''
            # Build SteamVR driver ("streamer")
            cargo xtask build-streamer --release
          '';

          postInstall = ''
            install -Dm755 ${src}/alvr/xtask/resources/alvr.desktop $out/share/applications/alvr.desktop
            install -Dm644 ${src}/resources/ALVR-Icon.svg $out/share/icons/hicolor/scalable/apps/alvr.svg

            # Install SteamVR driver
            mkdir -p $out/{libexec,lib/alvr,share}
            cp -r ./build/alvr_streamer_linux/lib64/. $out/lib
            cp -r ./build/alvr_streamer_linux/libexec/. $out/libexec
            cp -r ./build/alvr_streamer_linux/share/. $out/share
            ln -s $out/lib $out/lib64

            # Ensure CUDA libraries are available at runtime
            mkdir -p $out/lib/cuda
            ln -sf ${pkgs.cudatoolkit}/lib/* $out/lib/cuda/

            # Create wrapper script to set up CUDA environment
            mkdir -p $out/bin
            cat > $out/bin/alvr_dashboard_wrapped << 'EOF'
            #!/usr/bin/env bash
            export CUDA_PATH="${pkgs.cudatoolkit}"
            export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:${pkgs.cudatoolkit}/lib64:$LD_LIBRARY_PATH"
            export PATH="${pkgs.cudatoolkit}/bin:$PATH"
            exec $out/bin/alvr_dashboard "$@"
            EOF
            chmod +x $out/bin/alvr_dashboard_wrapped
          '';

          # Add runtime dependencies for CUDA
          preFixup = ''
            patchelf --add-rpath ${pkgs.cudatoolkit}/lib $out/bin/* || true
            patchelf --add-rpath ${pkgs.cudatoolkit}/lib64 $out/bin/* || true
          '';

          passthru.updateScript = pkgs.nix-update-script { };

          meta = with pkgs.lib; {
            description = "Stream VR games from your PC to your headset via Wi-Fi (with CUDA support)";
            homepage = "https://github.com/alvr-org/ALVR/";
            changelog = "https://github.com/alvr-org/ALVR/releases/tag/v${version}";
            license = licenses.mit;
            mainProgram = "alvr_dashboard";
            maintainers = with maintainers; [
              luNeder
              jopejoe1
            ];
            platforms = platforms.linux;
            # Note about CUDA requirements
            longDescription = ''
              ALVR allows you to stream VR games from your PC to your headset via Wi-Fi.
              This build includes CUDA support for Nvidia hardware acceleration.
              Requires Nvidia drivers and CUDA-capable GPU for hardware encoding/decoding.
            '';
          };
        };
      in
      {
        packages.default = alvr;
        packages.alvr = alvr;

        # Development shell with CUDA tools
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            cudatoolkit
            nvidia-docker
            vulkan-tools
            mesa-demos
          ];

          shellHook = ''
            echo "ALVR development environment with CUDA support"
            echo "CUDA Path: ${pkgs.cudatoolkit}"
            export CUDA_PATH="${pkgs.cudatoolkit}"
            export LD_LIBRARY_PATH="${pkgs.cudatoolkit}/lib:${pkgs.cudatoolkit}/lib64:$LD_LIBRARY_PATH"
          '';
        };

        # Apps for easy running
        apps.default = flake-utils.lib.mkApp {
          drv = alvr;
          name = "alvr_dashboard_wrapped";
        };

        apps.alvr = flake-utils.lib.mkApp {
          drv = alvr;
          name = "alvr_dashboard_wrapped";
        };
      });
}
