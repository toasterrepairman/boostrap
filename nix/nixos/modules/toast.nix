{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  imports = [ <home-manager/nixos> ];

in
{  
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };
  programs.dconf.enable = true;

  xdg.portal.enable = true;

  # Allow proprietary software to taint my pure system
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];

  # Enable Bluetooth on a hardware level
  hardware.bluetooth.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  
  systemd.services.NetworkManager-wait-online.enable = false;

  services = {
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      systemService = true;
      devices = {
        "Phone" = { id = "NHAN2GF-PQN2XBO-K7IQQVE-DRFPP2H-RX7J4SK-CEP2FVF-HUGQXH2-EG5OXAE"; };
      };
      folders = {
        "Cloud" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Documents/Cloud";    # Which folder to add to Syncthing
          devices = [ "Phone" ];      # Which devices to share the folder with
        };
        "Pictures" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Pictures";    # Which folder to add to Syncthing
          devices = [ "Phone" ];      # Which devices to share the folder with
        };
        "Music" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Music";    # Which folder to add to Syncthing
          devices = [ "Phone" ];      # Which devices to share the folder with
        };
        "Books" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Documents/Books";    # Which folder to add to Syncthing
          devices = [ "Phone" ];      # Which devices to share the folder with
        };
      };
    };
  };
  
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = false; # explicitly set to false for pipewire
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  services.tailscale.enable = true;
  
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  environment.systemPackages = with pkgs; [
    # OS tools
    quota
    syncthing
    gnome.seahorse
    gnome.gnome-keyring
    gnome.libgnome-keyring
    filelight 
    ouch
    ibus-engines.typing-booster
    qt5.qttools
    # Ricing
    home-manager
    nordic
    quintom-cursor-theme
    ibm-plex
    # Userland
    chromium
    evolution
    foliate
    gnome-feeds
    betterdiscordctl
    elementary-planner
    zoom-us
    obsidian
    transmission-gtk
    tootle
    spicetify-cli
    betterdiscordctl
    libsForQt5.ark
    partition-manager
    # Productity
    evince
    gImageReader
    wike
    libreoffice
    gimp
    syncthingtray
    etcher
    # Media
    vlc
    handbrake
    ncspot
    spotify
    easyeffects
    gthumb
    mpv
    curtail
    # Programming
    taxi
    okteta
    vscode
    jetbrains.idea-community
    meld
    gitg
    kate
    sysprof
    ghidra
  ];
}
