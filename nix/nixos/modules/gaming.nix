{ config, pkgs, ... }: 

{
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
    discord
    betterdiscord-installer
    wine
    protonup
    lutris-unwrapped
    polymc
    obs-studio
    # Tools
    gamemode
    mangohud
  ];
  services.flatpak.enable = true;
}
