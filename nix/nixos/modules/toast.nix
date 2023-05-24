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
        "toaster" = { id = "EBRBP4H-7KU7UVJ-G3FXKXD-6EJS7S5-G6KROIW-73L4SSZ-IOFNN2B-T7THGA2"; };
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

  nixpkgs.config.permittedInsecurePackages = [
    "electron-21.4.0"
    "electron-12.2.3"
    "python-2.7.18.6"

  ];
  

  programs.fish.enable = true;

  # delete this when your system breaks
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # (it will probably be too late :p)

  environment.systemPackages = with pkgs; [
    # OS tools
    quota
    syncthing
    gnome.seahorse
    gnome.gnome-keyring
    gnome.libgnome-keyring
    filelight 
    qt5.qttools
    appimage-run
    gsettings-desktop-schemas
    libsForQt5.kdenetwork-filesharing
    # Ricing
    home-manager
    nordic
    quintom-cursor-theme
    ibm-plex
    zafiro-icons
    tootle
    # Userland
    firefox
    newsflash
    komikku
    tilix
    betterdiscordctl
    obsidian
    transmission-gtk
    spicetify-cli
    cemu
    betterdiscordctl
    libsForQt5.ark
    libsForQt5.kio-extras
    pavucontrol 
    libsForQt5.bluez-qt
    libsForQt5.kitinerary
    qt5.qtwebsockets
    libsForQt5.plasma-framework
    libsForQt5.qtdeclarative
    kdeplasma-addons
    bluez
    partition-manager
    # Productity
    evince
    foliate
    gImageReader
    gimp
    etcher
    gnome-secrets
    # Media
    libsForQt5.tokodon
    vulkan-headers
    bitwig-studio
    vlc
    ncspot
    mpv
    easyeffects
    celluloid
    spot
    chatterino2
    vaapiVdpau
    # Programming
    taxi
    okteta
    jetbrains.idea-community
    meld
    gitg
    kate
    sysprof
    ghidra
    cascadia-code
    amberol
    # bluetooth hack 
    bluedevil 
    # these are my dark GTK passengers
    cairo
    gdk-pixbuf
    gobject-introspection
    graphene
    gtk3.dev
    gtksourceview5
    libadwaita
    openssl
    pango
    appstream-glib
    polkit
    gettext
    desktop-file-utils
    wrapGAppsHook4
    # python
    python311
    python311Packages.websockets
    python311Packages.pip
  ];
}
