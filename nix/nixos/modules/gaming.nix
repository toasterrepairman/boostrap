{
  config,
  pkgs,
  lib,
  ...
}: {
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
    discord
    gamescope
    protonup
    # prismlauncher
    # obs-studio
    # projectm
    # Tools
    # gamemode
    mangohud
    protonup-ng
    # xonotic
    protontricks
    wineWowPackages.staging
    winetricks
  ];

  # Remote gaming stack
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
  };
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  services.flatpak.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          libgdiplus
        ];
    };
  };
  # Get Sunlight working:
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [47984 47989 48010 47990 9757 11434];
    allowedUDPPorts = [5353 9757 4242];
    allowedUDPPortRanges = [
      {
        from = 47998;
        to = 48010;
      }
    ];
  };
}
