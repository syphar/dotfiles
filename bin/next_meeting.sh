#!/bin/sh
gcalcli agenda --tsv --nostarted --nodeclined | \
    grep -v "00:00" | \
    awk '{print $2"-"$4" "$5" "$6" "$7" "$8" "$9}' | \
    head -n1 | \
    cut -c -30
