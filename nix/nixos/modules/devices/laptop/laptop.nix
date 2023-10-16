{ pkgs, config, ... }:

{
  # Use the systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "toastpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  zramSwap.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.pulseaudio.support32Bit = true;
  hardware.opengl.enable = true;
  hardware.steam-hardware.enable = true; 

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;
    };
  };


  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  systemd.network.enable = true;
  systemd.network.wait-online.anyInterface = true;
  systemd.network.wait-online.enable = false;
  # often hangs
  # systemd.services.systemd-networkd-wait-online.enable = true;

  networking.dhcpcd.enable = false;

  # this leads to timeouts for some devices (virtualbox or tinc adapter)
  systemd.services.systemd-udev-settle.serviceConfig.ExecStart = ["" "${pkgs.coreutils}/bin/true"];

  # Enable Bluetooth on a hardware level
  hardware.bluetooth.enable = true;
}
