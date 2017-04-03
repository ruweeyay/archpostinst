#!/bin/bash
function countdownf {
	COUNT=3 
		    until [ $COUNT = 0 ]; do
			echo $COUNT
			let COUNT=COUNT-1
			sleep 1
		    done
}
WHOMI=`whoami`
echo "Your username is $WHOMI ?"
echo "This script will install pacli"
echo "Ready [y n]? "
read readyan
if [ $readyan = y ] ; then
	mkdir -p ~/git
	pacman -S base-devel git wget
	wget -i pacli_wget
	tar -xvf downgrade.tar.gz -C /home/$WHOMI/git/
	tar -xvf package-query.tar.gz -C /home/$WHOMI/git/
	tar -xvf yaourt.tar.gz -C /home/$WHOMI/git/
	tar -xvf pacli.tar.gz -C /home/$WHOMI/git/
	rm ./*.tar.gz
	echo "PKGBUILDs will be installed know. Do not edit them if you don't know what are you doing"
	countdownf
	cd ~/git/downgrade && makepkg -sri
	countdownf
	cd ~/git/package-query/ && makepkg -sri
	countdownf
	cd ~/git/yaourt/ && makepkg -sri
	countdownf
	cd ~/git/pacli/ && makepkg -sri
	
else
	echo "Exiting"
fi
