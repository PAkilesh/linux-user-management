#!/bin/bash

# Project 4 - Linux User Access Audit
# Read-only reporting script

set -euo pipefail

echo "========================================"
echo " Linux User Access Audit"
echo "========================================"
echo "Generated: $(date)"
echo

USERS=(
    devuser1
    devuser2
    opsuser1
    outsider1
    leaver1
    leaver2
)

printf "%-12s %-8s %-22s %-12s %-15s\n" \
    "USERNAME" "UID" "GROUPS" "PASSWORD" "EXPIRATION"

printf '%s\n' \
    "------------------------------------------------------------------------"

for USERNAME in "${USERS[@]}"; do

    if ! getent passwd "$USERNAME" > /dev/null; then
        echo "WARNING: $USERNAME does not exist."
        continue
    fi

    USER_UID=$(id -u "$USERNAME")

    USER_GROUPS=$(id -nG "$USERNAME" | tr ' ' ',')

    PASSWORD_STATUS=$(passwd -S "$USERNAME" | awk '{print $2}')

    EXPIRATION=$(chage -l "$USERNAME" |
        awk -F: '/^Account expires/ {
            sub(/^[[:space:]]+/, "", $2)
            print $2
        }')

    printf "%-12s %-8s %-22s %-12s %-15s\n" \
        "$USERNAME" \
        "$USER_UID" \
        "$USER_GROUPS" \
        "$PASSWORD_STATUS" \
        "$EXPIRATION"

done

echo
echo "Audit completed."
