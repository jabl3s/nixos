{ config, pkgs, ... }:

{ 
  # Boot
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
      extraConfig = "DeviceScale=2";
    };
    initrd = {
      kernelModules = [ "nvme" "ahci" ];
      network.enable = true;
      systemd.enable   = true;
    };
    blacklistedKernelModules = [ "nouveau" "i915" ];
    kernelParams = [ "quiet" "nomodeset" ];
  };
  imports =
    [
      ./hardware-configuration.nix
    ];
  # Networking
  networking.extraHosts = let hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
  hostsFile = builtins.fetchurl hostsPath;
  in builtins.readFile "${hostsFile}";
  networking.hostName = "jtower";
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/London";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  # Services and programs
  programs = {
    nix-ld.enable = true; # https://unix.stackexchange.com/a/522823
    steam.enable = true;
    hyperland = {
      hidpi = true;
      enable = true;
      nvidiaPatches = true;
      xwayland.enable = true;
    };
  };
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  xdg.portal.enable=true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services = {
    dleyna-renderer.enable = false;
    dleyna-server.enable = false;
    power-profiles-daemon.enable = false;
    telepathy.enable = false;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa   = {
        enable       = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
  # Configure console keymap
  console = {
    earlySetup = true;
    keyMap = "uk";
  };
  # Enable sound with pipewire.
  sound.enable = true;
  # Hardware
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
    pulseaudio         = { enable = false; };
  };
  security.rtkit.enable = true;
  users.users.j = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [];
  };
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  environment.systemPackages = with pkgs; [
    nano
    discord
    firefox-wayland
    (pkgs.waybar.overridAttrs (oldAttrs:{
    mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
    }))
    kitty
    rofi-wayland
    firefox
    swww
    dunst
    libnotify
    wget
    waybar
    xwayland
    wayland
    solaar
    file
    unzip
    wl-clipboard
    pciutils
    usbutils
    wol
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
  # System settings
  powerManagement.cpuFreqGovernor = "ondemand";
  system.stateVersion = "23.05";
  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };
}