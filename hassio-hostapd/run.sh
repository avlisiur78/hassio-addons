#!/bin/bash

# ===================================================
# Functions
# ===================

reset_interfaces(){
    ifdown $INTERFACE
    sleep 2
    ip link set $INTERFACE down
    ip addr flush dev $INTERFACE
}

stop_signal(){
    echo "Reseting interfaces"
    reset_interfaces
    echo "Stopping..."
    exit 0
}

# ===================================================
# On SIGTERM aka 'docker stop' this function will be executed
# ===================

trap 'stop_signal' SIGTERM

# ===================================================

echo "Starting config..."

CONFIG_PATH=/data/options.json

SSID=$(jq --raw-output ".ssid" $CONFIG_PATH)
WPA_PASSPHRASE=$(jq --raw-output ".wpa_passphrase" $CONFIG_PATH)
CHANNEL=$(jq --raw-output ".channel" $CONFIG_PATH)
COUNTRY=$(jq --raw-output ".country" $CONFIG_PATH)
BROADCASTSSID=$(jq --raw-output ".ignore_broadcast_ssid" $CONFIG_PATH)
ADDRESS=$(jq --raw-output ".address" $CONFIG_PATH)
NETMASK=$(jq --raw-output ".netmask" $CONFIG_PATH)
BROADCAST=$(jq --raw-output ".broadcast" $CONFIG_PATH)
INTERFACE=$(jq --raw-output ".interface" $CONFIG_PATH)
ALLOW_INTERNET=$(jq --raw-output ".allow_internet" $CONFIG_PATH)
BLOCK_INTRANET=$(jq --raw-output ".block_intranet" $CONFIG_PATH)
INTRANET_IP_RANGE=$(jq --raw-output ".intranet_ip_range" $CONFIG_PATH)
INTRANET_IPS_EXCLUDE=$(jq --raw-output ".intranet_ips_exclude" $CONFIG_PATH)

DHCP_SERVER=$(jq --raw-output ".dhcp_enable" $CONFIG_PATH)
DHCP_START=$(jq --raw-output ".dhcp_start" $CONFIG_PATH)
DHCP_END=$(jq --raw-output ".dhcp_end" $CONFIG_PATH)
DHCP_DNS=$(jq --raw-output ".dhcp_dns" $CONFIG_PATH)
DHCP_SUBNET=$(jq --raw-output ".dhcp_subnet" $CONFIG_PATH)
DHCP_ROUTER=$(jq --raw-output ".dhcp_router" $CONFIG_PATH)
DHCP_DOMAIN=$(jq --raw-output ".dhcp_domain" $CONFIG_PATH)
DHCP_LEASE=$(jq --raw-output ".dhcp_lease" $CONFIG_PATH)
DHCP_ROUTES=$(jq --raw-output ".dhcp_routes_enable" $CONFIG_PATH)
DHCP_STATICROUTES=$(jq --raw-output ".dhcp_staticroutes" $CONFIG_PATH)
DHCP_STATIC=$(jq --raw-output '.dhcp_static_lease | join(" ")' $CONFIG_PATH)

OPENVPN_ACTIVE=$(jq --raw-output ".openvpn_active" $CONFIG_PATH)
OVPNFILE="$(jq --raw-output '.ovpnfile' $CONFIG_PATH)"
OPENVPN_CONFIG=/share/${OVPNFILE}

echo "Performing variables validations..."
required_vars=(SSID WPA_PASSPHRASE CHANNEL BROADCASTSSID ADDRESS NETMASK BROADCAST)
for required_var in "${required_vars[@]}"; do
    if [[ -z ${!required_var} ]]; then
        echo >&2 "Error: $required_var enviorment variable not set."
        exit 1
    fi
done

INTERFACES_AVAILABLE="$(ifconfig -a | grep wl | cut -d ' ' -f '1')"
UNKNOWN=true

# Check if interface is informed
if [[ -z ${INTERFACE} ]]; then
        echo >&2 "Network interface not set. Please set one of the available:"
        echo >&2 "${INTERFACES_AVAILABLE}"
        exit 1
fi

# Check if interface informed, exists
for OPTION in ${INTERFACES_AVAILABLE}; do
    if [[ ${INTERFACE} == ${OPTION} ]]; then
        UNKNOWN=false
    fi 
done

# If interface informed do not exist then
if [[ ${UNKNOWN} == true ]]; then
        echo >&2 "Unknown network interface ${INTERFACE}. Please set one of the available:"
        echo >&2 "${INTERFACES_AVAILABLE}"
        exit 1
