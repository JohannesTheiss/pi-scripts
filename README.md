## Init-Scripts
setting up a cross-compiling env.

### Usage
you need a raspberry pi with raspberry pi os on it

#### [on the pi]
1. Change pw of pi user:
    ```
    $ passwd 
    ```

2. enable ssh-keys
    ```
    $ ssh-copy-id pi@<RPI-IP>
    ```

3. run initScript.sh
    ```
    $ sudo ./initScript.sh
    ```

4. check country code
    ```
    $ sudo cat /etc/wpa_supplicant/wpa_supplicant.conf
    ```
    1. country should be "DE"

5. Set wifi up:
    1. enable wifi
        ```
        $ rfkill list 
        ```
        1. if soft blocked then unblock wifi
        ```
        $ sudo rfkill unblock wifi
        ```

    2. list wifi: 
        ```
        $ sudo iwlist wlan0 scan 
        ```

    3. encrypt password: 
        ```
        $ sudo su
        $ wpa_passphrase "SSID" PASSWORD >> /etc/wpa_supplicant/wpa_supplicant.conf
        ```

    4. delete plain text of password
        ```
        $ sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
        ```
 
    5. reconfigure the interface: 
        ```
        $ wpa_cli -i wlan0 reconfigure
        ```

    6. reboot
        ```
        $ sudo reboot
        ```

    7. check your ip: 
        ```
        $ ip a 
        ```

6. run deps.sh
    ```
    $ sudo ./deps.sh
    ```

#### [on the host]
7. run localDeps.sh
    ```
    $ sudo ./localDeps.sh
    ```

8. go to your build dir.
    ```
    $ cd /path/to/buildDir
    $ sudo /path/to/build.sh
    ```

9. make
    ```
    $ make -j<number of cores>
    $ make install
    ```

10. deploy Qt-Build
    ```
    $ rsync -avze ssh /path/to/build pi@<RPI-IP>:/usr/local/qt5/
    ```

11. deploy your project
    ```
    $ cd /path/to/project
    $ /path/to/deploy.sh  
    ```

#### [on the pi]
12. run your qt app
    ```
    $ sudo startx /path/to/exec
    ```



