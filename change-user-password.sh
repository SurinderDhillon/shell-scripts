#!/bin/bash
# Change password for a user configured for SFTP access
# Number of parameters passed is 2
# First parameter: Username
# Second parameter: password

# Check for incorrect parameters passed
if [ ! "$#" -eq 2 ]; then 
  echo "Usage: ${0} username password"
  exit 1  
fi

# Set the parameters for script usage
USERNAME=${1}
PASSWD=${2}

# Root user password change check
if [ ${USERNAME} = "root" ]; then
  echo "Cannot change password for root user"
  exit 1
fi

# Change passwd from command line
echo "${USERNAME}:${PASSWD}" | chpasswd
echo "Password changed successfully for user - ${USERNAME}"
