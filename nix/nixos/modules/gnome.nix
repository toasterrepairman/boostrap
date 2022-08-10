{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    firefox-wayland
    tilix
    xwayland
    # Extensions
    gnomeExtensions.gsconnect
    gnome.gnome-tweaks
  ];

  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
}
