{
  config,
  pkgs,
  ...
}: {
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Ensure you have your video drivers installed!

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "nixos-quartz"; # Define your hostname.
  # Pick only one of the below networking options.

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # services.xserver.enable = true;
  # services.xserver.desktopManager.kodi.enable = true;
  # services.xserver.displayManager.autoLogin.enable = true;
  # services.xserver.displayManager.autoLogin.user = "kodi";

  # TV Server Config:
  # --- Radarr ---
  # services.radarr.enable = true;
  # services.radarr.openFirewall = true;

  # --- Sonarr ---
  # services.sonarr.enable = true;
  # services.sonarr.openFirewall = true;

  # --- Bazarr ---
  # services.bazarr.enable = true;

  # List services that you want to enable:

  # powerManagement.powerUpCommands = """
  # """;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";

  #DLNA
  services.minidlna.enable = true;
  services.minidlna.settings = {
    friendly_name = "Home Server";
    media_dir = [
      "V,/mnt/media" #Videos files are located here
    ];
    log_level = "error";
  };

  users.users.minidlna = {
    extraGroups = ["users"]; # so minidlna can access the files.
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        # Listening Address
        http_addr = "127.0.0.1";
        # and Port
        http_port = 3000;
      };
    };
  };

  services.minidlna.openFirewall = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22 80 8080 1234 2283 8096 8090 3000 3001 3002 3003 25565 25575];
  networking.firewall.allowedUDPPorts = [7359 1900 53];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.deluge = {
    enable = true;
    user = "toast";
    web.enable = true;
    web.port = 8090;
    web.openFirewall = true;
  };

  systemd.services.user-led = {
    enable = true;
    description = "Turn off heartbeat LED";
    unitConfig = {
      Type = "simple";
      # ...
    };
    serviceConfig = {
      ExecStart = ''${pkgs.bash}/bin/bash -c "echo none > /sys/class/leds/user-led/trigger"'';
      # ...
    };
    wantedBy = ["multi-user.target"];
    after = ["multi-user.target"];
  };
  zramSwap.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  # system.stateVersion = "unstable";
}
