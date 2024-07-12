
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
  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };
  # Remove sound.enable or set it to false if you had it set previously, as sound.enable is only meant for ALSA-based configurations
  sound.enable=false;
  # rtkit is optional but recommended
  security.rtkit.enable = true;
  console = { earlySetup = true; keyMap = "uk"; };
  networking.extraHosts = let hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
  hostsFile = builtins.fetchurl hostsPath;
  in builtins.readFile "${hostsFile}";
  networking.hostName = "jtower";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
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
      forceFullCompositionPipeline = true; #=>pop os has forceCompositionPipeline no "full"
      nvidiaSettings  = true;
      powerManagement = {
        enable      = false;
        finegrained = false;
      };
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    pulseaudio.enable = false;
  };
  services.openssh.enable = false;
  services.printing.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.xserver = { # xorg
    enable               = true;
    videoDrivers = [ "nvidia" ];
    layout = "gb";
    xkbVariant = "";
    displayManager       = {
      autoLogin  = { enable = true; user = "j"; };
      gdm.enable = true;
    };
  };
  services.gvfs.enable = true ;
  services.tumbler.enable = true;  
  ##services.xserver.displayManager.defaultSession = "plasmawayland";
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };
  xdg.portal.enable=true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  programs = {
    thunar.enable = true;
    nix-ld.enable = true; # https://unix.stackexchange.com/a/522823
    steam.enable = true;
    hyprland = {
      enable = true;
      xwayland.enable = true; # x translation layer
    };
  };
  users.users.j = { # Define a user account. Don't forget to set a password with ‘passwd’ from nixos-enter.
    isNormalUser = true;
    description = "j";
    extraGroups = [ "networkmanager" "wheel" ];
  };
  nixpkgs.config.allowUnfree = true;  
  environment.systemPackages = with pkgs; [
  # Base
    networkmanager networkmanagerapplet iwd libnotify xwayland wayland
    pciutils usbutils wget file unzip gimp alsa-utils polkit-kde-agent sshguard 
    wl-clipboard wol wmctrl solaar konsole soundux noisetorch easyeffects
    (pkgs.waybar.overrideAttrs (oldAttrs:{ mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"]; }))
    rofi-wayland swww dunst kitty
  # Gaming
    lutris firefox-wayland discord wineWowPackages.staging wineWowPackages.waylandFull
    winetricks
  ];
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };
  system.stateVersion = "23.05"; # Did you read the comment?
  powerManagement.cpuFreqGovernor = "ondemand";
}
