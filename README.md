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

### Organisation
Goals:

1. Keep packages that are related together and make it obvious they are grouped in a meaningful way
2. To be able to easily pick and choose the packages I want and need
3. Easily switch to window managers I'm likely to use again, without having to dig through old git commits 

For this one of the key choices so far has been to break my system config into smaller modules. 

Example with i3:
1. i3 is broken into an i3 module that includes all the packages I need when running i3. This keeps related packages together and makes it obvious they are grouped meaningfully, in this case as dependencies of i3 (Goal 1).
2. The i3 config is only included if i3 is enabled. This means in the top-level config, I can flip i3 and all associated services/packages on and off easily (Goal 2). As a side note, I prefer to keep the `enable = true/false` in the top level `configuration.nix` so it's easy to get an overview of what is enabled. I also prefer using dot syntax `services.xserver.windowManager.i3.enable = true` so that it works nicely with line processing tools, but this is something I like doing in any language..
3. If I don't need the i3 config, I simply disable it, but do not delete the code. The config may be later useful. Because I only include the packages when the enable flag is true, packages aren't built unnecessarily so I get to easily temporarily disable things (Goal 3) without adding cruft to the actual build.

# Actual experience -- one command install on new machines

The dream is one command to completely reconfigure your machine exactly how you like it.. I figured this section might be a good place to put my experiences and record TODOs.

## X1 Carbon 10th Gen
I recently was equipped with a new machine at work and had the chance to try rolling out my config to a new machine.

Long story short is that the results were extremely satisfying.

I'm never usually this organised with my config, meaning there is usually a lot of clean-up to do. However, this time, the process was very smooth.

The below notes on installation are more for my own reference:

1. Load the NixOS installer from a USB. 

I had the graphical installer, but due to needing a hardware patch ([hardware patches are here](https://github.com/nixos/nixos-hardware)), I had to make do with installing from the command line.

2. Get the disk drive ready.

Since I am dual booting Windows on this machine, I first freed up space on the Windows partition _in Windows_. Then I used `parted` within the NixOS installer to create a new partition in the free space.

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

First though, I needed to generate a `hardware-configuration.nix`, which is unique to each machine. I created a temporary directory and then ran `nixos-generate-config --dir /path/to/tmp/dir`.

6. Clone my nix config

Luckily, my developer shell has git installed. I ran `nix develop https://www.github.com/Ninju/nixconfig` and there (g)it was. I'm not sure if the NixOS installer comes with git as I ran the develop command "for fun" and I don't think a developer shell is that useful within the installer, so I'll likely remove it for next time.

NOTE: I could have run `nixos-install --flake git+https://www.github.com/Ninju/nixconfig` but that means I'd have to have first uploaded my `hardware-configuration.nix` to my repo. It seemed overall easier to keep a local copy of the flake for now, and add the hardware config once I have a proper NixOS installation up and running.

Last step was to copy (`cp -R`) the existing machine config and swap out the hardware config for the hardware config that was generated on my new machine. 

I actually prepared the directory ahead of time. I also made sure I had [the hardware patch](https://github.com/NixOS/nixos-hardware/tree/master/lenovo/thinkpad/x1/10th-gen) so that I'd be able to launch a graphical display straight away once NixOS is installed. Small steps that made installation much faster and easier.

7. Run `cd /mnt && nixos-install --flake ./path/to/local/flake#aw-rvu-x1c10`

I have two outputs (at time of writing) for NixOS systems: one is my old machine at aw-rvu-x1c5 (X1 Carbon 5th Gen) and the new one is aw-rvu-x1c10 (X1 Carbon 10th Gen). 

For initial install, I specify the output I want to build but in future it will use the hostname of the machine (planned to be aw-rvu-x1c10).

Then I let NixOS get on with it!

Soon enough. I have a working machine that launches into i3, just the way I like it. Well, not quite because I have my i3 config in home-manager. Next was home-manager; another easy one-liner.

There are kinks in my setup that this has uncovered for sure. But nothing major, and with a handful of commands I had a totally viable machine setup exactly the way I like it (more like, the way it's specified so far but not the point).

So that's it!

The most time consuming part, by far, was partitioning the drive. It's been a few years since I've done that and I'm always worried about messing something up.

Overall I was really impressed by the speed and ease by which I was able to get another machine up and running. Definitely helps to be organised in this regard as I've let config get messy in the past, with no clear structure, and then it's ... less smooth.

The Nix dream is a one command install of a brand new machine, and for me it worked out very well indeed. :)

TODOs:
* Change default session to _NOT_ be i3 _OR_ improve the system level i3 config
* Insert something about the tiny font sizes
* Does a developer shell for the installer make sense? What could I have made easier? (probably nothing.. it was pretty easy!)
