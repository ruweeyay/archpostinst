#!/bin/bash
WHOMI=`whoami`
usercheck=$WHOMI
if [ $usercheck = *root* ]; then
	echo "You are root."
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
	    echo `useradd $usrname -d`
	  else
	    echo `useradd $usrname`
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
			  echo `echo en_US.UTF-8 UTF-8 >> /etc/locale.gen`
			  echo `echo en_US ISO-8859-1 >> /etc/locale.gen`
			  echo `echo ru_RU.UTF-8 UTF-8 >> /etc/locale.gen`
			  echo `echo ru_RU.KOI8-R KOI8-R >> /etc/locale.gen`
			  echo `echo ru_RU ISO-8859-5 >> /etc/locale.gen`
			  echo `locale-gen`
			else
			  until [ $locname = stop ]; do
			    echo 'Enter locale you want to add in format "en_US.UTF-8": (or type "stop" when you have enough)'
			    read locname
			    echo `echo $locname UTF-8 >> /etc/locale.gen`
			    echo "Locale $locname added"
			    echo "If you want to add more, type locale or type "stop" if you want to stop"
			  done
			echo `locale-gen`
			fi
		else
		  echo "Going to next step"
	  fi
	echo 'Which language do you want to set as system default? [ru\us]'
	read langan
	  if [ $langan = ru ]; then
		echo `echo LANG=ru_RU.UTF-8 UTF-8 > /etc/locale.conf`
		echo "russian locale set"
	  else
		echo `echo LANG=en_US.UTF-8 UTF-8 > /etc/locale.conf`
		echo 'US locale set'
		
	  fi		  
	echo -n 'Do you want configure groups by yourself, add to wheel(simple way) or choose nubmer of 
goups(if you now what you are doing)? [wheel,fewgroups,manual]'
	read groupinput
	    if [ $groupinput = wheel ]; then
		echo `gpasswd -a $usrname wheel`
		echo `echo %wheel ALL=(ALL) ALL >> /etc/sudoers`
	    else
		if [ $groupinput = fewgroups ]; then
			until [ $gr1 = stop ]; do
				echo 'Enter the name of group or enter "stop" if do not want to add more 
groups'
				read gr1
				echo `gpasswd -a $usrname $gr1`
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
		echo `pacman -S xorg xorg-xinit`
		echo 'X org is now installed. Which DE\WM do you want to use? [xfce4 openbox gnome i3 
herbstluftwm]'
		echo 'More desktops will be added lately'
		read deskname
			if [ $deskname = xfce4 ]; then
				echo `pacman -S xfce4`
				echo "XFCE4 is now installed"
				touch /home/$usrname/.xinitrc
				echo `echo exec startxfce4' > /home/$usrname/.xinitrc

			else
				if [ $deskname = openbox ]; then
				  echo `pacman -S openbox`
				  echo 'Openbox is now installed'
				  touch /home/$usrname/.xinitrc
				  echo `echo exec openbox-session` > /home/$usrname/.xinitrc
				else
					if [ $deskname = gnome ]; then
					  echo `pacman -S gnome`
					  echo 'Gnome is now installed'
					  touch /home/$usrname/.xinitrc
					  echo `echo exec gnome-session` > /home/$usrname/.xinitrc
					else
						if [ $deskname = herbstluftwm ]; then
						  echo `pacman -S herbstluftwm`
						  echo 'Herbstluft is now installed'
						  echo `mkdir -p /home/$usrname/.config`
						  echo `mkdir -p /home/$usrname/.config/herbstluftwm`
						  echo `cp /etc/xdg/herbstluftwm/autostart 
/home/$usrname/.config/herbstluftwm/autostart`
						  echo `cp /etc/xdg/herbstluftwm/panel.sh 
