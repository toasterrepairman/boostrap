{ config, pkgs, ... }: 

{
  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Ensure you have your video drivers installed!
  
  # Choose your bootloader, use boot.loader.grub.device for legacy systems
  boot.loader.systemd-boot.enable = true;

  # Define a hostname
  networking.hostName = "default"; # Define your hostname.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp4s0.useDHCP = true; # Don't forget to check these!
  networking.interfaces.wlp3s0.useDHCP = true; # You can do so with `ip a` 

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
