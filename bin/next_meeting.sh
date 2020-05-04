#!/bin/sh
gcalcli agenda --tsv --nostarted --nodeclined | awk '{print $2"-"$4" "$5" "$6" "$7" "$8" "$9}' | head -n1
