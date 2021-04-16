# Wifi Hotspot
Enables an access point using USB Wifi dongle on Home Assistant (with embedded DHCP server).
This is mostly usefull if you want to have a different network infrastructure for your IoT devices, and can not do it with the RPi onboard Wifi, due to stabilities issue. 

It allows creating an access point **with optional a DHCP server**, using external USB Wifi dongles, **Ralink, Atheros and others**. 
This project is a "spin-off"/fork from the "joaofl/hassio-addons", that already was a fork from hostapd addon and he rebranded, and I rebranded again..., and add a few more features that I need, like the possibility to hide ssid, domain name, etc.

## Installation

To use this repository in your own Hass.io installation please follow the official instructions available on the Home Assistant website (https://www.home-assistant.io/common-tasks/os#installing-third-party-add-ons) with the following URL:

```txt
https://github.com/avlisiur78/hassio-addons
```

### Configuration

The available configuration options are the following. Make sure to edit and ajust according to your needs:

```
{
    "ssid": "WIFI_NAME",
    "wpa_passphrase": "WIFI_PASSWORD",
    "channel": "0",
    "country": "US",
    "ignore_broadcast_ssid": "0",
    "address": "192.168.2.1",
    "netmask": "255.255.255.0",
    "broadcast": "192.168.2.254"
    "interface": ""
    "allow_internet": false
    "dhcp_server": true
    "dhcp_start": "192.168.2.100",
    "dhcp_end": "192.168.2.200",
    "dhcp_dns": "1.1.1.1",
    "dhcp_subnet": "255.255.255.0",
    "dhcp_router": "192.168.2.1",
    "dhcp_domain": "local",
    "dhcp_lease": "864000"
    "dhcp_dhcp_routes_enable": false
    "dhcp_dhcp_staticroutes": ""
    "dhcp_static_lease": []
}

```
When channel set to 0, it will automatically find the best channel. 

When the `interface` option is left blank, a list with the detected wlan interfaces will be printed on the logs and the addon will terminate. Set the correct `interface` value on the configuration then restart the addon.

The definition of `staticroutes` should be, something like:

      10.0.0.0/8 10.127.0.1, 10.11.12.0/24 10.11.12.1

For definition of `dhcp_static_lease` please use this format:

      - name: hostname
        mac: '70:e9:76:22:41:ca'
        ip: 192.168.2.175
      
