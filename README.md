# Interfaces

Collection of Processing-based data interfaces for our team. They are used primaily to simplify interacting with our systems with a computer, generally to display data from a system.

They were all written in the Processing language and should be able to run on any system that is supported by it. They all operate by communicating with a microcontroller over a serial interface.

## Telemetry UI

Used to show the data stream broadcast by a vehicle such as speed. Originally written for the Blueshift project, but can be adapted and used for other projects.

Requires a microcontroller reciever setup.

## Rolling Resistance

Meant to be used with our rolling resistance aparatus. Shows the current wheel speeds as well as records a log of the data to a file on the computer.

Connects directly to the Arduino used for the rolling resistance rig.

## Bike Simulation

Used to feed a microcontroller data as though it were actually connected to the sensor on a bike. Allows us to set the percieved sensor streams as we please like speed or cadence to see that data is flowing correctly through the system.

Designed originally to aid in the development of Blueshift but can be used on other projects.
