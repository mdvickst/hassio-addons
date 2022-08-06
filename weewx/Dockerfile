ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

RUN apk upgrade && apk add --no-cache --virtual .buildDeps \
    build-base libusb-dev librtlsdr-dev cmake git sqlite wget py3-configobj py3-cheetah py3-pillow py3-usb py3-setuptools supervisor tzdata jq  autoconf libtool pkgconf sudo

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
RUN ln -s /usr/bin/python3 /usr/bin/python && wget http://weewx.com/downloads/released_versions/weewx-4.8.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; ./setup.py build ; ./setup.py install --no-prompt

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
