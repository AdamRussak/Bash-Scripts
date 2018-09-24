#!/bin/bash
#                                            !!!! Created By: Adam Russak  !!!!
# this script will let you chose weach version of centos are you traying to chane hostname to

# this part has instructions for User Managing this script
clear
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+                    Instructions:                                    +"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "+  1. Run This Script as Root                                         +"
echo "+                                                                     +"
echo "+  2. Chose the Distribution & Versions.                              +"
echo "+                                                                     +"
echo "+  3. Set the New Hostanme for your Machine.                          +"
echo "+                                                                     +"
echo "+  4. Set the New Domain Suffix for your Domain. !!Only in CentOS!!   +"
echo "+                                                                     +"
echo "+  5. You Will be requerd to Restart your machine after the Script.   +"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo ""
echo ""
echo " Linux Distribution & Versions: "
echo "-----------------------------------------------------------------------"
echo "- 1) CentOS - 5                                                       -"
echo "-   2) CentOS - 6                                                     -"
echo "-    3) CentOS - 7                                                    -"
echo "-     4) Ubuntu (ALL)                                                 -"
echo "-----------------------------------------------------------------------"
# selecting the version
echo -n "Chose Your distribution and Version: "
read CENTOSV
# Case Functeion to run only the Chosen Box (with the Version that is needed)
case $CENTOSV in
	1)
		# auto set of current Hostanme & domain name
		OLD_HOSTNAME="$( hostname -a )"
		OLD_DOMAIN="$( hostname -d )"
		
		# inputing the new hostname and domain suffix
		echo -n "Please enter new hostname: "
		read NEW_HOSTNAME

		echo -n "Entre DNS Suffix: "
		read DNS_SUFFIX

		if [ -z "$NEW_HOSTNAME" ]; then
		        echo "Error: no hostname entered. Exiting."
		        exit 1
		fi	

		echo "Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME..."


		# part for changing /etc/sysconfig/network
		if [ -n "$( grep HOSTNAME="$OLD_HOSTNAME" /etc/sysconfig/network )" ]; then
		        sed -i -e "s/HOSTNAME=$OLD_HOSTNAME.*$/HOSTNAME=$NEW_HOSTNAME.$DNS_SUFFIX/" /etc/sysconfig/network
		else
		        echo "HOSTNAME=$NEW_HOSTNAME.$DNS_SUFFIX" > /etc/sysconfig/network
		fi

		# part for changing /etc/hosts
		if [ -n "$( grep "$OLD_HOSTNAME" /etc/hosts )" ]; then
                	sed -i -e "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
		        if [ -n "$( grep -o "$OLD_DOMAIN" /etc/hosts )" ]; then
                		sed -i -e "s/$OLD_DOMAIN/$DNS_SUFFIX/g" /etc/hosts
		        fi	
		fi

		# part for /etc/hostname
		if [ -f /etc/hostname ]; then
		        sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname
		fi
		
		echo "Restarting Network Interface..."
		/etc/init.d/network restart >> /dev/null

		echo "++++++++++++++++++++++++++++++++"
		echo "+        !Done!                +"
		echo "+  !!Restart Your Machine!!    +"
		echo "++++++++++++++++++++++++++++++++";;
	2)
		OLD_HOSTNAME="$( hostname -f )"

		echo -n "Please enter new hostname: "
		read NEW_HOSTNAME

		echo -n "Entre DNS Suffix: "
		read DNS_SUFFIX

		if [ -z "$NEW_HOSTNAME" ]; then
			echo "Error: no hostname entered. Exiting."
			exit 1
		fi

		echo "Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME..."

		if [ -n "$( grep HOSTNAME="$OLD_HOSTNAME" /etc/sysconfig/network )" ] && [ -n "$( grep localdomain /etc/hosts )" ]; then
			sed -i -e "s/HOSTNAME=$OLD_HOSTNAME.*$/HOSTNAME=$NEW_HOSTNAME.$DNS_SUFFIX/" /etc/sysconfig/network
		elif [ -n "$( grep HOSTNAME="$OLD_HOSTNAME" /etc/sysconfig/network )" ] && [ -z  "$( grep localdomain /etc/hosts )" ]; then
			sed -i -e "s/HOSTNAME=$OLD_HOSTNAME/HOSTNAME=$NEW_HOSTNAME/" /etc/sysconfig/network
			echo "Domain Suffix was NOT cahnged!"
		fi

		if [ -n "$( grep "$OLD_HOSTNAME" /etc/hosts )" ]; then
                sed -i -e "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g; s/localdomain.*$/$DNS_SUFFIX/g" /etc/hosts
                sed -i -e "s/localhost/$NEW_HOSTNAME/g" /etc/hosts
		fi

		echo "Restarting Network Interface..."
		/etc/init.d/network restart >> /dev/null

		echo "++++++++++++++++++++++++++++++"
		echo "+       !!Done!!             +"
		echo "+ !!Restart Your Machine!!   +"
		echo "++++++++++++++++++++++++++++++";;
	3)
		OLD_HOSTNAME="$( hostname )"

		echo -n "Please enter new hostname: "
		read NEW_HOSTNAME

		echo -n "Entre DNS Suffix: "
		read DNS_SUFFIX

		if [ -z "$NEW_HOSTNAME" ]; then
		        echo "Error: no hostname entered. Exiting."
		        exit 1
		fi

		echo "Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME..."

		hostname "$NEW_HOSTNAME"

		if [ -n "$( grep HOSTNAME="$OLD_HOSTNAME" /etc/sysconfig/network )" ]; then
		        sed -i -e "s/HOSTNAME=$OLD_HOSTNAME.*$/HOSTNAME=$NEW_HOSTNAME.$DNS_SUFFIX/" /etc/sysconfig/network
		else
		        echo "HOSTNAME=$NEW_HOSTNAME.$DNS_SUFFIX" > /etc/sysconfig/network
		fi

		if [ -n "$( grep "$OLD_HOSTNAME" /etc/hosts )" ]; then
			sed -i -e "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g; s/localdomain.*$/$DNS_SUFFIX/g" /etc/hosts
			sed -i -e "s/localhost/$NEW_HOSTNAME/g" /etc/hosts
		fi

		if [ -f /etc/hostname ]; then
		        sed -i "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hostname
		fi
		
		echo "Restarting Network Interface..."
		/etc/init.d/network restart >> /dev/null

		echo "++++++++++++++++++++++++++++++++"
		echo "+        !Done!                +"
		echo "+  !!Restart Your Machine!!    +"
		echo "++++++++++++++++++++++++++++++++";;
	4)
		OLD_HOSTNAME="$( hostname )"

		echo -n "Please enter new hostname: "
		read NEW_HOSTNAME

		if [ -z "$NEW_HOSTNAME" ]; then
			echo "Error: no hostname entered. Exiting."
			exit 1
		fi

		echo "Changing hostname from $OLD_HOSTNAME to $NEW_HOSTNAME..."

		if [ -n "$( grep "$OLD_HOSTNAME" /etc/hostname )" ]; then
			sed -i -e "s/$OLD_HOSTNAME.*$/$NEW_HOSTNAME/" /etc/hostname
		fi

		if [ -n "$( grep "$OLD_HOSTNAME" /etc/hosts )" ]; then
			sed -i -e "s/$OLD_HOSTNAME/$NEW_HOSTNAME/g" /etc/hosts
		fi

		echo "++++++++++++++++++++++++++++++"
		echo "+       !!Done!!             +"
		echo "+ !!Restart Your Machine!!   +"
		echo "++++++++++++++++++++++++++++++";;
esac

# Prmpt for Restart Y/y will restart, N/n will exit with no restrart, any other (*) will loop back to press a currect annsewer
while true; do
    read -p "Do you wish to restart the System?" yn
    case $yn in
        [Yy]* ) /sbin/reboot ;;
        [Nn]* ) echo "Please Restart the system Now!"
                exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
done

