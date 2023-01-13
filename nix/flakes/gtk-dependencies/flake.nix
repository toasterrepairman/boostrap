{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
    utils.lib.eachDefaultSystem
      (system:
        let
          name = "gtk-dependencies";
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {
          packages.${name} = pkgs.callPackage ./default.nix {
            inherit (inputs);
          };

          # `nix build`
          defaultPackage = packages.${name};

          # `nix run`
          apps.${name} = utils.lib.mkApp {
            inherit name;
            drv = packages.${name};
          };
          defaultApp = packages.${name};

          # `nix develop`
          devShells = {
            default = pkgs.mkShell {
              nativeBuildInputs =
                with pkgs; [
                  rustc
                  cargo
                  cairo
                  gdk-pixbuf
                  gobject-introspection
                  graphene
                  gtk3.dev
                  gtksourceview5
                  libadwaita
                  openssl
                  pandoc
                  pango
                  pkgconfig
                  appstream-glib
                  polkit
                  gettext
                  desktop-file-utils
                  meson
                  ninja
                  git
                  wrapGAppsHook4
                ];
            };
          };
        }
      );
}
