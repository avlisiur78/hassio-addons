# Wifi Hotspot
Enables an access point using the RPi4 internal Wifi or a USB Wifi dongle, on your Home Assistant (with embedded DHCP server).
This is mostly useful if you want to have a different network infrastructure for your IoT devices.

Please note that in some cases you can't do it with the RPi onboard Wifi, due to stability issues (not related to hostapd).

It allows the creation of an access point **with optional a DHCP server**, using, the internal RPi4 Wifi or external USB Wifi dongles, like, **Ralink, Atheros and others**. 
This project is a "spin-off"/fork from the "joaofl/hassio-addons", that already was a fork from hostapd addon and he rebranded, and I rebranded again..., and added a few more features that I need, like the possibility to hide ssid, domain name, blocking the traffic to the pre-existing intranet, etc.

## Installation

To use this repository in your own Hass.io installation please follow the official instructions available on the Home Assistant website (https://www.home-assistant.io/common-tasks/os#installing-third-party-add-ons) with the following URL:

```txt
https://github.com/avlisiur78/hassio-addons
```

### Configuration

The available configuration options are the following. Make sure to edit and adjust according to your needs:

```
{
    "ssid": "WIFI_NAME",
    "wpa_passphrase": "WIFI_PASSWORD",
    "channel": "0",
    "country": "US",
    "ignore_broadcast_ssid": "0",
    "address": "192.168.2.1",
    "netmask": "255.255.255.0",
    "broadcast": "192.168.2.254",
    "interface": "",
    "allow_internet": false,
    "block_intranet": true,
    "intranet_ip_range": "192.168.1.0/24",
    "intranet_ips_exclude": "192.168.1.1",
    "dhcp_server": true,
    "dhcp_start": "192.168.2.100",
    "dhcp_end": "192.168.2.200",
    "dhcp_dns": "1.1.1.1",
    "dhcp_subnet": "255.255.255.0",
    "dhcp_router": "192.168.2.1",
    "dhcp_domain": "local",
    "dhcp_lease": "864000",
    "dhcp_routes_enable": false,
    "dhcp_staticroutes": "",
    "dhcp_static_lease": []
}

```
When channel set to 0, it will automatically find the best channel. 

When the `interface` option is left blank, a list with the detected wlan interfaces will be printed on the logs and the addon will terminate. Set the correct `interface` value on the configuration then restart the addon.

It's possible to block the traffic between your IOT Wifi network and your main network, for that, use the option `block_intranet`, it's also possible to exclude some internal IP's from this blockade process, so you may define your "special" devices like, the router, the DNS server, or some other stuff:

    "intranet_ip_range": "192.168.1.0/24",    <---- Define the intranet IP range to block
    "intranet_ips_exclude": "192.168.1.1",    <---- Define the IPs to be excluded from the blockade

If you need to use `dhcp_staticroutes` the option `dhcp_routes_enable` should be equal to `true` and the string something like:

      10.0.0.0/8 10.127.0.1, 10.11.12.0/24 10.11.12.1

For definition of `dhcp_static_lease` please use this format:

      - name: hostname
        mac: '70:e9:76:22:41:ca'
        ip: 192.168.2.175

