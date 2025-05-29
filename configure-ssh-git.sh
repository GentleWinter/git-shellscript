#!/bin/bash

echo "=== GIT CREDENTIALS CONFIGURATOR ==="

# Request user information
read -p "Enter your full name: " GIT_NAME
read -p "Enter your email: " GIT_EMAIL

# Set global Git username and email
git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"

# Choose authentication method
read -p "Do you want to use SSH or HTTPS for authentication? [ssh/https]: " AUTH_METHOD

if [ "$AUTH_METHOD" == "https" ]; then
    read -p "Enter your Git username: " GIT_USERNAME
    read -s -p "Enter your Git token/password: " GIT_PASSWORD
    echo

    git config --global credential.helper store
    echo "https://$GIT_USERNAME:$GIT_PASSWORD@github.com" > ~/.git-credentials
    echo "HTTPS credentials stored successfully."

elif [ "$AUTH_METHOD" == "ssh" ]; then
    SSH_KEY=~/.ssh/id_ed25519
    if [ -f "$SSH_KEY" ]; then
        echo "SSH key already exists at $SSH_KEY"
    else
        echo "Generating new SSH key..."
        ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$SSH_KEY" -N ""
        eval "$(ssh-agent -s)"
        ssh-add "$SSH_KEY"
    fi

    echo "Public key:
"
    cat "$SSH_KEY.pub"
    echo -e "\nVisit https://github.com/settings/keys and add the above public key."
    read -p "Press ENTER after adding the key to GitHub to continue..."

    echo "Testing SSH connection to GitHub..."
    ssh -T git@github.com || {
        echo "SSH test failed. Check your key on GitHub.";
        exit 1;
    }
    echo "SSH authentication set up successfully."
else
    echo "Invalid option. Please run the script again and choose ssh or https."
    exit 1
fi

echo "=== Git credentials configured successfully! ==="
echo "Reminder: use SSH URLs like git@github.com:user/repo.git if using SSH."
