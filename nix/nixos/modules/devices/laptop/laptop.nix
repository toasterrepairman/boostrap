{
  pkgs,
  config,
  ...
}: {
  # Use the systemd boot
  boot.loader.systemd-boot.enable = true;

  networking.hostName = "toastpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  zramSwap.enable = true;

  # Set your time zone.
  time.timeZone = "America/Detroit";
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [libva];
  services.pulseaudio.support32Bit = true;
  hardware.graphics.enable = true;
  hardware.steam-hardware.enable = true;

  # services.fprintd.enable = true;
  # services.fprintd.tod.enable = true;
  # services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;

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
