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

sudo rtl_433 -M utc -F json

sudo PYTHONPATH=/usr/share/weewx python /usr/share/weewx/user/sdr.py --cmd="rtl_433 -M utc -F json"

/home/weewx/bin/wee_config --reconfigure --latitude=$LATITUDE --longitude=$LONGITUDE --altitude=$ALTITUDE,$ALTITUDEUNIT --location=$LOCATION --units=$UNITS --no-prompt --config=/home/weewx/weewx.conf

sed -i '/192.168.86.240/ a \
\ \ \ \ \ \ \ \ topic = weather\
\ \ \ \ \ \ \ \ unit_system = US\
' /home/weewx/weewx.conf  

sed -i 's/192.168.86.240/mqtt:\/\/'$MQTTUSER':'$MQTTPASSWORD'@core-mosquitto:1883/g' /home/weewx/weewx.conf

sed -i 's/archive_interval = 300/archive_interval = 60/g' /home/weewx/weewx.conf

sed -i 's/log_success = True/log_success = False/g' /home/weewx/weewx.conf

/home/weewx/bin/weewxd /home/weewx/weewx.conf
#sleep infinity
