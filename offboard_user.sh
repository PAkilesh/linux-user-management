#!/bin/bash

# Project 4 - Linux User Management Automation
# Secure offboarding for approved lab accounts

set -euo pipefail

echo "=================================="
echo " Linux User Offboarding"
echo "=================================="

# Check arguments
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME="$1"

# Only allow explicitly approved lab accounts
case "$USERNAME" in
    leaver1|leaver2)
        ;;
    *)
        echo "ERROR: Account is not approved for this lab."
        exit 1
        ;;
esac

# Require root privileges
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script using sudo."
    exit 1
fi

# Check whether the account exists
if ! getent passwd "$USERNAME" > /dev/null; then
    echo "ERROR: User '$USERNAME' does not exist."
    exit 1
fi

# Protect system accounts
USER_UID=$(id -u "$USERNAME")

if [ "$USER_UID" -lt 1000 ]; then
    echo "ERROR: System accounts cannot be offboarded."
    exit 1
fi

echo "Account found: $USERNAME"
echo "UID: $USER_UID"
echo "Action: Lock password and expire account"

# Require explicit confirmation
read -r -p "Type OFFBOARD to continue: " CONFIRM

if [ "$CONFIRM" != "OFFBOARD" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Lock password authentication
passwd -l "$USERNAME"

# Expire the account
usermod --expiredate 1 "$USERNAME"

echo "=================================="
echo " Offboarding completed"
echo "=================================="

# Verify status
passwd -S "$USERNAME"
chage -l "$USERNAME"

echo "Account record and home directory retained."
echo "Review active sessions and SSH access separately."
