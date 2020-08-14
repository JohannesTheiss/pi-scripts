#!/bin/bash

iwlist wlan0 scan 
wpa_cli -i wlan0 reconfigure
reboot
