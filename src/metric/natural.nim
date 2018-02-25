#
# metric - bringing the SI to Nim.
#
# (c) Copyright 2018 Michael Jendrusch. All rights reserved.
# This library is licensed under the MIT license.
# For more information see LICENSE.

## This module provides Planck units, i.e. ``h = c = G = kB = ke = 1``.

import dimension, unit, stddim, siunits
import constants

const
  planckLength* = 1.616e-35 * meter
  planckArea* = planckLength ^ 2
  planckVolume* = planckLength ^ 3
  planckMass* = 2.176e-8 * kilogram
  planckTime* = 5.3912e-44 * second
  planckTemperature* = 1.417e32 * kelvin
  planckCharge* = 1.876e-18 * coulomb
  planckCurrent* = planckCharge / planckTime
