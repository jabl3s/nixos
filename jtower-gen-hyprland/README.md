# Step by step install guide for nvidia graphics for hyprland/wayland games on linux.    
  
1) Get a bootable usb setup from nixos, I used the kde 64 bit iso one and burn it to a sandisk usb then booted into the nomodeset installer, note kde has issues with nvidia where as gnome3 or hyperland dont on my nix ```configuration.nix```.  
2) Follow through the installer to get your desired drive setup with its first nix filesystem, note close the installer connect to the internet then rerun from the start menue, also chose blowfish encryption to move the install process along
3) Mount the root and boot drives then nixos-enter: Typically for nvme drive its ```mount /dev/nmvemn1p2 /mnt``` and ```mount /dev/nvmen1p1 /mnt/boot``` then ```nixos-enter```
4) Edit the mounted filesystems nix with something like nano: ```nano /etc/nixos/configuration.nix``` ((Ctrl + k))-to delete old lines and replace with either mine or another desired nix file then run ```nixos-rebuild --install-bootloader switch``` -> might throw error but trust es good npnp.
5) After boot configure hyprland, I followed this video here: https://youtu.be/61wGzIv12Ds?si=Y5VgnxM-JjrBYICj
.  
.  
.  
.  
  
====  
If no kitty or notification covers prompt use Ctrl+Alt+F2 to root console window...  
/home/j/.config/hypr/hyprland.conf  
hyprland comment out the "monitor=,preferred,auto,auto" or try "monitor=,highres,auto,1"   
add:::  bind=$mainMod, S, exec, rofi -show drun -show-icons
  Few more further steps at end of this vod:::  
https://www.youtube.com/watch?v=61wGzIv12Ds  
  
((if following video from Ctrl+Alt+F2 then sub /home/j for ~ cus am root))  

((If windows can be moved with mouse add to hyperland conf below for ALT + mouse window movement))
bindm=ALT,mouse:272,movewindow
bindm=ALT,mouse:273,resizewindow
