#!/bin/bash
ETC_HOSTS=/etc/hosts

## Help Command ##
display_help() {
    echo "Labs to practice Docker-based Web Pentesting"
    echo "How to use: $0 {list|status|info|start|stop} [projectname]" >&2
    echo
    echo " This script needs Docker and aliases in the host file to make web applications available"
    echo 
    echo " Example:"
    echo " $0 list				List all available projects"
    echo " $0 status			Show status for all projects"
    echo " $0 start bwapp			Start project and make it available on localhost" 
    echo " $0 info bwapp			Show information about bwapp project"
    echo
    echo " Docker containers (Source: Docker.com):"
	echo "  Metasploitable2        - tleemcjr (tleemcjr/metasploitable2)"
	echo "  DVWA                   - Ryan Dewhurst (vulnerables/web-dvwa)"
    echo "  bWapp                  - Rory McCune (raesene/bwapp)"
    exit 1
}


## Check if docker is installed and running ##
if ! [ -x "$(command -v docker)" ]; then
  echo 
  echo "Docker was not found. Please install docker before running this script."
  echo "You can try the script:"
  echo "sudo apt update"
  echo "sudo apt install -y docker.io"
  echo "sudo sytemctl enable docker --now"
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


## List all pentest apps ##
list() {
    echo "Available pentest applications" >&2
	echo "  metasploitable2	- Metasploitable is an intentionally vulnerable Linux virtual machine"
	echo "  bwapp 		- bWAPP PHP/MySQL based from itsecgames.com"
    echo "  dvwa     		- Damn Vulnerable Web Application"
    echo
    exit 1

}

## Info dispatch         ##
info () {
  case "$1" in 
    metasploitable2)
      project_info_metasploitable2
      ;;
	bwapp)
      project_info_bwapp
      ;;
    dvwa)
      project_info_dvwa 
      ;;
    *) 
      echo "Unknown project name"
      list
      ;;
  esac  
}



## Host Configuration ##
function removehost() {
    if [ -n "$(grep $1 /etc/hosts)" ]
    then
        echo "$HOSTNAME found in your $ETC_HOSTS... Removing $1 from $ETC_HOSTS";
        sudo sed -i".bak" "/$1/d" $ETC_HOSTS
    else
        echo "$1 was not found in your $ETC_HOSTS";
    fi
}

function addhost() { # ex.   127.5.0.1	bwapp
    HOSTS_LINE="$1\t$2"
    if [ -n "$(grep $2 /etc/hosts)" ]
        then
            echo "$2 already exists in /etc/hosts"
        else
            echo "Adding $2 to your $ETC_HOSTS";
            sudo -- sh -c -e "echo '$HOSTS_LINE' >> /etc/hosts";

            if [ -n "$(grep $2 /etc/hosts)" ]
                then
                    echo -e "$HOSTS_LINE was added succesfully to /etc/hosts";
                else
                    echo "Failed to Add $2, Try again!";
            fi
    fi
}

### PROJECT INFO & STARTUP##
project_info_metasploitable2 () 
{
echo "Metasploitable2 is a test environment provides a secure place to perform penetration testing and security research."
echo "For your test environment, you need a Metasploit instance that can access a vulnerable target."
echo 
echo "Metasploitable2 docker image for use in GNS3"
echo "Based off of meknisa/metasploitable-base. I didn't complain, I just made the services start, well most of them."
echo
echo "Have most of the services running except: Bind9 (requires older kernel modules) NSF (requires older kernel modules)"
echo "Klogd (could get to run after removing /var/run/klogd/kmsg but hung are container restart). The JSP and grmiregistry"
echo "services run but not showing in nmap localhost."
echo "Rest should be running."
echo
echo "Rapid7"
echo "    https://docs.rapid7.com/metasploit/metasploitable-2/"
}
project_startinfo_metasploitable2 () 
{
  echo "If you run this in Docker use something like this:"
  echo "docker run --name container-name -it tleemcjr/metasploitable2:latest sh -c /bin/services.sh && bash"
}

project_info_bwapp () 
{
echo "bWAPP, or a buggy web application, is a free and open source deliberately insecure web application."
echo "It helps security enthusiasts, developers and students to discover and to prevent web vulnerabilities."
echo "bWAPP prepares one to conduct successful penetration testing and ethical hacking projects."
echo 
echo "What makes bWAPP so unique? Well, it has over 100 web vulnerabilities!"
echo " It covers all major known web bugs, including all risks from the OWASP Top 10 project."
echo
echo " bWAPP is a PHP application that uses a MySQL database. It can be hosted on Linux/Windows"
echo " with Apache/IIS and MySQL. It can also be installed with WAMP or XAMPP."
echo "Another possibility is to download the bee-box, a custom Linux VM pre-installed with bWAPP."
echo
echo "Download our What is bWAPP? introduction tutorial, including free exercises..."
echo
echo "bWAPP is for web application security-testing and educational purposes only."
echo "Have fun with this free and open source project!"
echo
echo "Cheers, Malik Mesellem"
echo "    http://www.itsecgames.com/"
echo
echo "TECH: 	PHP / MySQL"
echo "FEATURES: DIFFERENT SKILL LEVELS"
}

