# nixos  

  
- Hosts file config to my new nixos installs found at::: https://github.com/StevenBlack/hosts  
  
===    
  

===  
  
https://drakerossman.com/blog/wayland-on-nixos-confusion-conquest-triumph  
  
nixos-rebuild --flake .#jtower switch  
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
  


