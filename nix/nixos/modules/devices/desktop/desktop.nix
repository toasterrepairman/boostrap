{
  config,
  pkgs,
  lib,
  ...
}: {
  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Appease the Nvidia Gods
  hardware.graphics.extraPackages32 = with pkgs.pkgsi686Linux; [libva];
  services.pulseaudio.support32Bit = true;
  hardware.steam-hardware.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # evil (remove later)
  # boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nixpkgs.config.nvidia.acceptLicense = true;

  # boot.kernelPackages = pkgs.linuxPackages.extend (self: super: {
  #   nvidia_x11 = super.nvidia_x11_beta;
  # });

  services.xserver = {
    videoDrivers = ["nvidia"];
  };

  # Star Citizen
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
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
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.production;

    # static driver config
    /*
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "560.35.03";
      sha256_64bit = "sha256-8pMskvrdQ8WyNBvkU/xPc/CtcYXCa7ekP73oGuKfH+M=";
      openSha256 = "sha256-/32Zf0dKrofTmPZ3Ratw4vDM7B+OgpC4p7s+RHUjCrg=";
      settingsSha256 = "sha256-kQsvDgnxis9ANFmwIwB7HX5MkIAcpEEAHc8IBOLdXvk=";
      sha256_aarch64 = lib.fakeSha256;
      persistencedSha256 = lib.fakeSha256;
    };
    */
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  programs.xwayland.enable = true;

  boot.initrd.kernelModules = ["nvidia"];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  # hardware.nvidia.powerManagement.finegrained = true;
  # intel
  boot.kernelParams = ["module_blacklist=i915"];

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
    sunshine
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart
    gwe
    lutris
    nv-codec-headers-12
    ollama-cuda
    blender
    # linuxKernel.packages.linux_6_6.nvidia_x11_production
  ];

  # cuda overrides
  nixpkgs.overlays = [
      (self: super: {
        blender = super.blender.override { cudaSupport = true; };
      })
  ];

  # sunshine config
  services.sunshine = {
    autoStart = false;
    capSysAdmin = true;
    enable = true;
  };

  hardware.graphics.enable32Bit = true;
  hardware.graphics.enable = true;
  services.ratbagd.enable = true;

  users.users.toast.packages = with pkgs; [
    vulkan-tools
  ];
}
