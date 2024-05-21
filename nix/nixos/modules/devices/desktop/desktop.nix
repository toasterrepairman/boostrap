{ config, pkgs, lib, ... }: 

{
  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Appease the Nvidia Gods
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;  
  virtualisation.docker.enableNvidia = true;

  nixpkgs.config.nvidia.acceptLicense = true;

  # boot.kernelPackages = pkgs.linuxPackages.extend (self: super: {
  #   nvidia_x11 = super.nvidia_x11_dc_535;
  # });
  
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.enable = true;
    # powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
  	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # package = config.boot.kernelPackages.nvidiaPackages.;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    # package = config.boot.kernelPackages.nvidiaPackages.production;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.42.02";
      sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
      sha256_aarch64 = "sha256-ekx0s0LRxxTBoqOzpcBhEKIj/JnuRCSSHjtwng9qAc0=";
      openSha256 = "sha256-3/eI1VsBzuZ3Y6RZmt3Q5HrzI2saPTqUNs6zPh5zy6w=";
      settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      persistencedSha256 = "sha256-3ae31/egyMKpqtGEqgtikWcwMwfcqMv2K4MVFa70Bqs=";
    };
  };
      
 
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
      allowUnfree = true;
      cudaSupport = true;
  };

  programs.xwayland.enable = true;

  
  boot.initrd.kernelModules = [ "nvidia" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  # hardware.nvidia.powerManagement.finegrained = true;
  # intel
  boot.kernelParams = [ "module_blacklist=i915" ];

  # Use the systemd boot
  boot.loader.systemd-boot.enable = true;
  zramSwap.enable = true;

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

  environment.systemPackages = with pkgs; [
    # davinci-resolve
    xorg.libxcb
    # cudaPackages.cudatoolkit
    # linuxKernel.packages.linux_6_6.nvidia_x11_production
  ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.enable = true;

  users.users.toast.packages = with pkgs;
  [
    vulkan-tools
  ];
}
