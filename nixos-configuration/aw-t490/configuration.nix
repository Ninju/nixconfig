{ config, pkgs, ... }:
{
  networking.hostName = "aw-t490"; # Define your hostname.

  imports = [
  # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
}
