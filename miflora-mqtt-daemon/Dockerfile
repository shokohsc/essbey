FROM python:3-stretch
MAINTAINER Pommier Dimitri <shokohsc@gmail.com>

RUN mkdir -p /app
WORKDIR /app

RUN apt-get update && apt-get install -y bluez

COPY requirements.txt requirements.txt
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

ADD requirements.txt /app/requirements.txt
ADD miflora-mqtt-daemon.py /app/miflora-mqtt-daemon.py

CMD [ "python3", "./miflora-mqtt-daemon.py" ]
