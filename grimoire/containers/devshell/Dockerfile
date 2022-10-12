FROM nixos/nix
WORKDIR /build/

RUN nix-channel --update
RUN nix-build -A pythonFull '<nixpkgs>'

ADD https://github.com/toasterrepairman/boostrap /grimoire/containers/devshell/flake.nix

RUN nix develop .