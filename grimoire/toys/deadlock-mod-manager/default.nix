{ pkgs ? import <nixpkgs> {} }:

pkgs.appimageTools.wrapType2 {
  name = "deadlock-mod-manager";
  version = "0.9.2";
  src = pkgs.fetchurl {
    url = "https://github.com/deadlock-mod-manager/deadlock-mod-manager/releases/download/v0.9.2/Deadlock.Mod.Manager_0.9.2_amd64.AppImage";
    sha256 = "0000000000000000000000000000000000000000000000000000";  # You'll need to update this
  };

  extraPkgs = pkgs: with pkgs; [
    mesa
    libglvnd
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
  ];
}
