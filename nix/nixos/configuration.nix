# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }: 

{
  imports =
    [ # Include the results of the hardware scan.
      ./devices/desktop/hardware-configuration.nix
    ];

  # Use the systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "toaster"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;

  systemd.network.enable = true;

  # Enable Bluetooth on a hardware level
  hardware.bluetooth.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable Syncthing
  services.syncthing.enable = true;

  # Appease the Nvidia Gods
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.enable = true;
  hardware.steam-hardware.enable = true;
  
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
 
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toast = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };
  users.defaultUserShell = pkgs.fish;
  security.pam.services.toast.enableKwallet = true;
  services.gnome.gnome-keyring.enable = true;

  programs.git.enable = true;
  programs.git.config = {
  	init = {
  	  credential.username = "toasterrepairman";
  	  user.name = "toast";
  	  user.email = "smol@toast.cyou";
  	  };
  };

  # Configure shell
  environment.shellAliases = {
  	ll = "ls -l";
  	cocosay = "ponysay -f 'Coco Pommel'";
  };

  # Enable Nix Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  
  # Allow proprietary software to taint my pure system
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowBroken = true;
  environment.systemPackages = with pkgs; [
  # System utilities
    micro 
    wget
    fish
    btop
    libsecret
    ponysay
    flatpak
    # OS tools
    kdeconnect
    quota
    syncthing
    syncthing-gtk 
    gnome.seahorse
    gnome.gnome-keyring
    gnome.libgnome-keyring
    gnome.baobab 
    ouch
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
    # Productity
    evince
    gImageReader
    wike
    libreoffice
    # Media
    vlc
    handbrake
    ncspot
    spotify
    easyeffects
    gthumb
    # Programming
    taxi
    okteta
    vscodium
    meld
    gitg
    # Gaming
    wine
    protonup
    multimc
    bottles
  ];

  services.flatpak.enable = true;

  # Gaming stuff
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  # KDE Connect support
  programs.kdeconnect.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
