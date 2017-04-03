#!/bin/bash
WHOMI=`whoami`
usercheck=$WHOMI
if [ $usercheck = *root* ]; then
	echo "You are root."
else
	echo "run script as root"
fi
        echo "sudo now will be installed. Ready? [y\n]"
	  read readyinp1
	  until [ $readyinp1 = y ]; do
	    echo 'Ready now? [y/n]'
	    read readyinp1
	  done
	echo `pacman -S sudo`
	echo "choose usrname for a new user"
	read usrname
	HOMEASK='create home directory in /home/ ? [y\n]'
	echo $HOMEASK
	read uinp
	  if [ $uinp = y ]; then
	    useradd $usrname -d
	  else
	    useradd $usrname
	  fi
	echo "Do you want to create basic directoris in /home/$usrname ?"
	echo '[y\n]?'
	read direcinp
	  if [ $direcinp = y ]; then
		mkdir /home/$ursname/{pictures,music,Downloads,documents,Desktop}
	  else
		echo " "
	  fi

	echo 'Do you want to configure locale? [y\n]'
	  read locan
	  if [ $locan = y ]; then
		echo 'RU/US locale is ok? [y\n] ATTENTION: only russian and en_US locales will be added automaticly, if you want some other 
locales, you will have to write them in next step (e.g. ro_RO.UTF-8). This part of script is unfinished and i highly recommend you to 
accept RU/US locales.'
			read ruusan
			if [ $ruusan = y ]; then
			  echo en_US.UTF-8 UTF-8 >> /etc/locale.gen
			  echo en_US ISO-8859-1 >> /etc/locale.gen
			  echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen
			  echo ru_RU.KOI8-R KOI8-R >> /etc/locale.gen
			  echo ru_RU ISO-8859-5 >> /etc/locale.gen
			  locale-gen
			else
			  until [ $locname = stop ]; do
			    echo 'Enter locale you want to add in format "en_US.UTF-8": (or type "stop" when you have enough)'
			    read locname
			    echo $locname UTF-8 >> /etc/locale.gen
			    echo "Locale $locname added"
			    echo "If you want to add more, type locale or type "stop" if you want to stop"
			  done
			locale-gen
			fi
		else
		  echo "Going to next step"
	  fi
          echo 'Which language do you want to set as system default? [ru\us]'
	read langan
	  if [ $langan = ru ]; then
		echo LANG=ru_RU.UTF-8 UTF-8 > /etc/locale.conf
		echo "russian locale set"
	  else
		echo LANG=en_US.UTF-8 UTF-8 > /etc/locale.conf
		echo 'US locale set'
		
	  fi		  
	echo -n 'Do you want configure groups by yourself, add to wheel(simple way) or choose nubmer of 
goups(if you now what you are doing)? [wheel,fewgroups,manual]'
	read groupinput
	    if [ $groupinput = wheel ]; then
		gpasswd -a $usrname wheel
		###CHECK THIS LATER###
		echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers
	    else
		if [ $groupinput = fewgroups ]; then
			until [ $gr1 = stop ]; do
				echo 'Enter the name of group or enter "stop" if do not want to add more 
groups'
				read gr1
				gpasswd -a $usrname $gr1
				echo "User $usrname was added to $gr1"
			done
	    	else
			 if [ $groupinput = manual ]; then
				echo "Do not forget to configure your groups later"
	    		fi
		fi
	fi
	echo 'Do you want to run graphical desktop on this system? [y\n]'
	read desk
	  if [ $desk = y]; then
		echo 'Xorg and xorg-xinit now will be installed. You may choose which packages to install, 
