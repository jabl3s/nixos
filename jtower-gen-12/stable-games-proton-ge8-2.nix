# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
    };
    plymouth = {
      enable = true;
      extraConfig = "DeviceScale=1";
    };
    initrd = {
      kernelModules = [ "nvme" "ahci" ];
      network.enable = true;
      systemd.enable   = true;
    };
    blacklistedKernelModules = [ "nouveau" "i915" ];
    kernelParams = [ "quiet" "nomodeset" ];
  };
  # Networking
  networking.extraHosts = let hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
  hostsFile = builtins.fetchurl hostsPath;
  in builtins.readFile "${hostsFile}";
  networking.hostName = "jtower";
  networking.networkmanager.enable = true;
  #networking.wireless.iwd.enable = true;
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Set your time zone.
  time.timeZone = "Europe/London";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  # Hardware
  sound.enable = true;
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable   = false;
    cpu.intel          = { updateMicrocode = true; };
    keyboard.uhk       = { enable = true; };
    opengl             = {
      driSupport      = true;
      driSupport32Bit = true;
      enable          = true;
      extraPackages   = with pkgs; [ libvdpau-va-gl vaapiIntel vaapiVdpau nvidia-vaapi-driver intel-media-driver ];
    };
    nvidia             = {
      modesetting.enable = true;
      nvidiaSettings  = true;
      powerManagement = {
        enable      = false;
        finegrained = false;
      };
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    pulseaudio.enable = false;
  };
  # Enable the X11 windowing system.
  services.xserver = {
    enable               = true;
    videoDrivers = [ "nvidia" ];
    layout = "gb";
    xkbVariant = "";
    desktopManager.gnome = { enable = true; };
    displayManager       = {
      autoLogin  = { enable = true; user = "j"; };
      gdm.enable = true;
    };
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };
  
  # Configure console keymap
  console = {
    earlySetup = true;
    keyMap = "uk";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.j = {
    isNormalUser = true;
    description = "j";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    networkmanager
    iwd
    libnotify
    xwayland
    wayland
    lutris
    pciutils
    usbutils
    firefox-wayland
    kate
    file 
    unzip 
    wl-clipboard 
    pciutils 
    usbutils
    wol
    wmctrl
    kate
    wget  
    discord
    solaar 
    lutris
    wineWowPackages.staging
    wineWowPackages.waylandFull
    winetricks
    git
    (vscode-with-extensions.override {
     vscodeExtensions = with vscode-extensions; [
       bbenoist.nix # syntax highlight for .nix files in vscode
     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
       {
         name = "search-crates-io";
         publisher = "belfz";
         version = "1.2.1";
         sha256 = "sha256-K2H4OHH6vgQvhhcOFdP3RD0fPghAxxbgurv+N82pFNs=";
         # sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
       }
     ];
    })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
   services.openssh.enable = true;

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
  system.stateVersion = "23.05"; # Did you read the comment?
  powerManagement.cpuFreqGovernor = "ondemand";
  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };
}
