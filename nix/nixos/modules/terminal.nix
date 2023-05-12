{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toast = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "user-with-access-to-virtualbox" ]; 
  };
  
  users.defaultUserShell = pkgs.fish;

  # Docker time!
  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  programs.git.enable = true;
  programs.git.config = {
  	init = {
  	  credential.username = "toasterrepairman";
  	  user.name = "toast";
  	  user.email = "smol@toast.cyou";
  	  };
  };

  # Configure shell
  programs.fish = {
    shellAbbrs = {
      ll = "ls -l";
      cocosay = "ponysay -f 'Coco Pommel'";
      gitlog = "git log --graph --oneline";
    };
    vendor.completions.enable = true; 
  };

  # Enable Nix Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";


  environment.sessionVariables = {
     MOZ_ENABLE_WAYLAND = "1";
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

    programs.dconf.enable = true;

  # Allow proprietary software to taint my pure system
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  nix.settings.auto-optimise-store = true;
  programs.fish.enable = true;


  # Enable Bluetooth on a hardware level
  hardware.bluetooth.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;
  systemd.services.NetworkManager-wait-online.enable = false;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.earlyoom = {
  	enable = true;
  	freeMemThreshold = 5;
  };

  # Packages required for profile
  environment.systemPackages = with pkgs; [
    micro 
    wget
    fish
    btop
    libsecret
    ponysay
    jq
    fd
    lsof 
    killall
    rustc
    cargo
    pandoc
    pkgconfig
    racket
    pipenv
    yt-dlp
    ruff
    ouch
    rustup
    gcc
    gdb
    meson
    ninja
    git
    cryptsetup
  ];
}
