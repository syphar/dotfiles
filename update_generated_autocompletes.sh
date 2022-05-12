#!/bin/bash
set -exuo pipefail

poetry completions fish > ~/.config/fish/completions/poetry.fish
