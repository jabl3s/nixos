
{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
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
  security.rtkit.enable = true;
  security.polkit.enable
  console = { earlySetup = true; keyMap = "uk"; };
  networking.extraHosts = let hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
  hostsFile = builtins.fetchurl hostsPath;
  in builtins.readFile "${hostsFile}";
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    allowedUDPPortRanges = [
      { from = 4000; to = 4007; }
      { from = 8000; to = 8010; }
    ];
  };
  networking.hostName = "jtower";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
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
      forceFullCompositionPipeline = true; #=>pop os has forceCompositionPipeline no "full"
      nvidiaSettings  = true;
      powerManagement = {
        enable      = true;
        finegrained = false;
      };
      open = true;
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
      nvidiaPatches = true;
      xwayland.enable = true;
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
    networkmanager networkmanagerapplet iwd libnotify xwayland wayland openssh-client
    pciutils usbutils wget file unzip gimp alsa-utils polkit-kde-agent  
    wl-clipboard wol wmctrl solaar konsole soundux noisetorch easyeffects
    (pkgs.waybar.overrideAttrs (oldAttrs:{ mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"]; }))
    rofi-wayland swww dunst kitty
  # Development
    tmux sshpass git lxpolkit
    (python3.withPackages(ps: with ps; [       
      tk tkinter pandas requests numpy
      pendulum pillow moviepy pyqt5 pyqt6
      pytest #briefcas
      ]))
     (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
      bbenoist.nix
      ms-python.python
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-ssh
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
        name = "remote-ssh-edit";
        publisher = "ms-vscode-remote";
        version = "0.47.2";
        sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
      }];})
    ## Beeware dependencies libgirepository1.0-dev gir1.2-webkit2-4.0 build-essential pkg-config python3-dev python3-venv libcairo2-dev libcanberra-gtk3-module
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
  systemd.services = {
    # https://github.com/NixOS/nixpkgs/issues/103746
    "getty@tty1".enable  = false;
    "autovt@tty1".enable = false;
  };
  powerManagement.cpuFreqGovernor = "ondemand";
}
