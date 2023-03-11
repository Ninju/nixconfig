# Dotfiles -- My System & User Config in Nix

My dotfiles are managed in [nix](https://nixos.org/).

If you are new to nix, in a nutshell:

* My entire system config can be installed from scratch with a single command: `sudo nixos-rebuild --flake git+https://github.com/Ninju/nixconfig`
* My user config can be installed with `home-manager switch --flake git+https://github.com/Ninju/nixconfig`
* The result is reproducible across machines 
* User-level config (via `home-manager`) works on other Linux distros and on Mac OS if they have the nix package manager installed

## Structure

### Directory structure
* `./nixos-configuration` - System level config
* `./home-manager` - User level config
* `./lib` - functions

_Please note, but ignore, that I'm currently breaking all my own rules with my user-level system config, which enables/disables things by choosing to include or not include it in the `imports` directive._

# Actual experience -- one command install on new machines

The dream is one command to completely reconfigure your machine exactly how you like it.. I figured this section might be a good place to put my experiences and record TODOs.

## X1 Carbon 10th Gen
I recently was equipped with a new machine at work and had the chance to try rolling out my config to a new machine.

Long story short is that I'm very happy with the result.

---
The below notes on installation are more for my own reference:

1. Load the NixOS installer from a USB. 

I had the graphical installer, but due to needing a hardware patch ([hardware patches are here](https://github.com/nixos/nixos-hardware)), I had to make do with installing from the command line.

2. Get the disk drive ready.

Since I am dual booting Windows on this machine, I first freed up space on the Windows partition _in Windows_. Then I used `parted` within the NixOS installer to create a new partition in the free space for NixOS to live.

There's no need to touch the boot partition that Windows created. 

3. Connect to the internet.

Had a few issues with `wpa_supplicant` but `nmcli` is available and had internet up and running in a couple of minutes with:

``` sh
nmcli dev wifi connect <SSID> password <password>
```

4. Mount the new partition for NixOS.

If you run `nixos-install --help` it will explain that you need to mount the partition for NixOS on `/mnt`. However, it doesn't mention the boot partition which needs to be mounted at `/mnt/boot`. This _is_ mentioned [in the NixOS manual](https://nixos.org/manual/nixos/stable/#sec-installation-manual-installing).

Here are the instructions copied for convenience (they may change so you should read the up-to-date docs first):

``` sh
# mount /dev/disk/by-label/nixos /mnt
```

Then mount the boot partition. For myself in a dual boot Windows environment, this meant mounting the boot partition that Windows had created.

``` sh
# mkdir -p /mnt/boot
# mount /dev/disk/by-label/boot /mnt/boot
```

Now it's time to get ready to install NixOS! 

5. Generate the `hardware-configuration.nix`.

For each NixOS install, you need a `hardware-configuration.nix` which is unique to the machine and can be generated through `nixos-generate-config --dir /path/to/tmp/dir`. Without a temporary dir it will default to `/etc/nixos/hardware-configuration.nix` which is the default place the `nixos-install` tool looks for config. 

6. Clone my nix config

I actually prepared the directory ahead of time. I also made sure I had [the hardware patch](https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x1/10th-gen) so that I'd be able to launch a graphical display straight away as soon as NixOS was installed.

The only steps here were to clone the repo and copy (`cp -R`) the `hardware-configuration.nix` to the right location in the local copy. 

NOTE: I could have run `nixos-install --flake git+https://www.github.com/Ninju/nixconfig` but that means I'd have to have first uploaded my `hardware-configuration.nix` to my repo. It seemed overall easier to keep a local copy of the repo and add the hardware config later, once I have a proper NixOS installation up and running.

7. Run `cd /mnt && nixos-install --flake ./path/to/local/flake#aw-rvu-x1c10`

Then I let NixOS get on with it!

Soon enough. I have a working machine that launches into a computer, setup just the way I like it. Well, not quite, because there is some user level config in `./home-manager` which I haven't run at this stage. But that's just another easy one-liner.

There are kinks in my setup that this has uncovered for sure. But nothing major, and with a handful of commands I had a totally viable machine setup exactly the way I like it.

The most time consuming part, by far, was partitioning the drive. It's been a few years since I've done that and I'm always worried about messing something up.

Overall I was really impressed by the speed and ease by which I was able to get another machine up and running. 

TODOs:
* Change default session to _NOT_ be i3 _OR_ improve the system level i3 config (all/most i3 config is currently specified at user level)
* Do something about the tiny font sizes
* Does a developer shell for the installer make sense? What could I have made easier? (probably nothing.. it was pretty easy!)