fi

# Check what mask to use
echo "Checking mask to use..."
if [[ -z ${DHCP_SUBNET} ]]; then
        MASK=24
else
     if [[ ${DHCP_SUBNET} = '255.255.255.0' ]]; then
         MASK=24
     fi
     if [[ ${DHCP_SUBNET} = '255.255.252.0' ]]; then
         MASK=22
     fi
     if [[ ${DHCP_SUBNET} = '255.255.0.0' ]]; then
         MASK=16
     fi
     if [[ ${DHCP_SUBNET} = '255.0.0.0' ]]; then
         MASK=8
     fi
fi

echo "Set nmcli managed no"
nmcli dev set ${INTERFACE} managed no

echo "Network interface set to ${INTERFACE}"

# iptables rules
INTERNET_IF="eth0"

# deleting rules
echo "**** Deleting iptables ****"
echo "Deleting rules, may present errors, it's ok !!"
echo "=============================================="
iptables -v -t nat -D POSTROUTING -o ${INTERNET_IF} -j MASQUERADE
iptables -v -D FORWARD -i ${INTERNET_IF} -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -v -D FORWARD -i ${INTERFACE} -o ${INTERNET_IF} -j ACCEPT
echo "Deleting iptables IPs Excluded"
IPS=$(echo $INTRANET_IPS_EXCLUDE | tr "," "\n")
for IP in $IPS
do
    iptables -v -D FORWARD -s ${ADDRESS}/${MASK} -d $(echo ${IP} -j ACCEPT)
done
echo "Deleting IP Range Blocking"
iptables -v -D FORWARD -s ${ADDRESS}/${MASK} -d ${INTRANET_IP_RANGE} -j DROP
echo "**** End deleting iptables ****"

# ===================================================
# Rules without bridge
# ===================

RULE_3="POSTROUTING -o ${INTERNET_IF} -j MASQUERADE"
RULE_4="FORWARD -i ${INTERNET_IF} -o ${INTERFACE} -m state --state RELATED,ESTABLISHED -j ACCEPT"
RULE_5="FORWARD -i ${INTERFACE} -o ${INTERNET_IF} -j ACCEPT"
RULE_6="FORWARD -s ${ADDRESS}/${MASK} -d ${INTRANET_IP_RANGE} -j DROP"

    	# Allow internet / apply rules
	if test ${ALLOW_INTERNET} = true; then
		echo "Configuring iptables for NAT"
		#Rule 3
		iptables -v -t nat -A $(echo ${RULE_3})
		#Rule 4
		iptables -v -A $(echo ${RULE_4})
		#Rule 5
		iptables -v -A $(echo ${RULE_5})
	fi

	# Block intranet / apply rules
	if test ${BLOCK_INTRANET} = true; then
		echo "Starting Blocking intranet"
		echo "Creating IP exceptions if requested..."
		IPS=$(echo $INTRANET_IPS_EXCLUDE | tr "," "\n")
		SEQ=0
		for IP in $IPS
		do
			SEQ=$[$SEQ+1]
			iptables -v -I FORWARD ${SEQ} -s ${ADDRESS}/${MASK} -d $(echo ${IP} -j ACCEPT) 
		done
		SEQ=$[$SEQ+1]
		echo "Blocking Intranet IP Range..." # RULE 6
		iptables -v -I FORWARD ${SEQ} -s ${ADDRESS}/${MASK} -d ${INTRANET_IP_RANGE} -j DROP
	fi

# ===================================================
# Rules with bridge
# ===================

# To be created

# ===================================================
# Setup hostapd.conf
# ===================
HCONFIG="/hostapd.conf"

echo "Setup hostapd ..."
echo "ssid=${SSID}" >> ${HCONFIG}
echo "wpa_passphrase=${WPA_PASSPHRASE}" >> ${HCONFIG}
echo "channel=${CHANNEL}" >> ${HCONFIG}
echo "country_code=${COUNTRY}" >> ${HCONFIG}
echo "ignore_broadcast_ssid=${BROADCASTSSID}" >> ${HCONFIG}
echo "interface=${INTERFACE}" >> ${HCONFIG}
echo "" >> ${HCONFIG}

# ===================================================
# Setup interface
# ===================
IFFILE="/etc/network/interfaces"

