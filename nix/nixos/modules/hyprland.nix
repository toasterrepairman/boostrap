{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # stuff
    kitty
    waybar
    nwg-look
    xorg.xcursorthemes
    xcursor-pro
    rofi
    cliphist
    dunst
    grim
    slurp
    nautilus
    swww
    fuzzel
    blueman
    gnome-keyring
    seahorse  # GUI for managing keys (optional)
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
    xwayland.enable = true;
  };

  # Enable the GNOME Keyring daemon service
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  programs.hyprlock.enable = true;
  services.hypridle.enable = true;

  programs.dconf.enable = true;

  # important
  xdg.portal.enable = true;
  networking.networkmanager.enable = true;

  # Enable services for auto-mounting and storage devices
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.devmon.enable = true;
  services.upower.enable = true;

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
