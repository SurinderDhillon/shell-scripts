#!/bin/bash
# Create a user for sftp access. 
# Number of parameters passed: 2
# First parameter: Username
# Second parameter: Password
# 7th Apr 2016 - Modified paths to match new sftp server mounts

# Enable logging
# Removed /tmp/ from the LOG file path below as it was a bug - Jagdeep Singh
LOG=${0}.log
echo -e "\nCreate FTP User script started. Date: $(date)" >> ${LOG}

# Remove logs from previous execution
# Commented for testing on Aug 14, 2015. Logs will be appended.
#rm -f ${LOG}

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
