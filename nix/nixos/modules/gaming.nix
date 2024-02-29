{ config, pkgs, lib, ... }: 

{
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
    discord
    wine
    gamescope
    protonup
    # prismlauncher
    # obs-studio
    # projectm
    # Tools
    gamemode
    mangohud
    protonup-ng
    # xonotic
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
  # Get Sunlight working:
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 47984 47989 48010 47990 ];
    allowedUDPPortRanges = [
      { from = 47998; to = 48010; }
    ];
  };
}
