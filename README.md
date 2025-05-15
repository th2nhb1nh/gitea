# Gitea Repository Setup Guide

This guide explains how to use the existing Gitea Docker setup and how to use it as a Git repository for your projects.

## Table of Contents
- [Gitea Repository Setup Guide](#gitea-repository-setup-guide)
  - [Table of Contents](#table-of-contents)
  - [Prerequisites](#prerequisites)
  - [Starting Gitea](#starting-gitea)
  - [Accessing Gitea](#accessing-gitea)
    - [Local Access](#local-access)
    - [Network Access](#network-access)
  - [Creating a Repository](#creating-a-repository)
  - [Authentication](#authentication)
    - [Setting Up SSH Authentication (Recommended)](#setting-up-ssh-authentication-recommended)
    - [HTTP Authentication](#http-authentication)
  - [Working with Repositories](#working-with-repositories)
    - [Creating a New Repository](#creating-a-new-repository)
    - [Pushing an Existing Repository](#pushing-an-existing-repository)
  - [External Access](#external-access)
    - [Setting Up Router Port Forwarding](#setting-up-router-port-forwarding)
  - [Troubleshooting](#troubleshooting)
    - [Authentication Problems](#authentication-problems)
    - [Repository Issues](#repository-issues)

## Prerequisites

- Docker Desktop for Mac installed
- Git installed
- Basic understanding of Git and Docker

## Starting Gitea

The setup files are already prepared. To start Gitea:

```bash
# Clone and navidate to the repository
git clone https://github.com/th2nhb1nh/gitea.git && cd gitea

# Make the startup script executable if it's not already
chmod +x start-gitea.sh

# Run the startup script
./start-gitea.sh
```

This will:
1. Detect your local network IP address
2. Start Gitea with PostgreSQL using Docker Compose
3. Display access URLs for local and network access

## Accessing Gitea

### Local Access
- Web UI: `http://localhost:3000`
- Git SSH: `ssh://git@localhost:2222`
- Git HTTP: `http://localhost:3000/username/repo.git`

### Network Access
- Web UI: `http://your-mac-ip:3000`
- Git SSH: `ssh://git@your-mac-ip:2222`
- Git HTTP: `http://your-mac-ip:3000/username/repo.git`

## Creating a Repository

1. Access the Gitea web UI at `http://localhost:3000`
2. Complete the initial setup if this is your first time
3. Create a user account or log in
4. Click the "+" icon in the top right corner and select "New Repository"
5. Fill in repository details:
   - Owner: Your username
   - Repository Name: Your project name
   - Description (optional)
   - Choose visibility (Public/Private)
   - Initialize options (leave unchecked for existing repositories)
6. Click "Create Repository"

## Authentication

### Setting Up SSH Authentication (Recommended)

1. Generate an SSH key if you don't have one:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. Copy your public key:
   ```bash
   cat ~/.ssh/id_ed25519.pub | pbcopy
   ```

3. Add the key to Gitea:
   - Go to Gitea settings: `http://localhost:3000/user/settings/keys`
   - Click "Add Key"
   - Paste your public key and give it a title
   - Click "Add Key"

4. Test your SSH connection:
   ```bash
   ssh -T git@localhost -p 2222
   ```

5. Add this to your `~/.ssh/config` for convenience:
   ```
   Host gitea-local
     HostName localhost
     User git
     Port 2222
     IdentityFile ~/.ssh/id_ed25519
   ```

### HTTP Authentication

When pushing using HTTP, you'll be prompted for your Gitea username and password. To store credentials:

```bash
git config credential.helper store
```

## Working with Repositories

### Creating a New Repository

1. Create repository on Gitea via web UI
2. Initialize locally:
   ```bash
   mkdir my-project
   cd my-project
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin ssh://git@localhost:2222/username/my-project.git
   git push -u origin main
   ```

### Pushing an Existing Repository

```bash
cd existing-project
git remote add origin ssh://git@localhost:2222/username/existing-project.git
git push -u origin --all
git push origin --tags
```

## External Access

### Setting Up Router Port Forwarding

To access Gitea from outside your network:

1. Log in to your router's admin panel
2. Set up port forwarding:
   - Forward external port 3000 → internal port 3000 (TCP)
   - Forward external port 2222 → internal port 2222 (TCP)
   - Point both to your Mac's internal IP address

## Troubleshooting

### Authentication Problems

1. For SSH issues:
   - Verify your SSH key is correctly added to Gitea
   - Test SSH connection: `ssh -T git@localhost -p 2222`
   - Check SSH debugging: `ssh -vT git@localhost -p 2222`

2. For HTTP issues:
   - Verify your username and password
   - Check if you have two-factor authentication enabled

### Repository Issues

If having problems with repository operations:

1. Verify remote URL:
   ```bash
   git remote -v
   ```

2. Make sure your user has appropriate permissions
3. Try cloning the repository fresh to verify access:
   ```bash
   git clone ssh://git@localhost:2222/username/repo.git test-clone
   ```