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
        http_addr = "0.0.0.0";
        # and Port
        http_port = 3000;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      mesa.drivers
    ];
  };

  # Install Vulkan tools and libraries
  environment.systemPackages = with pkgs; [
    vulkan-tools        # Includes vulkaninfo
    vulkan-loader
    vulkan-validation-layers
    screen              # Terminal multiplexer for AI server service
  ];

  # enable cache for grafana
  services.influxdb2.enable = true;
  services.telegraf.enable = true;

  services.minidlna.openFirewall = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [22 80 8080 8086 1234 2283 8096 8090 3000 3001 3002 3003 25565 25575 11434];
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

  services.lighttpd = {
    enable = true;
    port = 80;
    document-root = "/var/www/home-landing";
    extraConfig = ''
    server.modules += ( "mod_access", "mod_accesslog", "mod_proxy", "mod_rewrite" )
    server.indexfiles = ( "index.html" )
    accesslog.filename = "/var/log/lighttpd/access.log"

    # Allow directory listings if no index.html
    dir-listing.activate = "enable"

    # Proxy configuration for /api requests
    proxy.server = (
        "/api" => (
        (
            "host" => "127.0.0.1",
            "port" => 9757
        )
        )
    )
    '';
  };

  # Bind mount the user's home-landing directory to /var/www/home-landing
  fileSystems."/var/www/home-landing" = {
    device = "/home/toast/home-landing";
    fsType = "none";
    options = [ "bind" ];
  };

  # Create the mount point directory with proper permissions
  systemd.tmpfiles.rules = [
    "d /var/www 0755 root root - -"
    "d /var/www/home-landing 0755 root root - -"
    "d /home/toast/home-landing 0755 toast users - -"
  ];

  # Ensure the user has correct permissions and lighttpd can access files
  users.users.toast = {
    isNormalUser = true;
    home = "/home/toast";
    homeMode = "700";  # Allow others to traverse home directory
    extraGroups = [ "lighttpd" ];
  };

  users.users.lighttpd = {
    extraGroups = [ "users" ];
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

  # AI Server automation service
  systemd.services.ai-server = {
    enable = true;
    description = "AI Server - Discord bot and LLaMA server";
    wants = ["network-online.target"];
    after = ["network-online.target" "multi-user.target"];
    wantedBy = ["multi-user.target"];

    serviceConfig = {
      Type = "simple";
      User = "toast";
      Group = "users";
      Restart = "always";
      RestartSec = "10";

      # Create screen sessions and run the services
      ExecStart = ''${pkgs.bash}/bin/bash -c "
        # Create or attach to discord bot screen session
        ${pkgs.screen}/bin/screen -dmS discord -t "Discord Bot"
        ${pkgs.screen}/bin/screen -S discord -X stuff $'cd ~/egghead && nix develop . && bash reboot.sh\n'

        # Create or attach to llama-server screen session
        ${pkgs.screen}/bin/screen -dmS llama -t "LLaMA Server"
        ${pkgs.screen}/bin/screen -S llama -X stuff $'llama-server --model SmolVLM-500M-Instruct.Q4_K_M.gguf --host 0.0.0.0 --port 11434 --n-predict 512 --mmproj mmproj-SmolVLM-500M-Instruct-Q8_0.gguf\n'

        # Keep the service running
        while true; do
          sleep 3600
        done
      "'';

      # Ensure screen sessions are properly terminated on service stop
      ExecStop = ''${pkgs.bash}/bin/bash -c "
        ${pkgs.screen}/bin/screen -S discord -X quit 2>/dev/null || true
        ${pkgs.screen}/bin/screen -S llama -X quit 2>/dev/null || true
      "'';
    };
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
