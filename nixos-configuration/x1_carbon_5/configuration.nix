{ config, pkgs, ... }:
{
  imports = [
  # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    slack
    zoom-us
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.extraEntries = { "manjaro.conf" = ''
          title Manjaro Linux
          linux /efi/manjaro/vmlinuz-5.10-x86_64
          initrd /efi/manjaro/initramfs-5.10-x86_64.img
          options cryptdevice=PARTUUID="fe68be81-0849-4c49-a8c5-104ee06aa67b":root root=/dev/mapper/root add_efi_memmap
  ''; };

  # Only show N most recent generations in the boot menu
  # (useful to prevent running out of disk space)
  boot.loader.systemd-boot.configurationLimit = 50;

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
}
