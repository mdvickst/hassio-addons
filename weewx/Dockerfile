ARG BUILD_FROM
FROM  $BUILD_FROM

ENV LANG C.UTF-8

RUN apt-get update \
    && apt-get install -y supervisor tzdata jq cmake libusb-1.0-0-dev build-essential autoconf libtool pkg-config \
    python3-configobj python3-pil python3-serial python3-usb python3-pip python3-ephem mariadb-client python3-mysqldb git wget sudo

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

# install weeWX
RUN wget http://weewx.com/downloads/released_versions/weewx-4.8.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; python3 ./setup.py build ; sudo python3 ./setup.py install --no-prompt

RUN wget https://github.com/eclipse/paho.mqtt.python/archive/v1.4.0.tar.gz -O /tmp/mqtt.tgz && \
      cd /tmp && \
      tar zxvf /tmp/mqtt.tgz && \
      cd paho.mqtt.python-* ; sudo python3 setup.py build ; sudo python3 setup.py install

RUN wget http://lancet.mit.edu/mwall/projects/weather/releases/weewx-mqtt-0.19.tgz -O /tmp/weewx-mqtt.tgz && \
      /home/weewx/bin/wee_extension --install /tmp/weewx-mqtt.tgz

# Copy data for add-on
COPY run.sh /
RUN chmod a+x /run.sh


CMD [ "/run.sh" ]