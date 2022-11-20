{ config, pkgs, lib, ... }: 


{
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
    discord
    betterdiscord-installer
    wine
    protonup
    prismlauncher
    obs-studio
    projectm
    # Tools
    gamemode
    mangohud
  ];
  services.flatpak.enable = true;

  nixpkgs.overlays = [
    (import ./applications/discord.nix)
    (import ./applications/obsidian.nix)
  ];
}
