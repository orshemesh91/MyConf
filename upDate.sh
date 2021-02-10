#!/bin/bash
timedatectl set-timezone Asia/Jerusalem
timedatectl set-ntp yes
systemctl restart chronyd
chronyc -a makestep
