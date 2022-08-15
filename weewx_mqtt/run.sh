#!/bin/bash

CONFIG_PATH=/data/options.json

LATITUDE="$(jq --raw-output '.latitude' $CONFIG_PATH)"
LONGITUDE="$(jq --raw-output '.longitude' $CONFIG_PATH)"
ALTITUDE="$(jq --raw-output '.altitude' $CONFIG_PATH)"
ALTITUDEUNIT="$(jq --raw-output '.altitudeUnit' $CONFIG_PATH)"
LOCATION="$(jq --raw-output '.location' $CONFIG_PATH)"
UNITS="$(jq --raw-output '.units' $CONFIG_PATH)"
MQTTUSER="$(jq --raw-output '.mqttUser' $CONFIG_PATH)"
MQTTPASSWORD="$(jq --raw-output '.mqttPassword' $CONFIG_PATH)"

/home/weewx/bin/wee_config --reconfigure --latitude=$LATITUDE --longitude=$LONGITUDE --altitude=$ALTITUDE,$ALTITUDEUNIT --location=$LOCATION --units=$UNITS --no-prompt --config=/home/weewx/weewx.conf  

sed -i 's/archive_interval = 300/archive_interval = 60/g' /home/weewx/weewx.conf

sed -i 's/log_success = True/log_success = False/g' /home/weewx/weewx.conf
sed -r '$!N;s/(skin = Standard\n.*)enable = false/\1enabled = true/;P;D'  /home/weewx/weewx.conf > /home/weewx/weewxnew.conf; mv /home/weewx/weewxnew.conf /home/weewx/weewx.conf
sed -r '$!N;s/(skin = Mobile\n.*)enable = false/\1enabled = true/;P;D'  /home/weewx/weewx.conf > /home/weewx/weewxnew.conf; mv /home/weewx/weewxnew.conf /home/weewx/weewx.conf
echo '[MQTTSubscribeDriver]' >> /home/weewx/weewx.conf
echo 'driver = user.MQTTSubscribe' >> /home/weewx/weewx.conf
echo 'host = 192.168.86.240' >> /home/weewx/weewx.conf
echo 'port = 1883' >> /home/weewx/weewx.conf
echo 'username = weewx-mqtt' >> /home/weewx/weewx.conf
echo 'password = 68wDju40JWTP' >> /home/weewx/weewx.conf
echo '[[message_callback]]' >> /home/weewx/weewx.conf
echo 'type = individual' >> /home/weewx/weewx.conf
echo '[[topics]]' >> /home/weewx/weewx.conf
echo 'unit_system = US' >> /home/weewx/weewx.conf
echo '[[[rtl_433/9b13b3f4-rtl433/devices/Acurite-5n1/A/1478/temperature_F]]]' >> /home/weewx/weewx.conf
echo '[[[rtl_433/9b13b3f4-rtl433/devices/Acurite-5n1/A/1478/humidity]]]' >> /home/weewx/weewx.conf
echo '[[[rtl_433/9b13b3f4-rtl433/devices/Acurite-5n1/A/1478/rain_in]]]' >> /home/weewx/weewx.conf
echo '[[[rtl_433/9b13b3f4-rtl433/devices/Acurite-5n1/A/1478/wind_dir_deg]]]' >> /home/weewx/weewx.conf
echo '[[[rtl_433/9b13b3f4-rtl433/devices/Acurite-5n1/A/1478/wind_avg_km_h]]]' >> /home/weewx/weewx.conf

sed -i 's/Listen 80/Listen 8089/g' /etc/apache2/ports.conf

sudo cp /home/weewx/util/apache/conf-available/weewx.conf /etc/apache2/conf-available
sudo ln -s /etc/apache2/conf-available/weewx.conf /etc/apache2/conf-enabled

apachectl start
/home/weewx/bin/weewxd /home/weewx/weewx.conf
#sleep infinity
