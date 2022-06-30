{ config, pkgs, ... }: 

{
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
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