/home/$usrname/.config/herbstluftwm/panel.sh`
						  echo `touch /home/$usrname/.xinitrc`
						  echo `echo exec herbstluftwm > /home/$usrname/.xinitrc`
						  echo 'Herbstluft is now installed. ATTENTION: you may want to add "--asutostart /home/username/.config/herbstluftwm/autostart" to your /home/username/.xinitrc for 
correct work'
						else
							if [ $deskname = i3 ]; then
							  echo `pacman -S i3`
							  touch /home/$usrname/.xinitrc
							  echo `echo exec i3 > /home/$usrname/.xinitrc`
							  echo "i3 is now installed"
							  echo "You may want to visit arch wiki to configure i3 propertly"
							fi
						fi
					fi
				fi
			fi
		###continune here
		echo 'Do you want to install Desktop Manager (grphical login)? [y\n]'
		  read dmans
			if [ $dmans = y ]; then
			  echo 'Which DM you want to use? [gdm slim lightdm]
			  read dmchoo
				if [ $dmchoo = gdm ]; then
				  echo `pacman -S gdm`
				  echo `systemctl enable gdm.service`
				  echo "gdm is now installed and enabled."
				else
					if [ $dmchoo = slim ]; then
					  echo `pacman -S slim`
					  echo `systemctl enbale slim.service`
					  echo "slim is now installed and enabled. Wisit slim page on arch wiki to see more information"
					else
						if [ $dmchoo = lightdm ]; then
						  echo `pacman -S lightdm`
						  echo `systemctl enable lightdm.service`
						  echo "lightdm is now installed and enbaled."
						fi
					fi
				fi
			fi
		
			
		
	  else
		echo 'Okay, next step.'
	  fi 
	echo 'Do you want to isntall pacli? [y\n]'
	echo "ATTENTION: pacli cannot be installed from root, so if you answer Y all requiered packages will be downloaded and you will be able 
to continune pacli installation with another script when logged from $usrname"
	read paclian
		if [ $paclian = y ]; then
		  echo "Base-devel and wget packages will be installed now"
		    COUNT=3 
		    until [ $COUNT = 0 ]; do
			echo $COUNT
			let COUNT=COUNT-1
			sleep 1
		    done
		  echo `pacman -S base-devel wget`
		  echo "Downloading requiered PKGBULDs"
		  echo `wget -i pacli_wget`
		  mkdir /home/$usrname/aur
		  tar -xvf downgrade.tar.gz -C /home/$usrname/git/
		  tar -xvf package-query.tar.gz -C /home/$usrname/git/
		  tar -xvf yaourt.tar.gz -C /home/$usrname/git/
		  tar -xvf pacli.tar.gz -C /home/$usrname/git/
		  rm ./*.tar.gz
		else
		  echo "Next step."
		fi
	echo 'Do you want to install videocard drivers? [y\n]'
		read driveans
		if [ $driveans = y ]; then
			echo 'MAKE SURE YOU KNOW WHAT YOU NEED. Some old nvidia cards have problems with open-surce drivers'
			echo 'For nvidia 200 series and higher MESA will be ok. If you want proprietary direvs choose NVIDIA'
			echo 'For nvidia 6000-9000 series it is recommended to use NVIDIA-340 drivers, for even older cards - NVIDIA 304'
			echo 'If you have radeon - sorry, I'll add radeon drivers later, but redeon graphics should work fine with xorg itsefl'
			echo 'Wich drivers to install?(enter none if you changed your mind) [mesa nvidia nvidia-340xx nvidia-304xx none]'
				read drivan
					if [ $drivean = mesa ]; then
					  echo "Mesa will be installed now. Again, if you don't know what are you doing - answer default to 
pacman"
					  sleep 3
					  echo `pacman -S mesa`
					else 
						if [ $drivean = nvidia ]
						  echo "nvidia drivers will be installed now. If you do not know what choose, when pacman ask you 
to, just press enter for default answer"
						  sleep 3
						  echo `pacman -S nvidia`
						else
							if [ $drivean = nvidia-340xx ]; then
							  echo "nvidia-340xx drivers will be installed now. If you do not know what to choose, 
when pacman ask you to, just press enter for default answer"
							  sleep 3
							  echo `pacman -S nvidia-340xx`
							else
								if [ $drivean = nvidia-304xx ]; then
								  echo "nvidia-304xx drivers will be installed now. If you do not know what to 
choose, whet pacman ask you to, just press enter for default answer"
								  sleep 3
								  echo `pacman -S nvidia-304xx`
								else
									if [ $drivean = none ]; then
									  echo "Moving to next step"
									fi
								fi
							fi
						fi
					fi
	echo "It's almost over. Now, if you get yourself DM or installed video drivers it's recmmended to reboot your system. If you only 
installed DE or WM you can start your session writing "\startx"\"
	echo 'Do you want to reboot your system? [y\n]'
		read shutr
		if [ $shutr = y ]; then
			COUNTSHTD=5
			until [ $COUNTSHTD = 0 ]; do
				echo $COUNTSHTD
				let COUNTSHTD=COUNTSHTD-1
				sleep 1
			done
			echo `shutdown -r now`
		else
			echo 'Okay'
		fi
	echo 'It is done! Now login as your new user and enjoy.'
else
echo 'Please, run script as root user.'
fi

