#!/bin/bash
cd /home/isudijov/rest
mvn clean install >> ../output.mvn
SUCCESS=`cat ../output.mvn | tail -n 10 | grep 'BUILD SUCCESS' | wc -l`
if [ $SUCCESS -gt 0 ]
then
cd target
sshpass -p "2Cool4us!*" scp -r demoapp*.jar root@team.center:/var/www/apptest/
fi