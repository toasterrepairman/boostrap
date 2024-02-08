{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    tilix
    xwayland
    libgda
    # Extensions
    # gnomeExtensions.gsconnect
    # gnome.gnome-tweaks
  ];

  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.gnome.seahorse.out}/libexec/seahorse/ssh-askpass";
  services.gnome.gnome-keyring.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia"];
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome.enable = true;
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
