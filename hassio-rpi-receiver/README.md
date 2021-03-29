# RPI RF Receiver

This addon is made to make the rpi-rf receiver script run in background of you hassio

- Install the addon
- Disable `Protection mode` in the addon Info page
- Edit Configuration if needed ( MQTT settings are auto discovered)
- Start the addon
- Add this sensor to read the codes in your hassio:
  ```yaml
  sensor:
    - platform: mqtt
      state_topic: "sensors/rf/receiver"
      name: "Pretty Name"
  ```

## Infos

- This addon has `full_access` setting to allow access to `/proc/device-tree/system/linux,revision`
  - Otherwise RPi.GPIO will issue error `This module can only be run on a Raspberry Pi!` on a Raspberry Pi 4
  - Settings in config.json like "devices", "privileged", or "devicetree" seem to not have any effect on the issue
- **Thus it is necessary to disable `Protection mode` in the addon Info page**
- `RPi.GPIO` version must be >=0.7.1a2 to fix compilation issue
  - other solution: `RUN env CFLAGS="-fcommon" pip3 install -U RPi.GPIO`

## Contributors

- https://github.com/pantomax/hassio-addons
- https://github.com/masci1234/hassio-addons
- https://github.com/CarstenHess/hassio-addons