but if you are DO NOT NOW what are you doing - just press ener for defaults.'
		pacman -S xorg xorg-xinit
		echo 'X org is now installed. Which DE\WM do you want to use?'
		echo "1. gnome"
		echo "2. xfce4"
		echo "3. openbox"
		echo "4. i3"
		echo -n "Select your desktop [1,2,3 or 4]? "
		deskname = 5
		while [ $deskname -eq 4 ]; do
		read deskname
			if [ $deskname -eq 2 ] ; then
			  pacman -S xfce4
			  touch /home/$usrname/.xinitrc
			  echo "exec startxfce4" > /home/$usrname/.xinitrc
			  echo "xfce4 in now installed"
			else 
				if [ $deskname -eq 3 ] ; then
				  pacman -S openbox
				  touch /home/$usrname/.xinitrc
				  echo "exec openbox-session" > /home/$usrname/.xinitrc
				  echo "openbox is now installed"
				else
					if [ $deskname -eq 4 ] ; then
					  pacman -S i3
					  touch /home/$usrname/.xinitrc
					  echo "exec i3" > /home/$usrname/.xinitrc
						else
						if [ $deskname -eq 1 ] ; then
						  pacman -S gnome
						  touch /home/$usrname/.xinitrc
						  echo "exec gnome-session" > /home/$usrname/.xinitrc
						else
							echo "1. gnome"
							echo "2. xfce4"
							echo "3. openbox"
							echo "4. i3"
							echo -n "Select your desktop [1, 2, 3 or 4]? "
							deskname = 5
						fi
					fi
				fi
			fi
		done
		else
		echo "next step"
		fi
		echo "Do you want to install Desktop Manager?"
		echo '[y\n]?'
			read manans
			if [ $manans = y ] ; then
			  manach=4
			  while [ $manach -eq 4 ] ; do
				echo "Choose your DM"
				echo "1. gdm"
				echo "2. SLIM"
				echo "3. lightDM"
				echo -n "Which to install [1,2 or 3]? "
				read manach
				if [ $manach -eq 1 ] ; then
				  pacman -S gdm
				  systemctl enable gdm.service
				  echo "gdm installed"
				else
					if [ $manach -eq 2 ] ; then
					  pacman -S slim
					  systemctl enable slim.service
					  echo "SLIM installed"
					else
						if [ $manach -eq 3 ] ; then
						  pacman -S lightdm
						  systemctl enable lightdm.service
						  echo "lightDM installed"
						else 
							 echo "Choose your DM"
							 echo "1. gdm"
							 echo "2. SLIM"
							 echo "3. lightDM"
							 echo -n "Which to install [1, 2 or 3]? "
							 read manach
						fi
					fi
				fi
			  done
			else
			echo "next step"
			fi
		echo "Do you want to install nvidia drivers?"
		echo "Make sure you know what you need"
		echo '[y\n]?'
		read nvians
		if [ $nvians = y ] ; then
			nvichoo=5
			while [ $nvichoo -eq 5 ] ; do
			echo "1. mesa"
			echo "2. nvidia"
			echo "3. nvidia-340xx"
			echo "4. nvidia-304xx"
			echo -n "Which to install [1,2,3 or 4] ?"
			 read nvichoo
				if [ $nvichoo -eq 1 ] ; then
				  pacman -S mesa
				  echo "mesa installed"
				else
					if [ $nvichoo -eq 2 ] ; then
					  pacman -S nvidia
					  echo "nvidia installed"
					else
						if [ $nvichoo -eq 3 ] ; then
						  pacman -S nvidia-340xx
						  echo "nvidia 340 drievers installed"
						else
							if [ $nvichoo -eq 4 ] ; then
							  pacman -S nvidia-304xx
							  echo "nvidia 304 drivers installed"
							else
							  echo "1. mesa"
							  echo "2. nvidia"
							  echo "3. nvidia-340xx"
							  echo "4. nvidia-304xx"
							  echo -n "Which to install [1,2,3 or 4] ?"
							  read nvichoo
							
							fi
						fi
					fi
				fi
			done
		else
		echo 'next'
		fi
	echo "Do you want to install pacli?"
	echo '[y\n]?'
	read paclian
	if [ $paclian = y ] ; then
	  echo "You can continune pacli installation after you ligin as $usrname"
	  echo 'Just run ~/git/pacliins.sh'
	  mkdir -p /home/$usrname/git
	  mv ./installpacli.sh /home/$usrname/git
	  mv ./pacli_wget /home/$usrname/git
	else
	echo 'Okay'
	fi
	echo "Configuration is over now."
	echo "If you installed driver or DM you will need to restart your system"
	echo "If you installed DE or WM you may now start X session or start it later with startx command"
	echo "What to do?"
	echo "1. reboot"
	echo "2. start X"
	echo "3. Nothing"
	echo "Choose number [1,2 or 3]? "
	read whatnow
		if [ $whatnow -eq 1 ] ; then
		  shutdown -r now
		else
			if [ $whatnow -eq 2 ] ; then
			  startx
			else
				echo "Have fun"
			fi
		fi
