# nixos  

  
- Try adding this section below for hosts file config to my new nixos install found at::: https://github.com/StevenBlack/hosts  
{  
  networking.extraHosts = let  
    hostsPath = https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;  
    hostsFile = builtins.fetchurl hostsPath;  
  in builtins.readFile "${hostsFile}";  
}  

===  
  
Working nix for overwatch, note ((proton ge 8-2)) is the optimum for the non-mouse click to any loss of mouse after death / no steam instance running sweet spot for wayland...  
sudo tar -xf GE-Proton*.tar.gz -C /home/j/.steam/root/compatibilitytools.d/  

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
  


