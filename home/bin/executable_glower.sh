#!/bin/bash 
set -eo 

while true; do
    clear;
    glow --pager --style dark "${1}" 
    sleep 2;
done
