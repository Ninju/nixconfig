{ config, pkgs, ... }:
{
  networking.hostName = "aw-t490"; # Define your hostname.

  imports = [
  # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.supportedFilesystems = [ "ext4" "ntfs" ];

  fileSystems."/shared" = {
    device = "/dev/disk/by-label/Shared";
    fsType = "ntfs";
     options = [
       "fmask=133"
       "dmask=022"
     ];
  };
}
