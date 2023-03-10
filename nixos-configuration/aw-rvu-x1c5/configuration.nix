{ config, pkgs, ... }:
{
  networking.hostName = "aw-rvu-x1c5"; # Define your hostname.

  imports = [
  # Include the results of the hardware scan.
  ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.extraEntries = { "manjaro.conf" = ''
          title Manjaro Linux
          linux /efi/manjaro/vmlinuz-5.10-x86_64
          initrd /efi/manjaro/initramfs-5.10-x86_64.img
          options cryptdevice=PARTUUID="fe68be81-0849-4c49-a8c5-104ee06aa67b":root root=/dev/mapper/root add_efi_memmap
  ''; };

  boot.loader.efi.efiSysMountPoint = "/boot/efi";
}
