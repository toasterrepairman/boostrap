{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "toast";
  home.homeDirectory = "/home/toast";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  {
    gtk = {
      enable = true;
      theme = {
        package = pkgs.nordic;
        name = "nordic";
      };
      iconTheme = {
        package = pkgs.nordzy-icon-theme;
        name = "nordzy-icon-theme";
      };
      gtk2.extraConfig = ''
        gtk-cursor-theme-size = 16
        gtk-cursor-theme-name = "nordzy-cursor-theme
      '';
      gtk3.extraConfig = {
        gtk-cursor-theme-size = 16;
        gtk-cursor-theme-name = "nordzy-cursor-theme";
      };
    };
  }
}

