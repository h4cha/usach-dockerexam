#!/bin/bash

ETC_HOSTS=/etc/hosts

# Linea de comandos de ayuda (help) #
display_help() {
    echo "Mi primer script en bash para abrir un laboratorio de Pentesting basado en Docker"
    echo "Usage: $0 {list|status|info|start|stop} [projectname]" >&2
    echo
    echo " This scripts uses docker and hosts alias to make web apps available on localhost"
    echo 
    echo " Ex."
    echo " $0 list"
    echo " 	List all available projects"
    echo " $0 status"
    echo "	Show status for all projects"
    echo " $0 start bwapp"
    echo " 	Start project and make it available on localhost" 
    echo " $0 info bwapp"
    echo " 	Show information about bwapp project"
    echo
    echo " Dockerfiles from:"
    echo "  DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)"
    echo "  Mutillidae II          - Nikolay Golub (citizenstig/nowasp)"
    echo "  bWapp                  - Rory McCune (raesene/bwapp)"
    echo "  Webgoat(s)             - OWASP Project"
    echo "  NodeGoat		   - Ben McMahon (bjm243/nodegoat)"
    echo "  Juice Shop             - Bjoern Kimminich (bkimminich/juice-shop)"
    echo "  Vulnerable Wordpress   - WPScan Team (l505/vulnerablewordpress)"
    echo "  Security Ninjas        - OpenDNS Security Ninjas AppSec Training"
    exit 1
}

############################################
# Valida si Docker esta instalado y corriendo #
############################################
if ! [ -x "$(command -v docker)" ]; then
  echo 
  echo "Docker was not found. Please install docker before running this script."
  echo "You can try the script: 	install_docker_kali_x64.sh"
  echo "In the same repo at https://github.com/itboxltda/pentestlab"
  exit
fi

if sudo service docker status | grep inactive > /dev/null
then 
	echo "Docker is not running."
	echo -n "Do you want to start docker now (y/n)?"
	read answer
	if echo "$answer" | grep -iq "^y"; then
		sudo service docker start
	else
		echo "Not starting. Script will not be able to run applications."
	fi
fi


display_help
#Pruebas