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
  ];
  services.flatpak.enable = true;
}
