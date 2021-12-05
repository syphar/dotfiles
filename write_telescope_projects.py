#! /usr/bin/env python3
from pathlib import Path

format = "{name}={path}=w0=1"
src_dir = "/Users/syphar/src/"


try:
    while line := input():
        if line.startswith(src_dir):
            print(format.format(name=line.removeprefix(src_dir), path=line))
        else:
            print(format.format(name=Path(line).parts[-1], path=line))
except EOFError:
    pass
