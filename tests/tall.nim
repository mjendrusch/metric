#
# metric - bringing the SI to Nim.
#
# (c) Copyright 2018 Michael Jendrusch. All rights reserved.
# This library is licensed under the MIT license.
# For more information see LICENSE.

import metric
import unittest, strformat

suite "metric tests":
  test "unit consistency":
    var
      length = 10.0 * meter
      area = length ^ 2
      area2 = 10.0 * meter * meter
      time = second
      otherTime = Unit[Time](val: 10.0)
      mass = kilogram
      combined = length * time ^ 2 / mass
      dimless = length / length
      force {. used .}: Unit[Force] = kilogram * meter / second ^ 2
    check dimless is float
    check compiles(otherTime + time)
    check compiles(area + area2)
    check (not(compiles(area + length)))
    check compiles(area + combined * kilogram / second ^ 2 * meter * 3.14)

  test "unit interconversion":
    const
      milliMeterSquared = (milli meter) ^ 2
      hektar = 10_000.0 * meter ^ 2
    var
      area = meter ^ 2
    check area.hektar == 0.0001
    area.hektar = 10
    check area.milliMeterSquared == 1e11
    check (not(compiles(area.meter)))

  test "unit macro":
    withUnits:
      var
        tenMilliMeters = 10.0 * mm
        oneCentiMeter = 1.0 * cm
      check tenMilliMeters == oneCentiMeter
      check tenMilliMeters.cm == 1.0

  test "pretty printing":
    check $Force == "kg m / s^2"
    check $(meter * meter / second^2 * ampere) == "1.0 [m^2 A / s^2]"
    check toStringWithUnit(10.0 * meter / second,
                           milli(meter) / second,
                           "mm / s") == "10000.0 [mm / s]"
    check fmt"{10.0 * meter as milli meter} [mm]" == "10000.0 [mm]"
