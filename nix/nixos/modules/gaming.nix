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
    protonup-ng
    xonotic
    protontricks
  ];
  
  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        libgdiplus
      ];
    };
  };

  nixpkgs.overlays = [
    (import ./applications/discord.nix)
    (import ./applications/obsidian.nix)
  ];
}
