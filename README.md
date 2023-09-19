# nixos  
### nixos-anywhere ==>  
https://github.com/numtide/nixos-anywhere  
### diskio ==>  
https://github.com/nix-community/disko/tree/master  
  
Check some of the lvm example options for root partition volume mounts (also theres zfs fs types too) Probably not going to need swap on most of my machines.   
Boot partition in examples is EF00 but only 100MiB, classically 512MiB for grub, need to check why this is...   
This the example to use for my current use case  https://github.com/nix-community/disko/blob/master/example/hybrid.nix  
N.B. that the .../by-id/... part in the dir value will change on drive every re-insert, /dev/sdX. Instead try to aquire info on UUID specificatiion definition as to not incorrectly configure wrong drive by mistake, mac address of usb?  
Also note that mount for EF00 is at /boot, and not /boot/efi, in arch ive needed / to access the kernal images at /boot and mounting EF00 at /boot prevents this access, so /boot/efi has been used in the past with success.  

.nix files to use .envs, for example in the command below...   
sudo nix run github:nix-community/disko -- --mode disko /tmp/disko-config.nix --arg disks '[ "/dev/nvme0n1" ]'  
with my nix imma need do something like the below .nix file...  
{ disks ? [ "/dev/vdb" ], ... }: {  
 disk = {  
  vdb = {  
   device = builtins.elemAt disks 0;  
   type = "disk";  
   content = {  
    type = "gpt";  
    partitions = {  
     ESP = {
      size = "100M";
      content = {
       type = "filesystem";
       format = "vfat";
       ...   
         
If I have a .env I could somehow parse to the run command for automation of formatting any disks on mass, still need to figure out the /dev/sdX issue on drive re-insert though and how drive UUID might help but is often set during the partitioning process...(usb mac address)          
  
### Need initial nix machining tools for drive setup, plus root ssh if remote install/configure of drives and os packages   
  
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
  


