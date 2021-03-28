#!/usr/bin/env bashio
set +u

CONFIG_PATH=/data/options.json
SYSTEM_USER=/data/system_user.json
MQTT_HOST=$(bashio::services "mqtt" "host")
MQTT_USER=$(bashio::services "mqtt" "username")
MQTT_PASSWORD=$(bashio::services "mqtt" "password")
GPIO_PIN=$(jq --raw-output ".gpio_pin" $CONFIG_PATH)

#echo "config ($CONFIG_PATH):"
#cat $CONFIG_PATH
#echo
#echo "GPIO_PIN: $GPIO_PIN"
#echo "MQTT_HOST=$MQTT_HOST"
#echo "MQTT_USER=$MQTT_USER"
#echo "MQTT_PASSWORD=$MQTT_PASSWORD"

#put pin & mqtt-values in the ini-file template
sudo sed -e "s/\$GPIO_PIN/$GPIO_PIN/" -e "s/\$MQTT_HOST/$MQTT_HOST/" -e "s/\$MQTT_USER/$MQTT_USER/" -e "s/\$MQTT_PASSWORD/$MQTT_PASSWORD/" /etc/nexus433.ini.txt > /etc/nexus433_addon.ini
#cat /etc/nexus433_addon.ini

#sudo gpioinfo

echo "Starting nexus433:"
sudo /usr/local/bin/nexus433/nexus433 --verbose -g /etc/nexus433_addon.ini

# sudo systemctl enable nexus433
