#!/bin/bash
# Delete a user which was created for sftp access.
# Number of parameters passed is 1
# First parameter: Username

# Enable logging
LOG=/tmp/${0}.log
echo -e "\nCreate FTP User script started. Date: $(date)" >> ${LOG}

# Check for incorrect parameters passed
if [ ! "$#" -eq 1 ]; then
  echo "Usage: ${0} username" 1>>${LOG} 2>&1
  exit 1
fi

# Set the parameters for the script execution
USERNAME="${1}"
FTPBASE=/ftp/ftp_data

# Check for the username existence
if [ $(grep -c ${USERNAME} /etc/passwd) -ge 1 ]; then
  echo "${USERNAME} exists and found in system passwd file." 1>>${LOG} 2>&1
  userdel -fr ${USERNAME} 1>>${LOG} 2>&1
  # Manually delete the user home directory, because it is mentioned as /uploads when created & it doesnt exist
  rm -Rf ${FTPBASE}/${USERNAME} 1>>${LOG} 2>&1
else 
  # Check for the remains of the directory
  if [ -d ${FTPBASE}/${USERNAME} ]; then
    rm -Rf ${FTPBASE}/${USERNAME} 1>>${LOG} 2>&1
    echo "${USERNAME} does not exist in the system passwd file. User home directory was found. Deleted now!" 1>>${LOG} 2>&1
  fi
  echo "Username does not exist" 1>>${LOG} 2>&1
  exit 1
fi
