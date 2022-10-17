FROM nixos/nix
WORKDIR /build

RUN nix-channel --update
RUN nix-build -A pythonFull '<nixpkgs>'

ADD https://github.com/toasterrepairman/boostrap.git \
    /grimoire/containers/devshell/flake.nix \ 
    /build/

RUN nix develop . --extra-experimental-features nix-command
