#!/usr/bin/env python3

"""A MQTT to InfluxDB Bridge
This script receives MQTT data and saves those to InfluxDB.
"""

import re
import os
import datetime
from typing import NamedTuple

import paho.mqtt.client as mqtt
from influxdb import InfluxDBClient

INFLUXDB_ADDRESS = os.environ['INFLUXDB_HOST']
INFLUXDB_USER = os.environ['INFLUXDB_USER']
INFLUXDB_PASSWORD = os.environ['INFLUXDB_PASSWORD']
INFLUXDB_DATABASE = os.environ['INFLUXDB_DB']

MQTT_ADDRESS = os.environ['MQTT_HOST']
# MQTT_USER = os.environ['MQTT_USER']
# MQTT_PASSWORD = os.environ['MQTT_PASSWORD']
MQTT_TOPIC = os.environ['MQTT_TOPIC']  # [bme280|mijia]/[temperature|humidity|battery|status]
MQTT_REGEX = 'miflora/([^/]+)/([^/]+)'
MQTT_CLIENT_ID = 'MQTTInfluxDBBridge'

influxdb_client = InfluxDBClient(INFLUXDB_ADDRESS, 8086, INFLUXDB_USER, INFLUXDB_PASSWORD, None)


class SensorData(NamedTuple):
    battery: int
    temperature: float
    moisture: int
    light: int
    conductivity: int



def on_connect(client, userdata, flags, rc):
    """ The callback for when the client receives a CONNACK response from the server."""
    print('Connected with result code ' + str(rc))
    client.subscribe(MQTT_TOPIC)


def on_message(client, userdata, msg):
    """The callback for when a PUBLISH message is received from the server."""
    print(msg.topic + ' ' + str(msg.payload))
    sensor_data = _parse_mqtt_message(msg.payload.decode('utf-8'))
    if sensor_data is not None:
        _send_sensor_data_to_influxdb(sensor_data)


def _parse_mqtt_message(payload):
    light = payload.light
    temperature = payload.temperature
    moisture = payload.moisture
    conductivity = payload.conductivity
    battery = payload.battery
    return SensorData(battery, temperature, moisture, light, conductivity)


def _send_sensor_data_to_influxdb(sensor_data):
    json_body = [
        {
            "measurement": "monitor_reading",
            "tags": {
                "monitor": MQTT_REGEX
            },
            "time": datetime.now().strftime('%Y-%m-%dT%H:%M:%SZ'),
            "fields": {
                "battery": sensor_data.battery,
                "temperature": sensor_data.temp,
                "moisture": sensor_data.moisture,
                "light": sensor_data.light,
                "conductivity": sensor_data.conductivity
            }
        }
    ]
    influxdb_client.write_points(json_body)


def _init_influxdb_database():
    databases = influxdb_client.get_list_database()
    if len(list(filter(lambda x: x['name'] == INFLUXDB_DATABASE, databases))) == 0:
        influxdb_client.create_database(INFLUXDB_DATABASE)
    influxdb_client.switch_database(INFLUXDB_DATABASE)


def main():
    _init_influxdb_database()

    mqtt_client = mqtt.Client(MQTT_CLIENT_ID)
    # mqtt_client.username_pw_set(MQTT_USER, MQTT_PASSWORD)
    mqtt_client.on_connect = on_connect
    mqtt_client.on_message = on_message

    mqtt_client.connect(MQTT_ADDRESS, 1883)
    mqtt_client.loop_forever()


if __name__ == '__main__':
    print('MQTT to InfluxDB bridge')
    main()
