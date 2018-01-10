#!/bin/bash
APPNAME=`ls /var/www/apptest/ | head -n 1`
cp /var/www/apptest/* /var/www/applications/
rm -rf /var/www/apptest/*
if [ -L /var/www/restApp/demoapp.jar ]
then
	rm -f /var/www/restApp/demoapp.jar
fi
cd /var/www/restApp
ln -s /var/www/applications/${APPNAME} demoapp.jar
