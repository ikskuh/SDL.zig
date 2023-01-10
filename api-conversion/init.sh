#!/bin/bash

root="$(dirname "$(realpath "$0")")"

set -e

git clone --depth 1 https://github.com/libsdl-org/SDL $root/sdl-source 

cd $root/sdl-source 

./src/dynapi/gendynapi.py --dump

cd $root/

cp $root/sdl-source/sdl.json $root/sdl.json

rm -rf $root/sdl-source
