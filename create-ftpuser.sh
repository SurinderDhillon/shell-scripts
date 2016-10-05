#!/bin/bash
# Create a user for sftp access. 
# Number of parameters passed: 2
# First parameter: Username
# Second parameter: Password

# Enable logging
LOG=${0}.log
echo -e "\nCreate FTP User script started. Date: $(date)" >> ${LOG}

# Check for incorrect parameters passed to the script
if [ ! "$#" -eq 2 ]; then 
  echo "Usage: ${0} username password" 1>>${LOG} 2>&1
  exit 1  
fi

# Set the parameters for script usage
USERNAME="${1}"
PASSWD="${2}"
FTPBASE=/ftp/ftp_data
USERGROUP=sftponly

# Create the user home directory and add the user
mkdir -p ${FTPBASE}/${USERNAME}/uploads
/usr/sbin/useradd -M -d /uploads -s /bin/false -G ${USERGROUP} ${USERNAME} 1>>${LOG} 2>&1

# Change passwd from command line
echo "${USERNAME}:${PASSWD}" | chpasswd

# Set appropriate permissions for the user
/bin/chmod 755 ${FTPBASE}/${USERNAME} 1>>${LOG} 2>&1
/bin/chown root:root ${FTPBASE}/${USERNAME} 1>>${LOG} 2>&1
/bin/chown ${USERNAME}:${USERGROUP} ${FTPBASE}/${USERNAME}/uploads 1>>${LOG} 2>&1
