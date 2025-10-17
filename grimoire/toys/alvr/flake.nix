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

        # Use modern CUDA packages instead of deprecated cudatoolkit
        cuda = pkgs.cudaPackages;

        alvr = pkgs.rustPlatform.buildRustPackage rec {
          pname = "alvr";
          version = "20.14.1";

          src = pkgs.fetchFromGitHub {
            owner = "alvr-org";
            repo = "ALVR";
            tag = "v${version}";
            fetchSubmodules = true;
            hash = "sha256-9fckUhUPAbcmbqOdUO8RlwuK8/nf1fc7XQBrAu5YaR4=";
          };

          useFetchCargoVendor = true;
          cargoHash = "sha256-OTCMWrlwnfpUhm6ssOE133e/3DaQFnOU+NunN2c1N+g=";

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
            CUDA_PATH = "${cuda.cudatoolkit}";
            CUDA_ROOT = "${cuda.cudatoolkit}";
          };

          RUSTFLAGS = map (a: "-C link-arg=${a}") [
            "-Wl,--push-state,--no-as-needed"
            "-lEGL"
            "-lwayland-client"
            "-lxkbcommon"
            "-Wl,--pop-state"
          ];

          nativeBuildInputs = with pkgs; [
            rust-cbindgen
            pkg-config
            rustPlatform.bindgenHook
            autoAddDriverRunpath
            makeWrapper  # For wrapping binaries with CUDA paths
            # CUDA build tools
            cuda.cudatoolkit
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

            # Standard x264
            x264

            # CUDA libraries for runtime
            cuda.cudatoolkit
            cuda.cuda_cudart
            cuda.cuda_nvcc

            # Additional media libraries with hardware acceleration
            libva # VAAPI support
            intel-media-driver # Intel GPU support (for hybrid systems)
          ];

          # Critical: Add CUDA libraries to rpath
          postFixup = ''
            for bin in $out/bin/* $out/libexec/*; do
              if [ -f "$bin" ] && [ -x "$bin" ]; then
                echo "Wrapping $bin with CUDA libraries"
                wrapProgram "$bin" \
                  --prefix LD_LIBRARY_PATH : "${pkgs.lib.makeLibraryPath [
                    cuda.cudatoolkit
                    cuda.cuda_cudart
                    pkgs.libglvnd
                    pkgs.vulkan-loader
                    pkgs.libva
                  ]}" \
                  --set CUDA_PATH "${cuda.cudatoolkit}" \
                  --prefix PATH : "${cuda.cudatoolkit}/bin"
              fi
            done

            # Wrap shared libraries if needed
            for lib in $out/lib/*.so $out/lib64/*.so; do
              if [ -f "$lib" ]; then
                patchelf --set-rpath "$(patchelf --print-rpath $lib):${pkgs.lib.makeLibraryPath [
                  cuda.cudatoolkit
                  cuda.cuda_cudart
                  pkgs.libglvnd
                ]}" "$lib" || true
              fi
            done
          '';

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
            cuda.cudatoolkit
            vulkan-tools
            mesa-demos
          ];

          shellHook = ''
            echo "ALVR development environment with CUDA support"
            echo "CUDA Path: ${cuda.cudatoolkit}"
            export CUDA_PATH="${cuda.cudatoolkit}"
            export LD_LIBRARY_PATH="${cuda.cudatoolkit}/lib:${pkgs.lib.makeLibraryPath [ cuda.cudatoolkit ]}:$LD_LIBRARY_PATH"
          '';
        };

        # Apps for easy running
        apps.default = flake-utils.lib.mkApp {
          drv = alvr;
          name = "alvr_dashboard";
        };

        apps.alvr = flake-utils.lib.mkApp {
          drv = alvr;
          name = "alvr_dashboard";
        };
      });
}
