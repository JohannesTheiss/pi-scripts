## Init-Scripts
setting up a cross-compiling env.

### Usage
you need a raspberry pi with raspberry pi os on it

#### on the pi
1. Change pw of pi user:
```
$ passwd 
```

1. enable ssh-keys
```
$ ssh-copy-id pi@<RPI-IP>
```

1. run initScript.sh
```
$ sudo ./initScript.sh
```

1. check country code
```
$ sudo cat /etc/wpa_supplicant/wpa_supplicant.conf
```
    1. country should be "DE"

1. Set wifi up:
    1. enable wifi
        ```
        $ rfkill list 
        ```
        1. if soft blocked then unblock wifi
        ```
        $ sudo rfkill unblock wifi
        ```

    1. list wifi: 
        ```
        $ sudo iwlist wlan0 scan 
        ```

    1. encrypt password: 
        ```
        $ sudo su
        $ wpa_passphrase "SSID" PASSWORD >> /etc/wpa_supplicant/wpa_supplicant.conf
        ```

    1. delete plain text of password
        ```
        $ sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
        ```
 
    1. reconfigure the interface: 
        ```
        $ wpa_cli -i wlan0 reconfigure
        ```

    1. reboot
        ```
        $ sudo reboot
        ```

    1. check your ip: 
        ```
        $ ip a 

        ```

1. run deps.sh
```
$ sudo ./deps.sh

```

#### on the host 
1. run localDeps.sh
```
$ sudo ./localDeps.sh
```

1. go to your build dir.
```
$ cd /path/to/buildDir
$ sudo /path/to/build.sh
```

1. make
```
$ make -j<number of cores>
$ make install
```







