#!/bin/bash

# Project 4 - Linux User Management Automation
# Stage 8 - Automated user provisioning

set -euo pipefail

echo "=================================="
echo " Linux User Management Automation"
echo "=================================="

# Step 1: Check arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <username> <group>"
    exit 1
fi

USERNAME="$1"
GROUP="$2"

# Step 2: Validate username and group
if [[ ! "$USERNAME" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "ERROR: Invalid username format."
    exit 1
fi

if [[ ! "$GROUP" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
    echo "ERROR: Invalid group format."
    exit 1
fi

# Step 3: Allow only approved department groups
case "$GROUP" in
    developers|operations|support)
        ;;
    *)
        echo "ERROR: Group is not approved."
        exit 1
        ;;
esac

# Step 4: Prevent duplicate accounts
if getent passwd "$USERNAME" > /dev/null; then
    echo "ERROR: User '$USERNAME' already exists."
    exit 1
fi

# Step 5: Check whether the group exists
if ! getent group "$GROUP" > /dev/null; then
    echo "ERROR: Group '$GROUP' does not exist."
    exit 1
fi

# Step 6: Require administrative privileges
if [ "$EUID" -ne 0 ]; then
    echo "ERROR: Run this script using sudo."
    exit 1
fi

# Step 7: Display planned action
echo "Username: $USERNAME"
echo "Department group: $GROUP"
echo "Action: Create Linux user"

# Step 8: Confirm before making changes
read -r -p "Proceed with user creation? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Operation cancelled."
    exit 0
fi

# Step 9: Create the user
useradd -m -s /bin/bash "$USERNAME"

# Step 10: Assign the department group
usermod -aG "$GROUP" "$USERNAME"

# Step 11: Verify
echo "=================================="
echo " User created successfully"
echo "=================================="

id "$USERNAME"

echo "Home directory:"
ls -ld "/home/$USERNAME"

echo "NOTE: Password has not been configured."
echo "Account provisioning completed."