echo "Setup interface ..."
echo "" > ${IFFILE}
echo "iface ${INTERFACE} inet static" >> ${IFFILE}
echo "  address ${ADDRESS}" >> ${IFFILE}
echo "  netmask ${NETMASK}" >> ${IFFILE}
echo "  broadcast ${BROADCAST}" >> ${IFFILE}
echo "" >> ${IFFILE}

echo "Resseting interfaces"
reset_interfaces
ifup ${INTERFACE}
sleep 1

# ===================================================
# Setup dhcpd.conf
# ===================
if test ${DHCP_SERVER} = true; then
    UCONFIG="/etc/udhcpd.conf"

    echo "Setup udhcpd ..."
    echo "interface      ${INTERFACE}"     >> ${UCONFIG}
    echo "start          ${DHCP_START}"    >> ${UCONFIG}
    echo "end            ${DHCP_END}"      >> ${UCONFIG}
    echo "opt dns        ${DHCP_DNS}"      >> ${UCONFIG}
    echo "opt subnet     ${DHCP_SUBNET}"   >> ${UCONFIG}
    echo "opt router     ${DHCP_ROUTER}"   >> ${UCONFIG}
    echo "option domain  ${DHCP_DOMAIN}"   >> ${UCONFIG}
    echo "option lease   ${DHCP_LEASE}"    >> ${UCONFIG}
    
    	
    	# Setup static routes
	# ===================
	if test ${DHCP_ROUTES} = true; then
	    echo "option staticroutes ${DHCP_STATICROUTES}" >> ${UCONFIG}
	fi
	
	# Create dhcp_static_leases
	# ===================
	DHCP_COUNT_LEASE=$(jq -r '.dhcp_static_lease | length' $CONFIG_PATH)
	COUNT_LEASE=$[$DHCP_COUNT_LEASE - 1]
	TRK_LEASE=0

	if [ $COUNT_LEASE -ge 0 ]; then
	   while [ $TRK_LEASE -le $COUNT_LEASE ] 
	    do
	      DHCP_LEASE_NAME=$(jq -r '.dhcp_static_lease['$TRK_LEASE'].name?' $CONFIG_PATH)
	      DHCP_LEASE_MAC=$(jq -r '.dhcp_static_lease['$TRK_LEASE'].mac?' $CONFIG_PATH)
	      DHCP_LEASE_IP=$(jq -r '.dhcp_static_lease['$TRK_LEASE'].ip?' $CONFIG_PATH)
	      # write do file
	      echo '#'$DHCP_LEASE_NAME                                >> ${UCONFIG}
	      echo 'static_lease '$DHCP_LEASE_MAC' '$DHCP_LEASE_IP    >> ${UCONFIG}
	      TRK_LEASE=$[$TRK_LEASE+1]
	    done
	else
	    echo "#static_lease non requested."                       >> ${UCONFIG}
	fi
	# ===================
	
    echo ""                                                   >> ${UCONFIG}
    echo $DHCP_STATIC
    echo "Starting DHCP server..."
    udhcpd -f &
fi

# ===================================================

sleep 5

echo "Starting HostAP daemon ..."
hostapd ${HCONFIG} &

while true; do 
    echo "Interface stats:"
    ifconfig | grep ${INTERFACE} -A6
    sleep 3600
done

# ===================================================
# Setup OpenVPN Client
# ===================

echo "Starting OpenVPN Client"

if test ${OPENVPN_ACTIVE} = true; then
    # Setup openvpn
    # Setup tunnel
    function init_tun_interface(){
    # create the tunnel for the openvpn client

    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
    }
    # check file config
    function check_files_available(){
    failed=0

    if [[ ! -f ${OPENVPN_CONFIG} ]]
    then
        echo "File ${OPENVPN_CONFIG} not found"
        failed=1
        break
    fi

    if [[ ${failed} == 0 ]]
    then
        return 0
    else
        return 1
    fi
    }
    
    # wait config
    function wait_configuration(){

    echo "Wait until the user uploads the files."
    # therefore, wait until the user upload the required certification files
    while true; do

        check_files_available

        if [[ $? == 0 ]]
        then
            break
        fi

        sleep 5
    done
    echo "All files available!"
    }
    
    init_tun_interface

    # wait until the user uploaded the configuration files
    wait_configuration

    echo "Setup the VPN connection with the following OpenVPN configuration."

    # try to connect to the server using the used defined configuration
    openvpn --config ${OPENVPN_CONFIG}
    
fi
# ===================================================
echo "All done, enjoy!"
