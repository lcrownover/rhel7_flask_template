#!/bin/bash

CWD=$(pwd)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

# Simple script to install
# Good reference: https://www.digitalocean.com/community/tutorials/how-to-serve-flask-applications-with-gunicorn-and-nginx-on-ubuntu-16-04

# Set up virtual environment
virtualenv venv
. ./venv/bin/activate
pip install -r requirements.txt
deactivate

# Edit and link the nginx conf files
sed -i "s/server_name .*/server_name $(hostname)/" nginx/myapp.conf
ln -s $DIR/nginx/myapp.conf /etc/nginx/conf.d/myapp.conf

# Edit and copy the service file to systemd location
sed -i "s/WorkingDirectory=.*/WorkingDirectory=$DIR/" service/myapp.service
sed -i "s/Environment=\"PATH=.*\"/Environment=\"PATH=$DIR/venv/bin\"/" service/myapp.service
sed -i "s/ExecStart=.*? /Execstart=$DIR/venv/bin/gunicorn /" service/myapp.service
cp service/myapp.server /etc/systemd/system/


cd $CWD

