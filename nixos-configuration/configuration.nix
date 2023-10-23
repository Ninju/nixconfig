# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ./xmonad.nix
    ./i3.nix
    ./kmonad.nix
    ./gpg.nix
  ];

  fonts.fonts = with pkgs; [
    jetbrains-mono
    nerdfonts
  ];

  virtualisation.docker.enable = true;

  # --- BLUETOOTH SETTINGS
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # --- BOOT SETTINGS ---
  # Only show N most recent generations in the boot menu
  # (useful to prevent running out of disk space)
  boot.loader.systemd-boot.configurationLimit = 50;

  boot.loader.efi.canTouchEfiVariables = true;

  # --- DESKTOP ENVIRONMENT ---
  services.xserver.enable = true;

  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.windowManager.xmonad.enable = true;
  services.xserver.windowManager.i3.enable = true;

  services.xserver.displayManager = {
    defaultSession = "none+i3";
    sddm = {
      enable = true;
    };
  };

  security.pam.services.sddm = {
    name = "kwallet";
    enableKwallet = true;
  };

  services.fprintd.enable = true;

  #
  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = false;
  services.xserver.displayManager.autoLogin.user = "alex";


  # --- KEYBOARD SETTINGS ---
  services.kmonad.enable = true;
  services.xserver.layout = "gb";

  # --- CONSOLE SETTINGS ---
  # Bigger TTY fonts...
  # Can scale up i3 bar to 2x by changing dpi value to 180 (90 x 2)
  services.xserver.dpi = 90;
  environment.variables = {
    GDK_SCALE = "1.0";
    GDK_DPI_SCALE = "1.0";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=1.0";
  };

  console = {
    earlySetup = true;
    font = "ter-i32b";
    # font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
    packages = [ pkgs.terminus_font ];
    keyMap = "uk";
  };

  # --- NIX SETTINGS ---
  nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
          experimental-features = nix-command flakes
  '';
  #
  nixpkgs.config.allowUnfree = true;


  # --- SSH ---
  programs.ssh.startAgent = true;

  # --- NETWORK SETTINGS
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # --- LOCALES SETTINGS
  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplip ];

  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # --- USER SETTINGS ---
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alex = {
    isNormalUser = true;
    description = "Alex Watt";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      vim
      git
    ];
  };

  # --- SYSTEM PACKAGES
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = [
    pkgs.slack
    pkgs.zoom-us

    pkgs.kwallet-pam
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
