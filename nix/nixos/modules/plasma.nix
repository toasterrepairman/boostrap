{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  imports = [ <home-manager/nixos> ];

in
{  
  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  programs.dconf.enable = true;

  # important
  xdg.portal.enable = true;
  networking.networkmanager.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.desktopManager.plasma5.enable = true;

  # KDE Connect support
  programs.kdeconnect.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  programs.ssh.askPassword = pkgs.lib.mkForce "${pkgs.ksshaskpass.out}/bin/ksshaskpass";
  services.xserver.enable = true;
  security.pam.services.toast.enableKwallet = true;

	hardware.bluetooth.settings = {
	  General = {
	    Enable = "Source,Sink,Media,Socket";
	  };
	};


  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;
}
