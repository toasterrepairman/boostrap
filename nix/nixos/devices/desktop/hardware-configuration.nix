# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/1F2D-4E82";
      fsType = "vfat";
    };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/477fb665-25c5-483d-bc7a-fbbc1bf268a4";
      fsType = "btrfs";
    };

  fileSystems."/mnt/FastLane" =
    { device = "/dev/disk/by-uuid/4c9ef5ff-7fed-4066-b64c-0a5d740a270c";
      fsType = "btrfs";
    };

  fileSystems."/mnt/Storage" =
    { device = "/dev/disk/by-uuid/8ef0fe8b-b1ec-4289-8e27-3fd061220658";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/1b9bcd00-ee91-4f17-898d-b66870b7c4a3";

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}