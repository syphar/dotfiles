#!/bin/bash

mkdir -p ~/.pip/
ln -s ./.pip/pip.conf ~/.pip/pip.conf

ln -s ./.pydistutils.cfg ~/.pydistutils.cfg
ln -s ./buildout.cfg ~/buildout.cfg
