{ config, pkgs, ... }: 

{
  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Appease the Nvidia Gods
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.open = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;  
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia.modesetting.enable = true;
  virtualisation.docker.enableNvidia = true;
 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = true;
  };
  
  # Use the systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "toaster"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = true;
  networking.useDHCP = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # services.openvpn.servers = {
  #   toastvpn = { config = 
  #     '' config /home/toast/Documents/Cloud/Lifehub/Computer/VPN/openvpn-toast.key ''; 
  #    };
  # };

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  networking.firewall.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.allowedUDPPorts = [
    3702 # wsdd
  ];
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      #workgroup = WORKGROUP
      server string = toaster
      netbios name = toaster
      security = user
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.0. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/run/media/toast/Leviathan 1/Archives/Videos/";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        # "create mask" = "0644";
        # "directory mask" = "0755";
        # "force user" = "username";
        # "force group" = "groupname";
      };
    };
  };


  environment.systemPackages = with pkgs; [
    # davinci-resolve
    xorg.libxcb
    cudaPackages.cudatoolkit
    cachix
  ];

  boot.binfmt.emulatedSystems = [
    "aarch64-linux"
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  users.users.toast.packages = with pkgs;
  [
    vulkan-tools
  ];
}
