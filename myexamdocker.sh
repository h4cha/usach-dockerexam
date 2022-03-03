#!/bin/bash


ETC_HOSTS=/etc/hosts

#########################
# The command line help #
#########################
display_help() {
    echo "Local PentestLab Management Script (Docker based)"
    echo
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
# Check if docker is installed and running #
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


#########################
# List all pentest apps #
#########################
list() {
    echo "Available pentest applications" >&2
    echo "  bwapp 		- bWAPP PHP/MySQL based from itsecgames.com"
    echo "  webgoat7		- WebGoat 7.1 OWASP Flagship Project"
    echo "  webgoat8		- WebGoat 8.0 OWASP Flagship Project"
    echo "  nodegoat		- NodeGoat OWASP Project"
    echo "  dvwa     		- Damn Vulnerable Web Application"
    echo "  mutillidae		- OWASP Mutillidae II"
    echo "  juiceshop		- OWASP Juice Shop"
    echo "  vulnerablewordpress	- WPScan Vulnerable Wordpress"
    echo "  securityninjas	- OpenDNS Security Ninjas"
    echo
    exit 1

}

#########################
# Info dispatch         #
#########################
info () {
  case "$1" in 
    bwapp)
      project_info_bwapp
      ;;
    webgoat7)
      project_info_webgoat7
      ;;
    webgoat8)
      project_info_webgoat8      
      ;;
    nodegoat)
      project_info_nodegoat      
      ;;
    dvwa)
      project_info_dvwa 
      ;;
    mutillidae)
      project_info_mutillidae
    ;;
    juiceshop)
      project_info_juiceshop
    ;;
    vulnerablewordpress)
      project_info_vulnerablewordpress
    ;;
    securityninjas)
      project_info_securityninjas
    ;;
    *) 
      echo "Unknown project name"
      list
      ;;
  esac  
}



