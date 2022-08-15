ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8


RUN apt-get update && apt-get install -y sqlite3 wget sudo \
         python3-configobj python3-pil python3-usb python3-pip python3-setuptools \
         supervisor jq git apache2 python3-paho-mqtt

RUN pip3 install Cheetah3

# install weeWX
RUN wget http://weewx.com/downloads/released_versions/weewx-4.8.0.tar.gz -O /tmp/weewx.tgz && \
      cd /tmp && \
      tar zxvf /tmp/weewx.tgz && \
      cd weewx-* ; python3 ./setup.py build ; sudo python3 ./setup.py install --no-prompt

RUN cd /home && wget https://github.com/bellrichm/WeeWX-MQTTSubscribe/archive/refs/tags/v2.1.0.tar.gz && \
      MQTTSubscribe_install_type=DRIVER /home/weewx/bin/wee_extension --install=v2.1.0.tar.gz 

RUN sudo cp /home/weewx/util/apache/conf-available/weewx.conf /etc/apache2/conf-available && \
      sudo ln -s /etc/apache2/conf-available/weewx.conf /etc/apache2/conf-enabled

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]