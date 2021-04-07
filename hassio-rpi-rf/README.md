# RPI RF Receiver

This addon is made to make the rpi-rf receiver script run in background of you hassio

1. Install the addon (it should take 5 or 10 minutes to complete).

    1.1 If for some reason terminates saying "Unknown error, see supervisor logs", please wait 10 more minutes and it should be available or restart hass server and it should be working.

2. Copy "rpi-rf_receive.py" in the "share" share of your hass.io and if need ajust the script.

3. Start the addon 

This add-on has no integration with mosquitto, in the log you will see the RF codes, to get the codes for your devices, you shoud test very close to your RF Board to get a good data.
