# Setup raspberry

1. Install a Raspberry Pi following the instructions on raspberrypi.org
3. Get root access
```
sudo su -
```
2. Download the setup script:
```
wget https://raw.githubusercontent.com/joek/presenter-pi/master/setup.sh
```
3. Run setup script
```
chmod a+x setup.sh
./setup.sh
```


# Setup USB-Stick for media Data
1. Plugin USB Stick
2. Umount USB Stick (Mountpath should be something with /media/...)
```
umount <Mount path>
```
3. Create new Filesystem (will remove all data on the stick)
```
mkfs.vfat -n VCP /dev/sda
```
4. Copy media to raspberry
5. Create Config for raspberry
