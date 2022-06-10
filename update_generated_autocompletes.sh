#!/bin/bash
set -exuo pipefail

poetry completions fish > ~/.config/fish/completions/poetry.fish
poe _fish_completion > ~/.config/fish/completions/poe.fish
