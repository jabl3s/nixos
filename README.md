# nixos  
  
- Hosts file config to my new nixos installs found at::: https://github.com/StevenBlack/hosts

=== General clean up of nixos  
  
nix-env --list-generations --profile /nix/var/nix/profiles/system  
gen 12 is safe  
nix-env --profile /nix/var/nix/profiles/system --switch-generation 12  
nix-env --profile /nix/var/nix/profiles/system --delete-generations 1 2 3 4 5 6 7 8 9 10 11 13 14 15  
  
===  
ssh-keygen  
((put .pub in the git hub acc keys))  
git clone ((ssh link here))  
((git pull))  
git add .  
git commit -m "whatever-comment"  
git push origin main  
  
===  
  
Retry with "force conmposition pipeline" not "force full composition pipeline" graphics config to avoid blackscreen...  
See the xorg file for Xserver specific settings, if not using wayland in othernotes section. Also, protonGE-8-2 to get mouse and no blackscreen sweet spot still applies to X as well as wayland.    
