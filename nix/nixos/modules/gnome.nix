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

  nixpkgs.config.chromium.commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    { from = 1714; to = 1764; }
  ];
}
