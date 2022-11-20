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

  services = {
    syncthing = {
      enable = true;
      dataDir = "/home/toast";
      user = "toast";
      group = "users";
      openDefaultPorts = true;
      configDir = "/home/toast/.syncthing/";
      # systemService = true;
      devices = {
        "Phone" = { id = "NHAN2GF-PQN2XBO-K7IQQVE-DRFPP2H-RX7J4SK-CEP2FVF-HUGQXH2-EG5OXAE"; };
        "toaster" = { id = "MKBA3EO-ZZI2KJ3-ZAGF5UM-AWM37PO-YIEECSW-IW4PKVY-QZGR2A7-I6ICEAT"; };
        "toastpad" = { id = "FCCIKQE-VIMS4JX-F2MSSTL-72CGKJR-QTN3RXC-6KNH3H5-6SYQHDR-OW3JRQB"; };
      };
      folders = {
        "Cloud" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Documents/Cloud";    # Which folder to add to Syncthing
          devices = [ "toastpad" "toaster" "Phone" ];      # Which devices to share the folder with
        };
        "Pictures" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Pictures";    # Which folder to add to Syncthing
          devices = [ "toastpad" "toaster" "Phone" ];      # Which devices to share the folder with
        };
        "Music" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Music";    # Which folder to add to Syncthing
          devices = [ "toastpad" "toaster" "Phone" ];      # Which devices to share the folder with
        };
        "Books" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Documents/Books";    # Which folder to add to Syncthing
          devices = [ "toastpad" "toaster" "Phone" ];      # Which devices to share the folder with
        };
        "Bitwig" = {        # Name of folder in Syncthing, also the folder ID
          path = "/home/toast/Bitwig Studio";    # Which folder to add to Syncthing
          devices = [ "toastpad" "toaster" ];      # Which devices to share the folder with
        };
        
      };
    };
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # horrorshow hacks
  environment.variables = rec {
    GOPATH = "\${HOME}/.go";
  };

  # delete this when your system breaks
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [ virtualbox ];
  # (it will probably be too late :p)

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
    zafiro-icons
    # Userland
    chromium
    # firefox-wayland
    tilix
    betterdiscordctl
    zoom-us
    obsidian
    transmission-gtk
    spicetify-cli
    betterdiscordctl
    libsForQt5.ark
    partition-manager
    # Productity
    evince
    gImageReader
    gimp
    etcher
    # Media
    bitwig-studio
    vlc
    handbrake
    ncspot
    spotify
    easyeffects
    celluloid
    spot
    vaapiVdpau
    yt-dlp
    blender
    # Programming
    taxi
    okteta
    jetbrains.idea-community
    meld
    gitg
    kate
    sysprof
    ghidra
    rustup
    gcc
    cascadia-code
    # these are my dark GTK passengers
    pkg-config
    gdk-pixbuf
    gtk4.dev
    glib
    gsettings-desktop-schemas
    gtk3
    gtksourceview4
    gspell
    json-glib
    libdazzle
    libgee
    libgit2-glib
    libpeas
    libsecret
    libsoup
  ];
}
