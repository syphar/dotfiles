#!/bin/sh

# https://github.com/tmate-io/tmate/issues/86
tmate -S $1 display -p '#{tmate_ssh}'    # Prints the SSH connection string
tmate -S $1 display -p '#{tmate_ssh_ro}' # Prints the read-only SSH connection string
tmate -S $1 display -p '#{tmate_web}'    # Prints the web connection string
tmate -S $1 display -p '#{tmate_web_ro}' # Prints the read-only web connection string
