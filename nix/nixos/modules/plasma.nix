{
  config,
  pkgs,
  ...
}: let
  unstableTarball =
    fetchTarball
    https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  imports = [<home-manager/nixos>];
in {
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    tilix
    xwayland
    libgda
    tuba
    ungoogled-chromium
    qt6.qtwayland
    kdePackages.bluedevil
    kdePackages.plasma-workspace
  ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    spectacle
  ];

  programs.dconf.enable = true;

  # important
  xdg.portal.enable = true;
  networking.networkmanager.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;

  # KDE Connect support
  programs.kdeconnect.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  services.xserver.enable = true;
  security.pam.services.toast.enableKwallet = true;

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
    };
  };


  # Enable CUPS to print documents.
  # services.printing.enable = true;
}
