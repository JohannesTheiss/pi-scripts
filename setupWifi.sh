#!/bin/bash

ip link set wlan0 up
iwlist wlan0 scan 
wpa_cli -i wlan0 reconfigure
reboot
