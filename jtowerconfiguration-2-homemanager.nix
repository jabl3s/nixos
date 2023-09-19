{ config, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
    ];
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
        experimental-features = nix-command flakes
    '';
  };
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
        };
      };
    initrd = {
      kernelModules          = [ "nvme" "ahci" ];
      network                = {
        enable = true;
      };
      systemd = {
        enable   = true;
      };
    };
    blacklistedKernelModules = [ "nouveau" "i915" ];
    kernelParams = [ "quiet" "nomodeset" ];
  };
  networking = {
    networkmanager.enable = true;
    hostName = "jtower"; # edit this to your liking
  };

  # QEMU-specific
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # locales
  # https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
  time.timeZone = "Euroupe/London";
  i18n.defaultLocale = "en_GB.UTF-8";

  # wayland-related
  # programs.sway.enable = true; # commented out due to usage of home-manager's sway
  security.polkit.enable = true;
  hardware.opengl.enable = true; # when using QEMU KVM

  # audio
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;

  # user configuration
  users.users = {
    j = { # change this to you liking
      createHome = true;
      isNormalUser = true; # https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/config/users-groups.nix#L100
      extraGroups = [
        "wheel"
      ];
    };
    root = {
      extraGroups = [
        "wheel"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "DroidSansMono" ]; })
    dejavu_fonts # mind the underscore! most of the packages are named with a hypen, not this one however
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];


  # installed packages
  environment.systemPackages = with pkgs; [
    # cli utils
    git
    curl
    wget
    vim
    htop

    # browser
    chromium

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

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
    ];
  };

  system.stateVersion = "23.05";
}
