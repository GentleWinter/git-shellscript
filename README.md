# Git Credentials Setup Script for Linux

This is a Bash script to **securely configure Git credentials** on Linux, with support for both **HTTPS** (using token/password storage) and **SSH** (with key generation and GitHub integration).

## Features

- Set Git global username and email  
- Choose between HTTPS or SSH authentication  
- Automatically:
  - Configure credential helper for HTTPS  
  - Generate and register SSH keys  
- Streamline your Git workflow across projects

## Prerequisites

- Git installed (`sudo apt install git`)  
- `ssh` installed (for SSH setup)  
- GitHub account (for SSH key registration)

## Usage

1. Clone or download this repository.
2. Make the script executable:
   ```bash
   chmod +x git-setup.sh
3. Run the script:
   ```bash
   ./configurar-ssh-github.sh
4. The promt will guide you to:
  - Enter your Git name and email
  - Choose HTTPS or SSH
  - For SSH: You'll be guided to add the key to GitHub
