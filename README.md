# roboloid

To run the code to control Dynamix through matlab

## Preparations Linux
Compile C SDK

`cd ./lib/DynamixelSDK/c/build/linuxXX` replace xx with 64 or 32.

`sudo make clean && sudo make`

`sudo make reinstall` or `sudo make install`

prepare usb (no driver needed for kernel 2.6+)

`../tools/usb_prep_linux`

## Run example in linux

start matlab in project root directory

`matlab -nosplash -nodisplay -nodesktop`

Add src directory (in matlab)

`addpath src`

Initiated an instance of Robot class

`r = Robot`

Make robot walk two steps to the left and then throw to left

`r.strafeLeft(2);r.throwLeft();`

## To record a sequence

Initiate a robot instance and start recording and follow instructions

`r = Robot; r.recordSequence;

The recordered sequence can be played back with

`r.playSequence(filename,speed,steps)`

## Windows

-Nothing yet




