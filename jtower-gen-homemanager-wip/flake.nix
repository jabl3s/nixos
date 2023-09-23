{
  description = "flake for jtower with Home Manager enabled featuring a Wayland Sway WM";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      jtower = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./greetd.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.j = { pkgs, ... }: {
              home.username = "j";
              home.homeDirectory = "/home/j";
              programs.home-manager.enable = true;
              home.packages = with pkgs; [
                iwd
                networkmanager
                thunderbird
                keepassxc
                mako
                wl-clipboard
                shotman
                firefox
              ];
              wayland.windowManager.sway = {
                enable = true;
                config = rec {
                  modifier = "Mod4"; # Super key
                  terminal = "alacritty";
                  output = {
                    "Virtual-1" = {
                      mode = "3440x1440@60Hz";
                    };
                  };
                };
                extraConfig = ''
                  bindsym Print               exec shotman -c output
                  bindsym Print+Shift         exec shotman -c region
                  bindsym Print+Shift+Control exec shotman -c window

                  output "*" bg /etc/foggy_forest.jpg fill
                '';
              };
              home.stateVersion = "23.05";
            };
          }
        ];
      };
    };
  };
}


