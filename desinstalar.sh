

# Eliminar Ollama

ollama logout 
sudo systemctl stop ollama
sudo systemctl disable ollama
sudo rm /etc/systemd/system/ollama.service
sudo rm $(which ollama)
sudo rm -r /usr/share/ollama
sudo userdel ollama
sudo groupdel ollama

