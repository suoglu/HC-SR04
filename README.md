# HC-SR04

## Contents of Readme

1. About
2. Modules
3. IOs of Modules
4. Calculation of Distance
5. Test
6. Status Information
7. Issues
8. Licence

[![Repo on GitLab](https://img.shields.io/badge/repo-GitLab-6C488A.svg)](https://gitlab.com/suoglu/hc-sr04)
[![Repo on GitHub](https://img.shields.io/badge/repo-GitHub-3D76C2.svg)](https://github.com/suoglu/HC-SR04)

---

## About

[HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf) is an ultrasonic distance sensor. It provides 2cm to 400cm of non-contact measurement functionality with a ranging accuracy that can reach up to 3mm. 

**[HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf) uses 5V logic!**

## Modules

Module `hc_sr04` provides an interface for [HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf). It generates 10µs trigger signal, `Trig`, and counts the length of the echo signal, `Echo`. Length of the echo signal counted in number of cycles, multiples of 10ns.

Module `refresher250ms` generates a measure signal every 250ms when enabled.

## IOs of Modules

|   Port   | Type | Width |  Description |
| :------: | :----: | :----: |  ------  |
| `clk` | I | 1 | System Clock (100 MHz) |
| `rst` | I | 1 | System Reset |
| `measure` | I | 1 | Initiate a new measurement |
| `state` | O | 2 | State of the module, for debug etc |
| `ready` | O | 1 | Module is not busy  |
| `echo` | I | 1 | Echo pin of [HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf) |
| `trig` | O | 1 | Trigger pin of [HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf) |
| `distanceRAW` | O | 22 | Length of the echo signal, multiples of 10ns |

I: Input  O: Output

## Calculation of Distance

`distanceRAW` should be divided with 100 to calculate time in µs.

* *`distanceRAW` / 100 = Time (µs)*

Distance can be calculated using following formula:

* *Distance (cm) = Speed of sound (cm/µs) × Time (µs) / 2*

Where *Speed of sound (cm/µs) = 0.0346* at 25°C

Temperature of the environment can change the speed of sound. It can be calculated via:

* *Speed of sound (cm/µs) = (331.3 + 0.606 \* Temp) / 1000*

Where *Temp* is the environment temperature in °C.

Formula above assumes 0% humidity.

Source: [Wikipedia](https://en.wikipedia.org/wiki/Speed_of_sound)

## Test

[HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf) uses 5V logic!

[HC-SR04](https://cdn.sparkfun.com/datasheets/Sensors/Proximity/HCSR04.pdf) require an external 5V supply. [TXS0104E](https://www.ti.com/lit/ds/symlink/txs0104e.pdf) voltage level shifter is used to convert `echo` and `trig` signals between 3.3V and 5V.

[testboard.v](Test/testboard.v) is used to test interface. `echo` and `trig` are connected to JA header. Sixteen least significant bits of `distanceRAW` is connected to seven segment display, remaining bits are connected to least significant bits of leds. Most significant bit of the leds connected to `ready`. Down button can be used to get a single measurement. SW15 can be used to enable `refresher250ms` module.

## Status Information

**Last Test:** 16 January 2021, on [Digilent Basys 3](https://reference.digilentinc.com/reference/programmable-logic/basys-3/reference-manual).

## Issues

* Keeping `measure` high breaks the module.

## Licence

CERN Open Hardware Licence Version 2 - Weakly Reciprocal
