nixos-rebuild switch ((--install-bootloader))  
  
===  
  
Working nix for overwatch, note ((proton ge 8-2)) is the optimum for the non-mouse click to any loss of mouse after death / no steam instance running sweet spot for wayland...    
sudo tar -xf /home/j/Downloads/GE-Proton*.tar.gz -C /home/j/.steam/root/compatibilitytools.d/  
  
===    
  
Was wayland initially but now am using x. Which has diff graphical errors with steam...    
  
===  
  
/home/j/.config/hypr/hyprland.conf  
hyprland comment out the "monitor=,preferred,auto,auto" or try "monitor=,highres,auto,1"   
add:::  bind=$mainMod, S, exec, rofi -show drun -show-icons
  Few more further steps at end of this vod:::  
https://www.youtube.com/watch?v=61wGzIv12Ds  
