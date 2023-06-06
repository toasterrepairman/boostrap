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

  #DLNA
  services.minidlna.enable = true;
  services.minidlna.settings = {
    friendly_name = "Joel's Desktop";
    media_dir = [
     "V,/run/media/toast/Leviathan 1/" #Videos files are located here
    ];
    log_level = "error";
  };

  users.users.minidlna = {
    extraGroups = [ "users" ]; # so minidlna can access the files.
  };

  services.minidlna.openFirewall = true;

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
