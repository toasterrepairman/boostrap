{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # Wayland compositor and tools
    swayfx
    swaylock-effects
    swayidle
    wl-clipboard
    grim
    slurp
    mako
    wofi
    waybar

    # applications
    xwayland
    tuba
    cartridges
    ungoogled-chromium
    blanket
    bottles
    celluloid
    dissent
    keypunch
    libadwaita

    # Sway-compatible alternatives and additions
    foot # terminal emulator
    pavucontrol # audio control
    playerctl # media control
    networkmanagerapplet # network management
    blueman # bluetooth management
    swaysettings # settings app
    gnome-tweaks # still useful for some GTK settings
  ];

  # Enable Sway
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      swaylock-effects
      swayidle
      wl-clipboard
      mako
      wofi
      foot
    ];
  };

  programs.dconf.enable = true;

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.seahorse.out}/libexec/seahorse/ssh-askpass";
  services.gnome.gnome-keyring.enable = true;

  # Replace GDM with SDDM or ly for Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };
  services.displayManager.defaultSession = "sway";

  # Keep important services
  services.udev.packages = with pkgs; [
    gnome-settings-daemon # still useful for some hardware integration
  ];

  services.avahi.extraConfig = "
    [publish]
    disable-user-service-publishing=
  ";

  # Enable additional services for Sway
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  security.polkit.enable = true;
  services.dbus.enable = true;

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Keep networking
  networking.networkmanager.enable = true;

  # Keep firewall rules for KDE Connect (works with GSConnect alternatives)
  networking.firewall.allowedTCPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];
  networking.firewall.allowedUDPPortRanges = [
    {
      from = 1714;
      to = 1764;
    }
  ];

  # Enable some useful features for Sway
  security.pam.services.swaylock = {};

  # Font configuration
  fonts.packages = with pkgs; [
    font-awesome
    noto-fonts
    noto-fonts-emoji
  ];
}
