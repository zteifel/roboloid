# roboloid

To run the code to control Dynamix through matlab

## Linux
Compile C SDK

`cd ./lib/DynamixelSDK/c/build/linuxXX` replace xx with 64 or 32.

`sudo make clean && sudo make`

`sudo make reinstall` or `sudo make install`

prepare usb (no driver needed for kernel 2.6+)

../tools/usb_prep_linux

run include_sdk.m in ./tools.

## Windows

-Nothing yet



