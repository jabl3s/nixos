# nixos  
### nixos-anywhere ==>  
https://github.com/numtide/nixos-anywhere  
### diskio ==>  
https://github.com/nix-community/disko/tree/master  
  
check some of the lvm example options for root partition volume mounts (also theres zfs fs types too)    
((probably not going to need swap on most of my machines))  
Boot partition in examples is EF00 but only 100MiB, classically 512MiB for grub, need to check why this is...   
This the example to use for my current use case  https://github.com/nix-community/disko/blob/master/example/hybrid.nix  
N.B. that the .../by-id/... part in the dir value will change on drive every re-insert, /dev/sdX try to aquire info on UUID specificatiion definition as to not incorectly configure wrong drive  
  
### Need initial remote machine tools for setup   
