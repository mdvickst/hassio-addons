ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk add sqlite3 wget \
         python-configobj python-cheetah python-pil python-usb python-setuptools \
         supervisor tzdata jq cmake libusb-1.0-0-dev build-essential autoconf libtool pkg-config git

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

# install weeWX
RUN wget -qO - http://weewx.com/keys.html | sudo apt-key add - && \
      wget -qO - http://weewx.com/apt/weewx.list | sudo tee /etc/apt/sources.list.d/weewx.list && \
      sudo apt-get update && \
      sudo apt-get install weewx && \

      # shut down weeWX
      sudo /etc/init.d/weewx stop && \

      # install weewx-sdr extension and enable the driver
      git clone https://github.com/matthewwall/weewx-sdr.git && \
      sudo wee_extension --install weewx-sdr && \
      sudo wee_config --reconfigure

RUN wget https://github.com/eclipse/paho.mqtt.python/archive/v1.4.0.tar.gz -O /tmp/mqtt.tgz && \
      cd /tmp && \
      tar zxvf /tmp/mqtt.tgz && \
      cd paho.mqtt.python-* ; sudo python setup.py build ; sudo python setup.py install

RUN wget http://lancet.mit.edu/mwall/projects/weather/releases/weewx-mqtt-0.19.tgz -O /tmp/weewx-mqtt.tgz && \
      cd /tmp && \
      /home/weewx/bin/wee_extension --install weewx-mqtt.tgz

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
