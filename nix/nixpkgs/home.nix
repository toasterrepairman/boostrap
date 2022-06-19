{ config, pkgs, ... }:

{
  imports =
  [ # Here we list the modules we want to add to our config:
    # ./modules/
  ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "toast";
  home.homeDirectory = "/home/toast";

  gtk = {
    enable = true;
    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };

  programs.git = {
    enable = true;
    userName  = "toasterrepairman";
    userEmail = "fixing@toast.cyou";
  };
  
  programs.gitui.enable = true; 

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
