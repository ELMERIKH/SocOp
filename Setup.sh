#!/bin/bash

while true; do
    OPTION=$(whiptail --title "SocOp installation" --menu "Choose an option:" 20 70 13 \
                    "1" "Update System and Install Prerequisites" \
                    "2" "Install Wazuh and Elastic stack localy" \
                    "3" "Install Docker" \
                    "4" "Install Shuffle (SOAR)" \
                    "5" "Install DFIR-IRIS (Incident Response Platform)" \
                    "6" "Install MISP" \
                    "7" "Setup IRIS <-> Wazuh Integration" \
                    "8" "Setup MISP <-> Wazuh Integration" \
                    "9" "Show Status" 3>&1 1>&2 2>&3)
    # Script version 1.0 updated 15 November 2023
    # Depending on the chosen option, execute the corresponding command
    case $OPTION in
    1)
        sudo apt-get update -y
        sudo apt-get upgrade -y
        sudo apt-get install wget curl nano git unzip -y
        ;;
    2)
     sudo chmod +x ELK-Wazuh-Setup.sh
     sudo ./ELK-Wazuh-Setup.sh
    3)
        # Check if Docker is installed
        if command -v docker > /dev/null; then
            echo "Docker is already installed."
        else
            # Install Docker
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
            sudo systemctl enable docker.service && sudo systemctl enable containerd.service
        fi
        ;;


    4)
        cd Shuffle
        sudo docker compose up -d
        ;;
    5)
        cd iris-web
        sudo docker network create shared-network
        sudo docker compose build
        sudo docker compose up -d
        ;;
 
    6)
        cd misp-docker
        IP=$(curl -s ip.me -4)
        sed -i "s|BASE_URL=.*|BASE_URL='https://$IP:1443'|" template.env
        cp template.env .env
        sudo docker compose up -d
        ;;
    7)
        cp Integration-Script/custom-iris.py /var/ossec/integrations/custom-iris.py
        sudo chown root:wazuh /var/ossec/integrations/custom-iris.py
        sudo chmod 750 /var/ossec/integrations/custom-iris.py
        sudo apt update -y
        sudo apt install python3-pip -y
        sudo pip3 install requests
        cd wazuh && sudo docker compose restart
        ;;
    8)
        cp Integrations-Scripts/custom-misp.py /var/ossec/integrations/custom-misp.py
        sudo chown root:wazuh /var/ossec/integrations/custom-misp.py
        sudo chmod 750 /var/ossec/integrations/custom-misp.py
        cp Integrations-Scripts/local_rules.xml /var/ossec/etc/rules/local_rules.xml
        sudo chown wazuh:wazuh /var/ossec/etc/rules/local_rules.xml
        sudo chmod 550 /var/ossec/etc/rules/local_rules.xml
        cd wazuh && sudo docker compose restart
        ;;
    9)
        sudo docker ps
        ;;
esac
    # Give option to go back to the previous menu or exit
    if (whiptail --title "Exit" --yesno "Do you want to exit the script?" 8 78); then
        break
    else
        continue
    fi
done