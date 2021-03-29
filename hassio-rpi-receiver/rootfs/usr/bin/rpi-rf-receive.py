#!/usr/bin/env python3
import argparse
import signal
import sys
import time
import logging
import io, os, shutil
from datetime import datetime
from rpi_rf import RFDevice

rfdevice = None

# pylint: disable=unused-argument
def exithandler(signal, frame):
    rfdevice.cleanup()
    sys.exit(0)

levels = {
    'trace': logging.DEBUG,
    'debug': logging.DEBUG,
    'info': logging.INFO,
    'notice': logging.INFO,
    'warning': logging.WARNING,
    'error': logging.ERROR,
    'fatal': logging.CRITICAL
}

parser = argparse.ArgumentParser(description='Receives a decimal code via a 433/315MHz GPIO device')
parser.add_argument('--valid-codes', nargs='*', type=int)
parser.add_argument('--log-level', choices=list(levels.keys()), help="Provide logging level")
parser.add_argument('-g', dest='gpio', type=int, default=27, help="GPIO pin (Default: 27)")
parser.add_argument('--mqtt-host', required=True)
parser.add_argument('--mqtt-port', required=True)
parser.add_argument('--mqtt-user', required=True)
parser.add_argument('--mqtt-password', required=True)
parser.add_argument('--mqtt-test', required=True)
args = parser.parse_args()

logging.basicConfig(level=levels.get(args.log_level), datefmt='%Y-%m-%d %H:%M:%S', format='[%(asctime)-15s] %(levelname)s %(module)s: %(message)s', )
logging.debug(f"rf codes to listen for: {args.valid_codes}")

if args.mqtt_test:
    logging.info(f"MQTT test messsage: sending 'hello world' to 'test/topic")
    os.system(f"mosquitto_pub -V mqttv311 -h {args.mqtt_host} -p {args.mqtt_port} -t 'test/topic' -u {args.mqtt_user} -P {args.mqtt_password} -m 'hello world'")

signal.signal(signal.SIGINT, exithandler)
rfdevice = RFDevice(args.gpio)
rfdevice.enable_rx()

timestamp = None
last_code = 0
last_sent = datetime.min
command=f"mosquitto_pub -V mqttv311 -h {args.mqtt_host} -p {args.mqtt_port} -t 'sensors/rf/receiver2' -u {args.mqtt_user} -P {args.mqtt_password}"
logging.info("Listening for codes on GPIO " + str(args.gpio))
while True:
    if rfdevice.rx_code_timestamp != timestamp:
        if not args.valid_codes or rfdevice.rx_code in args.valid_codes:
            if rfdevice.rx_code != last_code or (datetime.now() - last_sent).total_seconds() > 3:
                timestamp = rfdevice.rx_code_timestamp
                logging.info(f"{rfdevice.rx_code} [pulselength {rfdevice.rx_pulselength}, protocol {rfdevice.rx_proto}]")
                os.system(f"{command} -m {rfdevice.rx_code}")
                last_code = rfdevice.rx_code
                last_sent = datetime.now()
        else:
            logging.debug(f"received unvalid code: {rfdevice.rx_code}")
    time.sleep(0.5)
rfdevice.cleanup()
