FROM python:alpine

ENV WORKDIR "/app"

ADD requirements.txt /app/requirements.txt
ADD forwarder.py /app/forwarder.py
ADD password /app/password

RUN pip3 install -r /app/requirements.txt

WORKDIR ${WORKDIR}

ENTRYPOINT ["python", "/app/forwarder", "--mqtt-host", "mosquitto", "--influx-host", "influxdb", "--influx-user", "miflora", "--influx-pass-file", "/app/password", "--influx-db", "miflora", "--node-name", "Jacob", "--verbose"]
