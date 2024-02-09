{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toast = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "user-with-access-to-virtualbox" "video" ]; 
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
    };
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
  # networking.firewall.checkReversePath = "loose";

  programs.dconf.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    options = "--delete-older-than 30d";
  };

  # Allow proprietary software to taint my pure system
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;

  programs.fish = {
    enable = true;
    shellInit = "date";
    shellAliases = {
      cocosay = "ponysay -f 'Coco Pommel'";
      gitlog = "git log --graph --oneline";
      l = "ls -l";
      cdd = "cd ~/Documents/Code/Shell/boostrap || echo 'boostrap repo not found'";
      cdc = "cd ~/Documents/Code/ || echo 'Code directory not found'";
      rebuild = "sudo nixos-rebuild switch --cores 8";
      rebuild-full = "sudo nixos-rebuild switch --upgrade-all --cores 8";
      disable-ipv6 = "su -c 'echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6'";
    };
    vendor.completions.enable = true;
  };

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
    helix
    vscode-extensions.llvm-org.lldb-vscode
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
    pkg-config
    racket
    pipenv
    yt-dlp
    nix-tree
    ruff
    ouch
    rustup
    gcc
    gdb
    meson
    ninja
    git
    git-lfs
    unrar
    cryptsetup
    fzf
  ];
}
