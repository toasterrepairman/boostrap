{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    tilix
    xwayland
    libgda
    # Extensions
    gnomeExtensions.gsconnect
    gnome.gnome-tweaks
  ];

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
}
