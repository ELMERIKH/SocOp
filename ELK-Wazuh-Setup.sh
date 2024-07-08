#!/bin/bash

apt-get install apt-transport-https zip unzip lsb-release curl gnupg
curl -s https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/elasticsearch.gpg --import && chmod 644 /usr/share/keyrings/elasticsearch.gpg
echo "deb [signed-by=/usr/share/keyrings/elasticsearch.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
apt-get update
apt-get install elasticsearch=7.17.13
curl -so /etc/elasticsearch/elasticsearch.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/elasticsearch_all_in_one.yml
curl -so /usr/share/elasticsearch/instances.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/instances_aio.yml
/usr/share/elasticsearch/bin/elasticsearch-certutil cert ca --pem --in instances.yml --keep-ca-key --out ~/certs.zip
unzip ~/certs.zip -d ~/certs
mkdir /etc/elasticsearch/certs/ca -p
cp -R ~/certs/ca/ ~/certs/elasticsearch/* /etc/elasticsearch/certs/
chown -R elasticsearch: /etc/elasticsearch/certs
chmod -R 500 /etc/elasticsearch/certs
chmod 400 /etc/elasticsearch/certs/ca/ca.* /etc/elasticsearch/certs/elasticsearch.*
rm -rf ~/certs/ ~/certs.zip
systemctl daemon-reload
systemctl enable elasticsearch
systemctl start elasticsearch
output=$(/usr/share/elasticsearch/bin/elasticsearch-setup-passwords auto)

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Passwords generated successfully."
    echo "$output" > passwords.txt
else
    echo "Failed to generate passwords."
    exit 1
fi

# Extract the Elastic user password and store it
elastic_password=$(echo "$output" | grep 'PASSWORD elastic =' | awk '{print $4}')

# Store the Elastic password in a separate file
echo $elastic_password > elastic_password.txt

echo "Elastic password stored in elastic_password.txt"

curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list
apt-get update
apt-get install wazuh-manager=4.5.4-1
systemctl daemon-reload
systemctl enable wazuh-manager
systemctl start wazuh-manager
apt-get install filebeat=7.17.13
curl -so /etc/filebeat/filebeat.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/filebeat_all_in_one.yml
curl -so /etc/filebeat/wazuh-template.json https://raw.githubusercontent.com/wazuh/wazuh/v4.5.4/extensions/elasticsearch/7.x/wazuh-template.json
chmod go+r /etc/filebeat/wazuh-template.json
curl -s https://packages.wazuh.com/4.x/filebeat/wazuh-filebeat-0.2.tar.gz | tar -xvz -C /usr/share/filebeat/module

#!/bin/bash

# Path to the Filebeat configuration file
FILEBEAT_CONFIG_FILE="/etc/filebeat/filebeat.yml"

# Read the generated Elastic password from the file
ELASTIC_PASSWORD=$(cat elastic_password.txt)

# Check if the Filebeat config file exists
if [ ! -f "$FILEBEAT_CONFIG_FILE" ]; then
    echo "Filebeat configuration file does not exist: $FILEBEAT_CONFIG_FILE"
    exit 1
fi

# Use sed to replace the placeholder with the actual password
sed -i "s/output.elasticsearch.password: <elasticsearch_password>/output.elasticsearch.password: $ELASTIC_PASSWORD/g" "$FILEBEAT_CONFIG_FILE"

echo "Updated output.elasticsearch.password in $FILEBEAT_CONFIG_FILE"

cp -r /etc/elasticsearch/certs/ca/ /etc/filebeat/certs/
cp /etc/elasticsearch/certs/elasticsearch.crt /etc/filebeat/certs/filebeat.crt
cp /etc/elasticsearch/certs/elasticsearch.key /etc/filebeat/certs/filebeat.key
systemctl daemon-reload
systemctl enable filebeat
systemctl start filebeat
apt-get install kibana=7.17.13
mkdir /etc/kibana/certs/ca -p
cp -R /etc/elasticsearch/certs/ca/ /etc/kibana/certs/
cp /etc/elasticsearch/certs/elasticsearch.key /etc/kibana/certs/kibana.key
cp /etc/elasticsearch/certs/elasticsearch.crt /etc/kibana/certs/kibana.crt
chown -R kibana:kibana /etc/kibana/
chmod -R 500 /etc/kibana/certs
chmod 440 /etc/kibana/certs/ca/ca.* /etc/kibana/certs/kibana.*
curl -so /etc/kibana/kibana.yml https://packages.wazuh.com/4.5/tpl/elastic-basic/kibana_all_in_one.yml
#!/bin/bash

# Path to the Kibana configuration file
KIBANA_CONFIG_FILE="/etc/kibana/kibana.yml"

# Read the generated Elastic password from the file
ELASTIC_PASSWORD=$(cat elastic_password.txt)

# Check if the Kibana config file exists
if [ ! -f "$KIBANA_CONFIG_FILE" ]; then
    echo "Kibana configuration file does not exist: $KIBANA_CONFIG_FILE"
    exit 1
fi

# Use sed to replace the placeholder with the actual password
sed -i "s/elasticsearch.password: <elasticsearch_password>/elasticsearch.password: $ELASTIC_PASSWORD/g" "$KIBANA_CONFIG_FILE"

echo "Updated elasticsearch.password in $KIBANA_CONFIG_FILE"
mkdir /usr/share/kibana/data
chown -R kibana:kibana /usr/share/kibana
cd /usr/share/kibana
sudo -u kibana /usr/share/kibana/bin/kibana-plugin install https://packages.wazuh.com/4.x/ui/kibana/wazuh_kibana-4.5.4_7.17.13-1.zip
setcap 'cap_net_bind_service=+ep' /usr/share/kibana/node/bin/node
systemctl daemon-reload
systemctl enable kibana
systemctl start kibana