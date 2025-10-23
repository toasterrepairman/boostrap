{
  description = "Deadlock Mod Manager - A mod manager for Valve's Deadlock game";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = {
          default = self.packages.${system}.deadlock-mod-manager;

          deadlock-mod-manager = pkgs.rustPlatform.buildRustPackage rec {
            pname = "deadlock-mod-manager";
            version = "0.9.2";

            src = pkgs.fetchFromGitHub {
              owner = "deadlock-mod-manager";
              repo = "deadlock-mod-manager";
              rev = "v${version}";
              hash = "sha256-meCwpdnRYwNiOB8QzdhDC24CtRiMClimCDlv0EvHHgI=";
            };

            sourceRoot = "${src.name}";

            buildInputs = with pkgs; [
              openssl
              glib.dev
              gtk3.dev
              webkitgtk_4_1.dev
              libsoup_3
              fontconfig
            ];

            nativeBuildInputs = with pkgs; [
              cargo-tauri.hook
              nodejs_22
              pnpm_10.configHook
              pkg-config
              wrapGAppsHook4
              makeWrapper
            ];

            pnpmDeps = pkgs.pnpm_10.fetchDeps {
              inherit pname version src;
              fetcherVersion = 2;
              hash = "sha256-U02RKSWHqxVu4JoVkPUrQ5F3/Cz9BHP2s/fkbE9/880=";
            };

            cargoRoot = "apps/desktop";

            cargoHash = "sha256-cLdsR9ZCkUKZQDAxsvZpau7c9LxeLt4kUI21ObiY7dA=";

            # Disable bundle signing - we don't have the signing keys
            # Setting these to empty/null doesn't work, so we unset them
            preBuild = ''
              cd apps/desktop
              unset TAURI_SIGNING_PRIVATE_KEY
              unset TAURI_SIGNING_PUBLIC_KEY
              unset TAURI_SIGNING_PRIVATE_KEY_PASSWORD
            '';

            # Fix fontconfig issues on some systems
            preFixup = ''
              gappsWrapperArgs+=(
                --set FONTCONFIG_FILE "${pkgs.fontconfig.out}/etc/fonts/fonts.conf"
              )
            '';

            meta = with pkgs.lib; {
              description = "A mod manager for the Valve game Deadlock";
              homepage = "https://deadlockmods.app";
              license = licenses.gpl3Only;
              maintainers = with maintainers; [ ];
              mainProgram = "deadlock-mod-manager";
              platforms = platforms.linux;
            };
          };
        };

        # Development shell
        devShells.default = pkgs.mkShell {
          inputsFrom = [ self.packages.${system}.deadlock-mod-manager ];

          packages = with pkgs; [
            rust-analyzer
            clippy
            rustfmt
          ];

          shellHook = ''
            echo "Deadlock Mod Manager development environment"
            echo "Run 'cd apps/desktop && pnpm install && pnpm tauri dev' to start development"
          '';
        };

        # App for `nix run`
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.deadlock-mod-manager}/bin/deadlock-mod-manager";
        };
      }
    );
}
