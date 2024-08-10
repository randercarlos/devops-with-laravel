#!/bin/bash


SSH_CONFIG_FILE="/etc/ssh/sshd_config"
BACKUP_FILE="/etc/ssh/sshd_config.bak"
CLIENT_ALIVE_INTERVAL="300"
CLIENT_ALIVE_COUNT_MAX="3"

NEW_USER="apprunner"
COPY_FROM_USER="ubuntu"

# create a new user duplicating all permissions and configs from user "ubuntu" and adding root permissions
if id "$NEW_USER" &>/dev/null; then
    # Create a new user
    sudo adduser $NEW_USER

    # Add the new user to the sudo group
    sudo usermod -aG sudo $NEW_USER

    # Copy files from the ubuntu user to the new user
    sudo cp -r /home/$COPY_FROM_USER/.bashrc /home/$COPY_FROM_USER/.profile /home/$COPY_FROM_USER/.ssh /home/$NEW_USER/

    # Set correct ownership
    sudo chown -R $NEW_USER:$NEW_USER /home/$NEW_USER/

    # Display the result
    echo "New user $NEW_USER has been created and given sudo privileges, duplicating the $COPY_FROM_USER user."

    # Switch to the new user
    su - $NEW_USER
fi


# change configs to SSH(increase connection time)
if [ -f "$SSH_CONFIG_FILE" ]; then
  # Create a backup of the SSH configuration file
    echo "Creating a backup of the SSH configuration file..."
    sudo cp "$SSH_CONFIG_FILE" "$BACKUP_FILE"
    echo "Backup created at $BACKUP_FILE"

    # Modify the SSH configuration file
    echo "Modifying the SSH configuration file..."
    sudo sed -i.bak -e "s/^#*ClientAliveInterval.*/ClientAliveInterval $CLIENT_ALIVE_INTERVAL/" \
                    -e "s/^#*ClientAliveCountMax.*/ClientAliveCountMax $CLIENT_ALIVE_COUNT_MAX/" "$SSH_CONFIG_FILE"

    # If the parameters don't exist, add them
    grep -q "^ClientAliveInterval" "$SSH_CONFIG_FILE" || echo "ClientAliveInterval $CLIENT_ALIVE_INTERVAL" | sudo tee -a "$SSH_CONFIG_FILE"
    grep -q "^ClientAliveCountMax" "$SSH_CONFIG_FILE" || echo "ClientAliveCountMax $CLIENT_ALIVE_COUNT_MAX" | sudo tee -a "$SSH_CONFIG_FILE"

    echo "SSH configuration updated."

    # Restart the SSH service to apply changes
    echo "Restarting SSH service..."
    sudo systemctl restart sshd

    # Check the status of the SSH service
    sudo systemctl status sshd | grep Active

    echo "Script execution completed."
else
    echo "SSH configuration file not found!"
    exit 1
fi