{ config, pkgs, ... }:

{
  # Allow proprietary software to taint my pure system
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;
  # Add "the Stain"
  services.flatpak.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-12.2.3"
  ];

  # Enable Bluetooth on a hardware level
  hardware.bluetooth.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  

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

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  
  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # KDE Connect support
  programs.kdeconnect.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  
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

  environment.systemPackages = with pkgs; [
    # OS tools
    kdeconnect
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
    discord
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
