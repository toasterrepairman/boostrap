{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    # tilix
    xwayland
    # libgda
    # Extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    # gnomeExtensions.pano
    gnomeExtensions.appindicator
    gnomeExtensions.caffeine
    gnomeExtensions.bluetooth-battery
    # gnomeExtensions.wintile-windows-10-window-tiling-for-gnome
    gnomeExtensions.gsnap
    # gnomeExtensions.rounded-window-corners
    tuba
    cartridges
    # apostrophe
    gnome-tweaks
    ungoogled-chromium
  ];

  programs.dconf.enable = true;

  # important
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";
  services.gnome.gnome-keyring.enable = true;

  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.displayManager.defaultSession = "gnome";

  services.udev.packages = with pkgs; [
    gnome-settings-daemon
  ];

  services.avahi.extraConfig = "
    [publish]
    disable-user-service-publishing=
  ";

  services.xserver = {
    enable = true;
  };

  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      # Change default background
      [org.gnome.mutter]
      check-alive-timeout=60000
      experimental-features=['scale-monitor-framebuffer']
    '';


    extraGSettingsOverridePackages = [
      pkgs.gsettings-desktop-schemas # for org.gnome.desktop
      pkgs.gnome-shell # for org.gnome.shell
      pkgs.mutter
    ];
  };

  # important
  xdg.portal.enable = true;
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
}