#########################
# hosts file util       #
#########################  # Based on https://gist.github.com/irazasyed/a7b0a079e7727a4315b9
function removehost() {
    if [ -n "$(grep $1 /etc/hosts)" ]
    then
        echo "Removing $1 from $ETC_HOSTS";
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


#########################
# PROJECT INFO & STARTUP#
#########################
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

project_info_webgoat7 () 
{
echo "WebGoat is a deliberately insecure web application maintained by OWASP designed to teach"
echo "web application security lessons. You can install and practice with WebGoat."
echo "their understanding of a security issue by exploiting a real vulnerability in the"
echo "WebGoat applications. For example, in one of the lessons the user must use SQL injection"
echo "to steal fake credit card numbers. The application aims to provide a realistic teaching"
echo " environment, providing users with hints and code to further explain the lesson"
echo
echo "Why the name WebGoat? Developers should not feel bad about not knowing security. Even the best programmers make security errors. What they need is a scapegoat, right? Just blame it on the Goat!"
echo
echo "  https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project"
echo
echo "TECH: 	J2EE JAVA"
echo "FEATURES: LESSONS"
}

project_startinfo_webgoat7 () 
{
  echo "WebGoat 7.1 now available at http://webgoat7/WebGoat"
}

project_info_webgoat8 () 
{
echo "WebGoat is a deliberately insecure web application maintained by OWASP designed to teach"
echo "web application security lessons. You can install and practice with WebGoat."
echo "their understanding of a security issue by exploiting a real vulnerability in the"
echo "WebGoat applications. For example, in one of the lessons the user must use SQL injection"
echo "to steal fake credit card numbers. The application aims to provide a realistic teaching"
echo "environment, providing users with hints and code to further explain the lesson"
echo
echo "Why the name WebGoat? Developers should not feel bad about not knowing security. Even the best programmers make security errors. What they need is a scapegoat, right? Just blame it on the Goat!"
echo
echo "  https://www.owasp.org/index.php/Category:OWASP_WebGoat_Project"
echo "Project Leader Bruce Mayhew"
echo
echo "TECH: 	J2EE JAVA"
echo "FEATURES: LESSONS"
}

project_startinfo_webgoat8 () 
{
  echo "WebGoat 8.0 now available at http://webgoat8/WebGoat"
}

project_info_nodegoat () 
{
echo "NodeGoat is a deliberately insecure web application maintained by OWASP designed to teach"
echo "web application security lessons. You can install and practice with NodeGoat."
echo "There are other goats such as NodeGoat for Node.js. In each lesson, users must demonstrate"
echo "their understanding of a security issue by exploiting a real vulnerability in the"
echo "NodeGoat applications. For example, in one of the lessons the user must use javascript injections"
echo "to steal fake credit card numbers. The application aims to provide a realistic teaching"
echo "environment, providing users with hints and code to further explain the lesson"
echo
echo "Why the name NodeGoat? Developers should not feel bad about not knowing security. Even the best programmers make security errors. What they need is a scapegoat, right? Just blame it on the Goat!"
echo
echo "https://wiki.owasp.org/index.php/Projects/OWASP_Node_js_Goat_Project"
echo "Project Leader Chetan Karande"
echo
echo "TECH: 	Node.js NoSQL"
echo "FEATURES: LESSONS"
}

project_startinfo_nodegoat () 
{
  echo "NodeGoat 1.3 now available at http://nodegoat.net/login"
  echo "Demo Account - u:demo p:demo"
  echo "New users can also be added using the sign-up page."
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

project_info_mutillidae () 
{
echo "NOWASP (Mutillidae) is a free, open source, deliberately vulnerable web-application"
echo "providing a target for web-security enthusiest. "
echo "OWASP Incubator Project. Leader Jeremy Druin"
echo
echo "TECH: 	PHP / MySQL"
echo "FEATURES: "
}

project_startinfo_mutillidae () 
{
  echo "OWASP Mutillidae II now available at http://mutillidae"
  echo "Remember to click on the create database link before you start"
}

project_info_juiceshop () 
{
echo "OWASP Juice Shop is an intentionally insecure web application written entirely in JavaScript"
echo "which encompasses the entire range of OWASP Top Ten and other severe security flaws."
echo "  https://github.com/bkimminich/juice-shop"
echo
echo "TECH: 	Javascript"
echo "FEATURES: "
}

project_startinfo_juiceshop () 
{
  echo "OWASP Juice Shop now available at http://juiceshop"
}

project_info_securitysheperd () 
{
echo "The OWASP Security Shepherd project is a web and mobile application security training platform. "
echo "Security Shepherd has been designed to foster and improve security awareness among a varied"
echo "skill-set demographic. The aim of this project is to take AppSec novices or experienced"
echo "engineers and sharpen their penetration testing skillset to security expert status."
echo "  https://www.owasp.org/index.php/OWASP_Security_Shepherd"
echo
echo "TECH: 	"
echo "FEATURES: "
}

project_startinfo_securitysheperd () 
{
  echo "OWASP Security Sheperd now available at http://securitysheperd"
}


project_info_vulnerablewordpress () 
{
echo "https://github.com/wpscanteam/VulnerableWordpress"
echo "Vulnerable Wordpress Application"
echo "TECH: PHP / MySQL"
echo "FEATURES: "
}

project_startinfo_vulnerablewordpress () 
{
  echo "WPScan Vulnerable Wordpress site now awailable at localhost on http://vulnerablewordpress"
}

project_info_securityninjas () 
{
echo "  https://github.com/opendns/Security_Ninjas_AppSec_Training"
echo
echo "TECH: 	"
echo "FEATURES: Leassons, Tips and Solutions"
}

project_startinfo_securityninjas ()
{
  echo "Open DNS Security Ninjas site now available at localhost on http://securityninjas"
}


#########################
# Common start          #
#########################
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


#########################
# Common stop           #
#########################
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
  if [ "$(sudo docker ps -q -f name=bwapp)" ]; then
    echo "bWaPP				running at http://bwapp"
  else 
    echo "bWaPP				not running"
  fi
  if [ "$(sudo docker ps -q -f name=webgoat7)" ]; then
    echo "WebGoat 7.1			running at http://webgoat7/WebGoat"
  else 
    echo "WebGoat 7.1			not running"  
  fi
  if [ "$(sudo docker ps -q -f name=webgoat8)" ]; then
    echo "WebGoat 8.0			running at http://webgoat8/WebGoat"
  else 
    echo "WebGoat 8.0			not running"  
  fi
  if [ "$(sudo docker ps -q -f name=nodegoat)" ]; then
    echo "NodeGoat 1.3			running at http://nodegoat.net/login"
  else 
    echo "NodeGoat 1.3			not running"  
  fi
  if [ "$(sudo docker ps -q -f name=dvwa)" ]; then
    echo "DVWA				running at http://dvwa"
  else 
    echo "DVWA				not running"  
  fi
  if [ "$(sudo docker ps -q -f name=mutillidae)" ]; then
    echo "Mutillidae II			running at http://mutillidae"
  else 
    echo "Mutillidae II			not running"  
  fi
  if [ "$(sudo docker ps -q -f name=juiceshop)" ]; then
    echo "OWASP Juice Shop 		running at http://juiceshop"
  else 
    echo "OWASP Juice Shop 		not running"  
  fi
  if [ "$(sudo docker ps -q -f name=vulnerablewordpress)" ]; then
    echo "WPScan Vulnerable Wordpress 	running at http://vulnerablewordpress"
  else 
    echo "WPScan Vulnerable Wordpress	not running"  
  fi
  if [ "$(sudo docker ps -q -f name=securityninjas)" ]; then
    echo "OpenDNS Security Ninjas 	running at http://securityninjas"
  else 
    echo "OpenDNS Security Ninjas	not running"  
  fi
}


project_start_dispatch()
{
  case "$1" in
    bwapp)
      project_start "bWAPP" "bwapp" "raesene/bwapp" "127.5.0.1" "80"
      project_startinfo_bwapp
    ;;
    webgoat7)
      project_start "WebGoat 7.1" "webgoat7" "webgoat/webgoat-7.1" "127.6.0.1" "8080"
      project_startinfo_webgoat7
    ;;
    webgoat8)
      project_start "WebGoat 8.0" "webgoat8" "webgoat/webgoat-8.0" "127.7.0.1" "8080"
      project_startinfo_webgoat8
    ;;
    nodegoat)
      project_start "NodeGoat 1.3" "nodegoat" "bjm243/nodegoat" "127.8.0.1" "4000"
      project_startinfo_nodegoat
    ;;
    dvwa)
      project_start "Damn Vulnerable Web Appliaction" "dvwa" "vulnerables/web-dvwa" "127.9.0.1" "80"
      project_startinfo_dvwa
    ;;    
    mutillidae)
      project_start "Mutillidae II" "mutillidae" "citizenstig/nowasp" "127.10.0.1" "80"
      project_startinfo_mutillidae
    ;;
    juiceshop)
      project_start "OWASP Juice Shop" "juiceshop" "bkimminich/juice-shop" "127.11.0.1" "3000"
      project_startinfo_juiceshop
    ;;
    securitysheperd)
      project_start "OWASP Security Shepard" "securitysheperd" "ismisepaul/securityshepherd" "127.12.0.1" "80"
      project_startinfo_securitysheperd
    ;;
    vulnerablewordpress)
      project_start "WPScan Vulnerable Wordpress" "vulnerablewordpress" "l505/vulnerablewordpress" "127.13.0.1" "80" "3306"
      project_startinfo_vulnerablewordpress
    ;;
    securityninjas)    
      project_start "Open DNS Security Ninjas" "securityninjas" "opendns/security-ninjas" "127.14.0.1" "80"
      project_startinfo_securityninjas
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}

project_stop_dispatch()
{
  case "$1" in
    bwapp)
      project_stop "bWAPP" "bwapp"
    ;;
    webgoat7)
      project_stop "WebGoat 7.1" "webgoat7"
    ;;
    webgoat8)
      project_stop "WebGoat 8.0" "webgoat8"
    ;;
    nodegoat)
      project_stop "NodeGoat 1.3" "nodegoat"
    ;;
    dvwa)
      project_stop "Damn Vulnerable Web Appliaction" "dvwa"
    ;;
    mutillidae)
      project_stop "Mutillidae II" "mutillidae"
    ;;
    juiceshop)
      project_stop "OWASP Juice Shop" "juiceshop"
    ;;
    securitysheperd)
      project_stop "OWASP Security Sheperd" "securitysheperd"
    ;;
    vulnerablewordpress)
      project_stop "WPScan Vulnerable Wordpress" "vulnerablewordpress"
    ;;
    securityninjas)
      project_stop "Open DNS Security Ninjas" "securityninjas"
    ;;
    *)
    echo "ERROR: Project dispatch doesn't recognize the project name" 
    ;;
  esac  
}


#########################
# Main switch case      #
#########################
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