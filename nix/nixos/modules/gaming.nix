{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  # Gaming stuff
  environment.systemPackages = with pkgs; [
    flatpak
    discord
    gamescope
    moonlight-qt
    moonlight-embedded
    # prismlauncher
    # obs-studio
    # projectm
    # Tools
    # gamemode
    mangohud
    protonup-ng
    # xonotic
    protontricks
    wineWow64Packages.staging
    winetricks
  ];

  # temp fix for lutris package + NVIDIA Vulkan ICD in FHS sandbox
  nixpkgs.overlays = [
    (_: prev: {
      openldap = prev.openldap.overrideAttrs {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      };
      lutris = prev.lutris.override {
        extraLibraries = p: [
          config.hardware.nvidia.package
        ];
      };
    })
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
