{
  config,
  pkgs,
  ...
}: let
  unstableTarball =
    fetchTarball
    https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  imports = [<home-manager/nixos>];
in {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  services.earlyoom = {
    enable = true;
    freeMemThreshold = 5;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services = {
    syncthing = {
      enable = true;
      dataDir = "/home/toast";
      user = "toast";
      group = "users";
      openDefaultPorts = true;
      configDir = "/home/toast/.syncthing/";
      # systemService = true;
      settings = {
        devices = {
          "Phone" = {id = "4DK5N34-FVRFBOC-FLVRHKG-ZZOOWWT-JC7TX7D-LM2D33I-CJTRUXE-4YODEQH";};
          "toaster" = {id = "EBRBP4H-7KU7UVJ-G3FXKXD-6EJS7S5-G6KROIW-73L4SSZ-IOFNN2B-T7THGA2";};
          "toastpad" = {id = "V4MZ27K-QC7SAC2-QVIRM4J-QWDT6SN-7PFTRZH-OLLOI2X-XAGOP76-3I67QQP";};
        };
        folders = {
          "Cloud" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/toast/Documents/Cloud"; # Which folder to add to Syncthing
            devices = ["toastpad" "toaster" "Phone"]; # Which devices to share the folder with
          };
          "Pictures" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/toast/Pictures"; # Which folder to add to Syncthing
            devices = ["toastpad" "toaster" "Phone"]; # Which devices to share the folder with
          };
          "Music" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/toast/Music"; # Which folder to add to Syncthing
            devices = ["toastpad" "toaster"]; # Which devices to share the folder with
          };
          "Books" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/toast/Documents/Books"; # Which folder to add to Syncthing
            devices = ["toastpad" "toaster"]; # Which devices to share the folder with
          };
          "Bitwig" = {
            # Name of folder in Syncthing, also the folder ID
            path = "/home/toast/Bitwig Studio"; # Which folder to add to Syncthing
            devices = ["toastpad" "toaster"]; # Which devices to share the folder with
          };
        };
      };
    };
  };

  #  networking.firewall.allowedTCPPorts = [ 22 443 8080 80 9943 9944 ];
  #  networking.firewall.allowedUDPPorts = [ 1900 9943 9944 ];
  #    networking.firewall.allowedUDPPortRanges = [
  #      # Allow UPnP/SSDP traffic for Chromecast
  #      # https://github.com/NixOS/nixpkgs/issues/49630#issuecomment-622498732
  #      { from = 32768; to = 60999; }
  #    ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation propeties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # horrorshow hacks
  # delete these before reaching the gates of heaven
  environment.sessionVariables = rec {
    GOPATH = "\${HOME}/.go";
    GTK_THEME = "adw-gtk3-dark";
  };

  # i trust these are unneccesary but i dont know anymore
  nixpkgs.config.permittedInsecurePackages = [
    "electron-21.4.0"
    "electron-12.2.3"
    "electron-24.8.6"
    "electron-25.9.0"
    "python-2.7.18.6"
  ];

  nix.extraOptions = ''
    binary-caches-parallel-connections = 1
    connect-timeout = 3
    cores = 8
  '';

  # prevent EFI overload
  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 4;
  };

  # Enable Bluetooth on a hardware level
  hardware.bluetooth.enable = true;

  # fwupd online
  services.fwupd.enable = true;

  # Enable trackpad gestures, everywhere!
  services.libinput.enable = true;

  # appimage settings
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  security.polkit.enable = true;

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Enable sound.
  # sound.enable = true;
  # services.pulseaudio.enable = false; # explicitly set to false for pipewire
  # services.pipewire = {
  #   enable = true;
  #   alsa = {
  #     enable = true;
  #     support32Bit = true;
  #   };
  #   pulse.enable = true;
  # };

  # networking = {
  #  nameservers = ["8.8.8.8" "8.8.4.4"];
  # };

  virtualisation.libvirtd.enable = true;

  programs.fish.enable = true;

  # delete this when your system breaks
  # boot.kernelPackages = pkgs.linuxPackages;

  users.users.toast.extraGroups = ["adbusers"];

  environment.systemPackages = with pkgs; [
    # OS tools
    pkgs.android-tools
    system76-scheduler
    ungoogled-chromium
    quota
    syncthing
    seahorse
    gnome-keyring
    libgnome-keyring
    gnome-logs
    appimage-run
    gsettings-desktop-schemas
    # Ricing
    home-manager
    adw-gtk3
    nordic
    inter
    apple-cursor
    kdePackages.xdg-desktop-portal-kde
    quintom-cursor-theme
    ibm-plex
    zafiro-icons
    # Userland
    firefox-bin
    keypunch
    newsflash
    spicetify-cli
    kdePackages.ark
    kdePackages.kio-extras
    # kdePackages.libdbusmenu
    kdePackages.bluez-qt
    # libsForQt5.kitinerary
    # qt5.qtwebsockets
    # kdePackages.plasma-framework
    # kdePackages.qtdeclarative
    # Productity
    evince
    wike
    foliate
    gImageReader
    gnome-clocks
    keypunch
    # gimp
    ghostty
    zim
    # obs-studio
    gnome-secrets
    # Media
    tuba
    celluloid
    # obs-studio
    video-trimmer
    arduino
    vulkan-headers
    bitwig-studio4
    vlc
    amberol
    shortwave
    dissent
    # easyeffects
    # handbrake
    spot
    gnome-podcasts
    libva-vdpau-driver
    # Programming
    taxi
    # heaptrack
    hotspot
    winetricks
    # linuxKernel.packages.linux_latest_libre.perf
    okteta
    miniupnpc
    libupnp
    qemu
    rnote
    meld
    gitg
    helix
    sysprof
    vscodium
    # quodlibet
    cascadia-code
    libratbag
    libva-vdpau-driver
    # bluetooth hack
    # bluedevil
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
    vscode-extensions.llvm-org.lldb-vscode
    # python
    python311
    python311Packages.websockets
    python311Packages.pip
  ];
}
