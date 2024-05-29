#!/bin/bash
############################################################
# Help                                                     #
############################################################
Help()
{
   # Display Help
   echo "::: ARGALY :::"
   echo "This script creates a new account ready to use the sftp."
   echo "It creates the new user. Add it to the sftp-group group."
   echo "It returns the password."
   echo
   echo "Syntax: scriptTemplate [-n|l|h]"
   echo "options:"
   echo "h     Print this Help."
   echo "n     name of the customer. It will be used as login name."
   echo "l     length of password - default is 18 - cannot be less than 12"
   echo
}

# Set variable
userName=""
pwd=""
pwd_length="18"
sftp_group="sftp-group"


GREEN='\033[0;32m'
NC='\033[0m' # No Color

############################################################
# Process the input options. Add options as needed.        #
############################################################
# Get the options
while getopts "l:n:h" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      n) # Enter a name
         userName=$OPTARG;;
      l) # password length
         pwd_length=$OPTARG;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

echo

create_user(){
   generateNewPassword
   echo -n "adding new user '${userName}'"
   useradd $userName -m --groups $sftp_group --shell /sbin/nologin
   echo -e " ${GREEN}[OK]${NC}"
   echo -n "setting new password"
   echo "$userName:$pwd" | chpasswd
   echo -e " ${GREEN}[OK]${NC}"
   setFolderPermissions
   echo -e "${GREEN}new user '${userName}' added successfully. Please send the password using a secure channel${NC}"
   echo
   echo $pwd
}

setFolderPermissions(){
   echo -n "setting home folder permissions"
   local home="/home/${userName}"
   mkdir $home/sftp
   chown root:root -R $home
   chmod -R 755 $home/sftp
   mkdir $home/sftp/data
   chown -R $userName:$userName $home/sftp/data
   echo -e " ${GREEN}[OK]${NC}"
}

generateNewPassword(){
   echo -n "generating new password"
   chars='@#$%&_+='
   pwd=$({ 
    </dev/urandom LC_ALL=C grep -ao '[A-Za-z0-9]' | head -n$((RANDOM % 18 + 9))
    echo ${chars:$((RANDOM % ${#chars})):1}   # Random special char.
   } | shuf | tr -d '\n')
   echo -e " ${GREEN}[OK]${NC}"
}


create_user
