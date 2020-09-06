## Init-Scripts
setting up a cross-compiling environment

### INSTALL
You need a raspberry pi with Raspberry Pi OS on it.\
We use the **Raspberry Pi OS (32-bit) Lite**.

##### [on the pi]
1. Change pw of pi user:
    ```
    passwd 
    ```

2. enable ssh-keys
    ```
    ssh-copy-id pi@<RPI-IP>
    ```

3. run initScript.sh
    ```
    sudo apt install git -y
    git clone https://github.com/JohannesTheiss/pi-scripts.git
    cd pi-scripts
    sudo ./initScript.sh
    ```

4. check country code (should be "DE")
    ```
    sudo cat /etc/wpa_supplicant/wpa_supplicant.conf
    ```

5. Set wifi up:
    1. enable wifi
        ```
        rfkill list 
        ```
        1. if soft blocked then unblock wifi
        ```
        sudo rfkill unblock wifi
        ```

    2. list wifi: 
        ```
        sudo iwlist wlan0 scan 
        ```

    3. encrypt password: 
        ```
        sudo su
        wpa_passphrase "SSID" PASSWORD >> /etc/wpa_supplicant/wpa_supplicant.conf
        ```

    4. delete plain text of password
        ```
        sudo vi /etc/wpa_supplicant/wpa_supplicant.conf
        ```
 
    5. reconfigure the interface: 
        ```
        wpa_cli -i wlan0 reconfigure
        ```

    6. reboot
        ```
        sudo reboot
        ```

    7. check your ip: 
        ```
        ip a 
        ```

6. run deps.sh
    ```
    sudo ./remoteDeps.sh
    ```

7. disable cursor on touch\
    change in /usr/bin/startx the line with\
    `defaultserverargs=""` to `defaultserverargs="-nocursor"`
    ```
    sudo vim /usr/bin/startx
    ```

##### [on the host]
7. run localDeps.sh
    ```
    sudo ./localDeps.sh
    ```

8. go to your build dir.
    ```
    cd /path/to/buildDir
    sudo /path/to/build.sh
    ```

9. make
    ```
    make -j<number of cores>
    make install
    ```

10. deploy Qt-Build
    ```
    cd /path/to/build
    rsync -avze ssh . pi@<RPI-IP>:/usr/local/qt5/
    ```
    or
    ```
    rsync -avz qt5 pi@<RPI-IP>:/usr/local
    ```

11. deploy your project
    ```
    cd /path/to/project
    /path/to/deploy.sh  
    ```

##### [on the pi]
12. run your qt app
    ```
    sudo startx /path/to/exec
    ```

### How to add a submodul:
* download and un-tar the source package:
    ```
    wget -N https://download.qt.io/official_releases/qt/5.13/5.13.1/submodules/<SUBMODUL>
    tar -vxf <SUBMODUL> 
    ```
* build the source package folder (pimake := tools/build-tool/bin/qmake):
    ```
    cd <SOURCEDIR>
    pimake
    make -j<number of cores>
    make install
    ```


### Run your app:
* if you use a desktop environment:
    ```
    export DISPLAY=:0
    sudo startx &
    sudo ./myApp
    ```

* if you want to use SSH:
    ```
    ssh pi@<RPI-IP> -X /path/to/myApp
    ```
    or
    ```
    ssh pi@<RPI-IP> -X
    ./myApp
    ```

* if you DON'T use a desktop environment:
    ```
    sudo startx ./myApp
    ```
    or
    ```
    sudo startx ~/.xinitrc
    (in .xinitrc: exec /path/to/myApp)
    ```

