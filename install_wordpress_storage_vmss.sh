#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2015 Microsoft Azure
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# INSTALAMOS NGINX
apt-get update -y && apt-get upgrade -y
apt-get install -y nginx


# MONTAMOS AZURE FILES STORAGE CON ARCHIVOS WORDPRESS
# 4 parametros: storageaname, user, password, permiso
# 2 opciones para permiso: full (0777), read (0775)

username=$1
password=$2
storagename=$3
permission=$4


if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/danielwordpressst.cred" ]; then
    sudo bash -c 'echo "username=$username" >> /etc/smbcredentials/$storagename.cred'
    sudo bash -c 'echo "password=$password" >> /etc/smbcredentials/$storagename.cred'
fi
sudo chmod 600 /etc/smbcredentials/$storagename.cred

if [ $permission -eq 'full' ]; then
sudo bash -c 'echo "//$storagename.file.core.windows.net/wp-content /var/www/html/ cifs nofail,vers=3.0,credentials=/etc/smbcredentials/$storagename.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //$storagename.file.core.windows.net/wp-content /var/www/html/ -o vers=3.0,credentials=/etc/smbcredentials/$storagename.cred,dir_mode=0777,file_mode=0777,serverino
fi

if [ $permission -eq 'read' ]; then
sudo bash -c 'echo "//$storagename.file.core.windows.net/wp-content /var/www/html/ cifs nofail,vers=3.0,credentials=/etc/smbcredentials/$storagename.cred,dir_mode=0775,file_mode=0775,serverino" >> /etc/fstab'
sudo mount -t cifs //$storagename.file.core.windows.net/wp-content /var/www/html/ -o vers=3.0,credentials=/etc/smbcredentials/$storagename.cred,dir_mode=0775,file_mode=0775,serverino
fi
