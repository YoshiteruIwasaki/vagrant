#!/bin/bash

timedatectl set-timezone Asia/Tokyo
localectl set-locale LANG=ja_JP.utf8
yum update -y
yum install -y gcc nmap lsof unzip readline-devel zlib-devel wget
yum install -y postgresql-server
