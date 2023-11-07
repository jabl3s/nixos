Try using: https://mynixos.com/  
.  
# 1) nixos remote server install -  
Setup nixos via ssh using nixos-anyhere and a provided configuration.nix with diskio using zfs partitioning...  
# 2) nixos for development, games & stream - 
See jtower-gen-hyprland for current development, games & stream setup working configuration.nix; dev: dev in python seems fine for now issues with non extensible solumes or something when developing games issues may arise, gamming: consistent 240 fps with protonGE8-16 in most games, stream: black screen most things.  
((might submit feature reqeust of obs to capture workspaces, I use 3 workspace, gaming (fullscreen), social (discord,firefox) and dev (vscode, kitty/shell, firefox), need gaming and dev workspace capture and probs no social workspace capture.))    
.  
.  
.  
## nixos audio:
see: https://github.com/mikeroyal/PipeWire-Guide#wayland-development  
==> (1-soundboard cus y not) https://soundux.rocks/  (2-noise cancel across all programs) https://github.com/noisetorch/NoiseTorch  (3-pipewire controls) https://github.com/wwmm/easyeffects  
(for now max gain lower lower output vol should effectively noise cancel - allout) (sound ^ some exp divide by fixed val factor vs superimposed back noise program), since noisetorch is expecting pulseaudio, and im going pipewire->alsa and pipewire->pulse it wont seem to configure, will just increase gain in easyeffects reduce output,,, => easyeffects has noise reduction effect too lul.     
.  
.  
.  
## nixos security:  
1) I have polkit (rate limit?) and ssh (server+agent) enabled, perhaps jus ssh-agent needed :accessibility:    
2) wayland graphics is secure protocol vs x 👍 so long as :accessibility: isnt compromised above. However, x translation layer in my conf for steam, vscode... firefox seems full wayland.        
3) no encrypted drive might have plain text pass...
4) see: https://svn.python.org/www/trunk/pydotorg/pycon/papers/conch.html from https://hackage.haskell.org/package/ssh => can give haskell a try have done some f# ocaml in the past and enjoyed those, plus seems cleaner then python for this functional use-case... No oop needed. see here: https://search.nixos.org/packages?channel=23.05&show=haskellPackages.ssh&from=0&size=50&sort=relevance&type=packages&query=ssh ((==> nixos configuration tab, should prevent client reverse ssh))
5) rebuild switch, delete prior gens, dc cmos psu ram hold power button + spam it however long, reinsert ram from 4 taken into 4 empty, reboot into new system.
6) Hosts file config to my new nixos installs found at::: https://github.com/StevenBlack/hosts, plus it has additional stuff to essentially what is 127.0.0.1 protection/added-firewall, see my phase_projects dev on how someone might use this to expose stuff not just use for brackets dev or wtvs I was doing in phaser 3 yrs ago with a node server on localhost, no exp with the hostfile like this canadian guy he done some super work there...  
.  
.  
.  
## Useful commands    
``` bash
nix-collect-garbage -d
```
``` + ``` 
``` bash
nix-env --profile /nix/var/nix/profiles/system --delete-generations 1 2 3 4 5 6 7 8 9 10 11 13 14 15
```
.  
.  
.  
## === OLD SETUP WITH GNOME ===     
![current setup](./images/nixcurrent.png)
- Nix os on an intel x86_64 chipset with nvidia graphics is not great for games but had ow2 running at 144 fps on protonGE-8-2 with interesting setup bugs throughout entire process => no return to pop-os for now using jtowergen12 .nix for gamez n code.     
- ``` Bash
  sudo nano /etc/nixos/configuration.nix
  ```
- ``` Bash
  nixos-rebuild switch
  ```
  ((Doesnt always require reboot unless kernel or app version))
- ```
  mv /etc/nixos/nixos/.* /etc/nixos/
  mv /etc/nixos/nixos/* /etc/nixos/
  ```
  ((should catch hidden no dotglob mod, fun name hehe))  
- 1) ``` sudo su - ```
- 2) ``` code /etc/nixos --no-sandbox --user-data-dir /home/j ```
  
=== General clean up of nixos  
  
nix-env --list-generations --profile /nix/var/nix/profiles/system  
gen 12 is gamming safe  
nix-env --profile /nix/var/nix/profiles/system --switch-generation 12  
nix-env --profile /nix/var/nix/profiles/system --delete-generations 1 2 3 4 5 6 7 8 9 10 11 13 14 15   
  
===  
  
Retry with "force composition pipeline" not "force full composition pipeline" graphics config to avoid blackscreen, but for now am using full...  
See the xorg file for Xserver specific settings ((MISSING THE YB222 6-bit colour profile and such tho :c, forgot to snag it from pop os)), xorg config applies if not using wayland but might cross-over need to fig this part out with the whole xwayland translation layer thing going on, hyprland frees some of this with firefox but steam vscode n such seems to be using translation. Also, protonGE-8-2 to get mouse and no blackscreen sweet spot still applies to X as well as wayland. Having full force pipeline gives buttery smooth experience with next to no graphical errors so far in gnome, but not in plasma5/kde so remember when returning back to gnome run ``` dconf reset /org/gnome/desktop/interface/cursor-theme ``` if cursor is a white box bug.       
  
===  
  
If you want to make the change permanent, you can add the shopt command to your shell's   configuration file. For example, if you are using the Bash shell, you can add it to your   
~/.bashrc file:  
  
``` bash
echo "shopt -s dotglob" >> ~/.bashrc
```
```  bash
nix run nixpkgs#betterdiscordctl install --extra-experimental-features nix-command --extra-experimental-features flakes
```  
