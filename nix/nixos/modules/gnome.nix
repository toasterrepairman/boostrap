{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    tilix
    xwayland
    libgda
    # Extensions
    gnomeExtensions.blur-my-shell
    gnomeExtensions.gsconnect
    gnomeExtensions.pano
    gnomeExtensions.appindicator
    tuba
    gnome.gnome-tweaks
  ];

  programs.dconf.enable = true;

  # important
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";
  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.displayManager.defaultSession = "gnome";

  services.udev.packages = with pkgs; [
    gnome.gnome-settings-daemon
  ];


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
