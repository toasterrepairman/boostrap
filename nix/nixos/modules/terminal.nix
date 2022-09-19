{ config, pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.toast = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
  };
  
  users.defaultUserShell = pkgs.fish;

  # Docker time!
  virtualisation.docker.enable = true;

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
  ];
}
