#!/bin/bash
"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt install -y docker.io
sudo apt install docker-compose
sudo groupadd docker
sudo usermod -aG docker $USER
sudo groupadd docker-compose
sudo usermod -aG docker-compose $USER
"
# Redémarrer le système (Nécessaire)

read -p "Voulez-vous reboot le système ? (Y/N): " confirmation

# Confirmation
if [[ "$confirmation" == "oui" || "$confirmation" == "Oui" ||"$confirmation" == "OUI" || "$confirmation" == "o" ||"$confirmation" == "O" || "$confirmation" == "Yes" || "$confirmation" == "YES" || "$confirmation" == "yes" || "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
	echo "Redémarrage..."
	sudo shutdown -r now
elif
	[[ "$confirmation" == "o" ]]; then
	sudo shutdown -r now
else
	echo "Redémarrage annulé..."
fi
