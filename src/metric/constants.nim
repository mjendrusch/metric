#
# metric - bringing the SI to Nim.
#
# (c) Copyright 2018 Michael Jendrusch. All rights reserved.
# This library is licensed under the MIT license.
# For more information see LICENSE.

## This module provides common physical constants with units.

import math
import dimension, unit, stddim, siunits

const
  speedOfLight* = 299_792_458.0 * meter / second
  constantOfGravitation* = 6.674_08e-11 * meter ^ 3 / (kilogram * second ^ 2)
  reducedPlanckConstant* = 1.054_571_800e-34 * joule * second

  vacuumPermeability* = (4 * Pi) * 1.0e-7 * newton / ampere ^ 2
  vacuumPermittivity* = 8.854_187_817e-12 * farad / meter
  vacuumImpedance* = vacuumPermeability * speedOfLight
  elementaryCharge* = 1.602_176_621e-19 * coulomb
  electronMass* = 9.109_383_56e-31 * kilogram
  protonMass* = 1.672_621_898e-27 * kilogram
  fineStructureConstant* = elementaryCharge ^ 2 /
                           (4.0 * Pi * vacuumPermittivity *
                            reducedPlanckConstant)
  rydbergConstant* = fineStructureConstant ^ 2 * electronMass * speedOfLight /
                     (4.0 * Pi * reducedPlanckConstant)

  coulombsConstant* = 1.0 / (4.0 * Pi * vacuumPermittivity)
  bohrMagneton* = elementaryCharge * reducedPlanckConstant / (2.0 * electronMass)
  conductanceQuantum* = elementaryCharge ^ 2 * 4.0 * Pi /
                        reducedPlanckConstant
  josephsonConstant* = 4.0 * Pi * elementaryCharge / reducedPlanckConstant
  magneticFluxQuantum* = reducedPlanckConstant / (4.0 * Pi * elementaryCharge)

  atomicMass* = 1.660_539_040e-27 * kilogram
  avogadroConstant* = 6.022_140_857e23 * one / mole
  boltzmannConstant* = 1.380_648_52e-23 * joule / kelvin
  gasConstant* = 8.314_459_8 * joule / (mole * kelvin)

template withPhysicalConstants*(body: untyped): untyped {. dirty .} =
  ## Creates a scoped environment in which shorthands for physical constants
  ## may be used.
  block:
    const
      c0 = speedOfLight
      G = constantOfGravitation
      hbar = reducedPlanckConstant
      mu0 = vacuumPermeability
      epsilon0 = vacuumPermittivity
      Z0 = vacuumImpedance
      e = elementaryCharge
      me = electronMass
      mp = protonMass
      alpha = fineStructureConstant
      RInfty = rydbergConstant
      ke = coulombsConstant
      muB = bohrMagneton
      G0 = conductanceQuantum
      KJ = josephsonConstant
      phi0 = magneticFluxQuantum
      unit = atomicMass
      u = atomicMass
      Da = atomicMass
      NA = avogardoConstant
      kB = boltzmannConstant
      R = gasConstant
    body
