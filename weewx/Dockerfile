ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN wget -qO - https://weewx.com/keys.html | sudo gpg --dearmor --output /etc/apt/trusted.gpg.d/weewx.gpg \
      && wget -qO - https://weewx.com/apt/weewx-python3.list | sudo tee /etc/apt/sources.list.d/weewx.list

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata 

RUN apt-get install -y supervisor jq cmake libusb-1.0-0-dev build-essential autoconf libtool pkg-config \
    python3-configobj python3-pil python3-serial python3-usb python3-pip python3-ephem mariadb-client python3-mysqldb git wget sudo weewx

RUN sudo pip3 install Cheetah3

RUN git clone git://git.osmocom.org/rtl-sdr.git && \
      cd rtl-sdr && \
      mkdir build && \
      cd build && \
      cmake -DINSTALL_UDEV_RULES=ON .. && \
      make && \
      sudo make install && \
      sudo ldconfig

RUN git clone https://github.com/merbanan/rtl_433  && \
      cd rtl_433 && \
      mkdir build && \
      cd build && \
      cmake .. && \
      make && \
      sudo make install

RUN wget https://github.com/eclipse/paho.mqtt.python/archive/v1.4.0.tar.gz -O /tmp/mqtt.tgz && \
      cd /tmp && \
      tar zxvf /tmp/mqtt.tgz && \
      cd paho.mqtt.python-* ; sudo python3 setup.py build ; sudo python3 setup.py install

RUN wget http://lancet.mit.edu/mwall/projects/weather/releases/weewx-mqtt-0.19.tgz -O /tmp/weewx-mqtt.tgz && \
      /home/weewx/bin/wee_extension --install /tmp/weewx-mqtt.tgz

RUN sudo cp /home/weewx/util/apache/conf-available/weewx.conf /etc/apache2/conf-available && \
      sudo ln -s /etc/apache2/conf-available/weewx.conf /etc/apache2/conf-enabled

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh
EXPOSE 80

CMD [ "/run.sh" ]