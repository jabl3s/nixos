# nixos    
![current setup](./images/nixcurrent.png)
- Nix os on an intel x86_64 chipset with nvidia graphics is not great for games but had ow2 running at 144 fps on protonGE-8-2 with interesting setup bugs throughout entire process => no return to pop-os for now using jtowergen12 .nix for gamez n code.     
- Hosts file config to my new nixos installs found at::: https://github.com/StevenBlack/hosts

=== General clean up of nixos  
  
nix-env --list-generations --profile /nix/var/nix/profiles/system  
gen 12 is gamming safe  
nix-env --profile /nix/var/nix/profiles/system --switch-generation 12  
nix-env --profile /nix/var/nix/profiles/system --delete-generations 1 2 3 4 5 6 7 8 9 10 11 13 14 15   
  
===  
  
Retry with "force conmposition pipeline" not "force full composition pipeline" graphics config to avoid blackscreen...  
See the xorg file for Xserver specific settings ((MISSING THE YB222 6-bit colour profile and such tho :c, forgot to snag it from pop os)), if not using wayland in othernotes section. Also, protonGE-8-2 to get mouse and no blackscreen sweet spot still applies to X as well as wayland.    
