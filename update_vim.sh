#!/bin/bash
set -euxo pipefail

nvim "+call dein#update()" +qa
