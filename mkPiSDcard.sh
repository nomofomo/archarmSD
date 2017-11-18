#!/bin/bash

RED='\033[0;41;30m'
STD='\033[0;0;39m'
disk='sdx'
pi='0'
archarmurl='invalid url'
archarminfourl='invalid url'



menutop(){
  echo "~~~~~~~~~~~~~~~~~~~~~"
	echo " PiBuilder 1.0"
	echo "~~~~~~~~~~~~~~~~~~~~~"
}
clear0(){
  clear
  menutop
}
cexit(){
  echo "Hasta La Bye Bye"
  exit 0
}
pause(){
 read -p "Press [Enter] key to continue..." fackEnterKey
}

one(){
  lsblk
  echo 'Which Disk? (sdX)'
  read disk
       # pause
}

two(){
  echo 'Select Pi Version? (1, 2, 3.32, 3.64)'
  read pi
  case $pi in
    1)
      archarminfourl='https://archlinuxarm.org/platforms/armv6/raspberry-pi'
      archarmurl='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-latest.tar.gz' ;;
    2)
      archarminfourl='https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2'
      archarmurl='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz' ;;
    3.32)
      archarminfourl='https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3'
      archarmurl='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz' ;;
    3.64)
      archarminfourl='https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3'
      archarmurl='http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-3-latest.tar.gz' ;;
    *)
      echo -e "Invalid Choice, try again"
      two ;;
  esac
       # pause
}

three(){
  clear0
  echo "For More Info: $archarminfourl"
  pause
  clear0
  echo "Setting Up SD Card for a Raspberry Pi $pi on disk /dev/$disk"
  echo
	echo "Downloading: $archarmurl"
  echo
  echo wget -N http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz
  echo
  echo "Download Complete. THE NEXT STEP WILL WIPE EVERYTHING ON DISK /dev/$disk"
  pause
  clear0
  echo "./.formatdisk"
  echo "Disk Partitioned. Formatting Disk"
  pause
  clear0
  echo "sudo mkfs.vfat -n BOOT /dev/{$disk}1"
  echo "sudo mkfs.ext4 -L ARCH /dev/{$disk}2"
  echo "Disk Formatted. Expanding Filesystem"
  pause
  clear0
  echo "mkdir root boot"
  echo "sudo mount {$disk}1 boot"
  echo "sudo mount {$disk}2 root"
  echo sudo bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root && sync
  echo "Copying boot folder to BOOT partition ({$disk}1)"
  echo mv root/boot/* boot
  echo "Setup Complete, Displaying Contents"
  pause
  clear0
  echo ls root boot
  echo "Process Complete"
  read -p "Unmount Disk (y/n)?" choice
  case "$choice" in
    y|Y )
      echo "Unmounting $disk"
      echo "sudo umount root boot"
      echo "rm -R root boot"
      clear0
      echo "You can now insert the SD Card into your pi"
      echo
      echo "Default Users:  alarm:alarm | root:root "
      echo
      echo "CHANGE YOUR ROOT PASSWORD (and probably delete alarm and create a new one)"
      cexit ;;
    n|N )
      echo "Process Complete, $disk remains mounted"
      cexit ;;
    * ) echo "Invalid Choice, try again";;
  esac
}

# function to display menus
show_menus() {
	clear0

	if [[ $disk = "sdx" ]]; then
    echo -e "1) \e[4mSelect Disk\e[24m"
    echo "X) Select Pi"
    echo "X) Run Setup"
  elif [[ $pi = 0 ]]; then
    echo -e "1) Disk Selected: \e[32m/dev/$disk\e[0m"
    echo -e "2) \e[4mSelect Pi\e[24m"
    echo "X) Run Setup"
  else
    echo -e "1) Disk Selected: \e[32m/dev/$disk\e[0m"
    echo -e "2) Pi Selected: \e[32m$pi\e[0m"
    echo -e "3) \e[4mRun Setup\e[24m"
  fi
	echo "4) Cancel"
}

read_options(){
	local choice
  if [[ $disk = "sdx" ]]; then
    echo "Select Number: (default 1)"
  elif [[ $pi = '0' ]]; then
    echo "Select Number: (default 2)"
  else
    echo "Select Number: (default 3)"
    echo
    echo "========================================"
    echo
  fi
	read choice
  if [[ $disk = "sdx" ]]; then
    case $choice in
      1) one ;;
      4) cexit ;;
      *) one ;;
    esac
  elif [[ $pi = '0' ]]; then
    case $choice in
  		1) one ;;
  		2) two ;;
  		4) cexit ;;
  		*) two ;;
  	esac
  else
    case $choice in
  		1) one ;;
  		2) two ;;
      3) three ;;
  		4) cexit ;;
  		*) three ;;
  	esac
  fi
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
#trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do

	show_menus
	read_options
done