project_startinfo_bwapp () 
{
  echo "Remember to run install.php before using bwapp the first time."
  echo "at http://bwapp/install.php"
  echo "Default username/password:  bee/bug"
  echo "bWAPP will then be available at http://bwapp"
}

project_info_dvwa () 
{
echo "The aim of DVWA is to practice some of the most common web vulnerabilities, with various"
echo "levels of difficulty, with a simple straightforward interface. Please note, there are"
echo "both documented and undocumented vulnerabilities with this software. This is intentional."
echo " You are encouraged to try and discover as many issues as possible."
echo "	Ryan Dewhurst"
echo "TECH: 	PHP / MySQL"
echo "FEATURES: DIFFERENT SKILL LEVELS"
}

project_startinfo_dvwa () 
{
  echo "Damn Vulnerable Web Application now available at http://dvwa"
  echo "Default username/password:   admin/password"
  echo "Remember to click on the CREATE DATABASE Button before you start"
}


## Common start          ##
project_start ()
{
  fullname=$1		# ex. WebGoat 7.1
  projectname=$2     	# ex. webgoat7
  dockername=$3  	# ex. raesene/bwapp
  ip=$4   		# ex. 127.5.0.1
  port=$5		# ex. 80
  port2=$6		# optional second port binding
  
  echo "Starting $fullname"
  addhost "$ip" "$projectname"


  if [ "$(sudo docker ps -aq -f name=$projectname)" ]; 
  then
    echo "Running command: docker start $projectname"
    sudo docker start $projectname
  else
    if [ -n "${6+set}" ]; then
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port -p $ip:$port2:$port2 $dockername
    else echo "not set";
      echo "Running command: docker run --name $projectname -d -p $ip:80:$port $dockername"
      sudo docker run --name $projectname -d -p $ip:80:$port $dockername
    fi
  fi
  echo "DONE!"
  echo
  echo "Docker mapped to http://$projectname or http://$ip"
  echo
}


## Common stop           ##
project_stop ()
{
  fullname=$1	# ex. WebGoat 7.1
  projectname=$2     # ex. webgoat7

  echo "Stopping... $fullname"
  echo "Running command: docker stop $projectname"
  sudo docker stop $projectname
  removehost "$projectname"
}



project_status()
{
  if [ "$(sudo docker ps -q -f name=metasploitable2)" ]; then
    echo "Metasploitable2				running at http://metasploitable2"
  else 
    echo "Metasploitable2			not running"  
  fi
  if [ "$(sudo docker ps -q -f name=bwapp)" ]; then
    echo "bWaPP				running at http://bwapp"
  else 
    echo "bWaPP				not running"
  fi
  if [ "$(sudo docker ps -q -f name=dvwa)" ]; then
    echo "DVWA				running at http://dvwa"
  else 
    echo "DVWA				not running"  
  fi
}


project_start_dispatch()
{
  case "$1" in
    metasploitable2)
      project_start "Metasploitable2" "metasploitable2" "tleemcjr/metasploitable2" "127.4.0.1" "80"
      project_startinfo_metasploitable2
    ;;
    bwapp)
      project_start "bWAPP" "bwapp" "raesene/bwapp" "127.5.0.1" "80"
      project_startinfo_bwapp
    ;;
    dvwa)
      project_start "Damn Vulnerable Web Appliaction" "dvwa" "vulnerables/web-dvwa" "127.6.0.1" "80"
      project_startinfo_dvwa
    ;;    
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}

project_stop_dispatch()
{
  case "$1" in
    metasploitable2)
      project_stop "Metasploitable2" "metasploitable2"
    ;;
    bwapp)
      project_stop "bWAPP" "bwapp"
    ;;
    dvwa)
      project_stop "Damn Vulnerable Web Appliaction" "dvwa"
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}


## Main switch case      ##
case "$1" in
  start)
    if [ -z "$2" ]
    then
      echo "ERROR: Option start needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    project_start_dispatch $2
    ;;
  stop)
    if [ -z "$2" ]
    then
      echo "ERROR: Option stop needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    project_stop_dispatch $2
    ;;
  list)
    list # call list ()
    ;;
  status)
    project_status # call project_status ()
    ;;
  info)
    if [ -z "$2" ]
    then
      echo "ERROR: Option info needs project name in lowercase"
      echo 
      list # call list ()
      break
    fi
    info $2
    ;;
  *)
    display_help
;;
esac  