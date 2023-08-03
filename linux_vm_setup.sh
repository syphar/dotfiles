#!/bin/bash
# This script is used to install and configure a Linux VM for use for 
# compiling & testing rust apps in linux, specifically docs.rs builds


curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt-get install build-essential libssl-dev pkg-config sqlite3
