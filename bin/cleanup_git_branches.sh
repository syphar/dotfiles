#!/usr/bin/env bash

git branch -v | \
    grep "\[gone\]" | \
    awk '{print $1}' | \
    xargs git branch -D

