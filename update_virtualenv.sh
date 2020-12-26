#!/bin/bash
set -euo pipefail

venvpip=$1/bin/pip
package=${2:-}

if [ -z "$package" ];
then
    $venvpip freeze | grep = | cut -d = -f 1 | xargs $venvpip install -U
else
    $venvpip install -U "$package"
fi
