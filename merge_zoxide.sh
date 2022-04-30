#!/bin/bash 

set -euo pipefail

dest=~/Library/Application\ Support/zoxide/db.zo

for f in ~/Library/Application\ Support/zoxide/*.zo
do
    if [ "$f" != "$dest" ]; then 
        ~/.cargo/cache/release/zoxide \
            import --merge \
            --from zoxide \
            "$f"
        rm -f "$f"
    fi
done
