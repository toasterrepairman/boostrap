{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    xwayland
    tuba
    cartridges
    # apostrophe
    gnome-tweaks
    blanket
    bottles
    celluloid
    dissent
    keypunch
    libadwaita
  ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.dconf.enable = true;

  # important
  xdg.portal.enable = true;
  networking.networkmanager.enable = true;

  networking.firewall.allowedTCPPortRanges = [
    # KDE Connect
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    # KDE Connect
    {
      from = 1714;
      to = 1764;
    }
  ];
}
