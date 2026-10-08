# Linux User and Access Management Automation

## Project Overview

A hands-on Linux administration project demonstrating user
provisioning, department-based access control, secure offboarding,
and user access auditing using Bash scripting on RHEL.

## Environment

- OS: Red Hat Enterprise Linux 9
- Virtualization: Oracle VirtualBox
- Remote Access: PuTTY / SSH
- Language: Bash
- Tools: useradd, usermod, passwd, chage, chmod, chown,
  setfacl, getfacl, getent, awk, Git

## Architecture

Linux Administrator
        |
        v
Bash Automation Scripts
        |
        +-- user_manager.sh
        |      |
        |      +-- Validate username and department
        |      +-- Create Linux user
        |      +-- Assign group
        |      +-- Verify account
        |
        +-- offboard_user.sh
        |      |
        |      +-- Validate approved lab account
        |      +-- Lock password
        |      +-- Expire account
        |      +-- Verify status
        |
        +-- audit_users.sh
               |
               +-- Collect user information
               +-- Check group membership
               +-- Check password status
               +-- Check account expiration
               +-- Generate audit report

## Project Features

### 1. User Provisioning

- Validates usernames and department groups.
- Prevents duplicate account creation.
- Allows only approved departments.
- Requires administrative privileges.
- Creates home directories.
- Assigns supplementary groups.

### 2. Access Control

- Configures Linux ownership and permissions.
- Creates a protected departmental directory.
- Uses setgid for group ownership inheritance.
- Uses default ACLs for shared file access.
- Verifies authorized and unauthorized access.

### 3. Secure Offboarding

- Restricts operations to approved lab accounts.
- Requires explicit confirmation.
- Locks password authentication.
- Expires accounts.
- Retains account records for auditing.

### 4. User Access Auditing

- Displays usernames and UIDs.
- Lists group memberships.
- Checks password status.
- Checks account expiration.
- Produces a formatted audit report.

## Scripts

| Script | Purpose |
|--------|---------|
| user_manager.sh | Automated user onboarding |
| offboard_user.sh | Secure lab account offboarding |
| audit_users.sh | Local user access auditing |

## Usage

### Check script syntax

```bash
bash -n user_manager.sh
bash -n offboard_user.sh
bash -n audit_users.sh
```

### Create a user

```bash
sudo ./user_manager.sh devuser3 developers
```

### Offboard an approved lab user

```bash
sudo ./offboard_user.sh leaver2
```

### Generate an audit report

```bash
sudo ./audit_users.sh
```

## Security Considerations

- Scripts require administrative privileges for system changes.
- User creation is restricted to approved department groups.
- Offboarding is restricted to explicitly approved lab accounts.
- No passwords or API tokens are stored in scripts.
- Generated audit reports are excluded from Git.
- Account expiration does not automatically terminate existing
  sessions or revoke external access.
- Scripts are intended for a controlled learning environment.

## Key Linux Concepts

- User IDs and Group IDs
- File ownership
- chmod and chown
- Supplementary groups
- setgid directories
- umask
- Access Control Lists
- Bash input validation
- Account expiration
- User access auditing

## Learning Outcome

Built and tested Linux user lifecycle automation with Bash,
including onboarding, group-based access control, offboarding,
and access auditing.

## Future Improvements

- Centralized audit logging
- CSV-based bulk onboarding
- Role-based access policies
- Integration with Ansible
- Integration with enterprise identity management
