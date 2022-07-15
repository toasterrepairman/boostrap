{ config, pkgs, ... }: 

{
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
    discord
    betterdiscord-installer
    wine
    protonup
    bottles
    lutris
    polymc
    # Tools
    gamemode
    mangohud
  ];
  services.flatpak.enable = true;
}
