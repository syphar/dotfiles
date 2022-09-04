#!/bin/bash
set -exuo pipefail

poetry completions fish > ~/.config/fish/completions/poetry.fish
poe _fish_completion > ~/.config/fish/completions/poe.fish
_DSLR_COMPLETE=fish_source dslr > ~/.config/fish/completions/dslr.fish
