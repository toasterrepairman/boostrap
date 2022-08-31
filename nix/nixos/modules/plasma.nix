{ config, pkgs, ... }:

{  
  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;

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
