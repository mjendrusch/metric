#
# metric - bringing the SI to Nim.
#
# (c) Copyright 2018 Michael Jendrusch. All rights reserved.
# This library is licensed under the MIT license.
# For more information see LICENSE.

import dimension, unit, stddim

const
  meter* = Metric[Length, float](val: 1.0)
  second* = Metric[Time, float](val: 1.0)
  kilogram* = Metric[Mass, float](val: 1.0)
  mole* = Metric[Amount, float](val: 1.0)
  kelvin* = Metric[Temperature, float](val: 1.0)
  ampere* = Metric[Current, float](val: 1.0)
  candela* = Metric[Intensity, float](val: 1.0)
  one* = Metric[Dimensionless, float](val: 1.0)

  # derived units:
  hertz* = one / second ## \
    ## An SI-compatible unit of frequency.
  newton* = kilogram * meter / second ^ 2 ## \
    ## An SI-compatible unit of force.
  pascal* = newton / meter ^ 2 ## \
    ## An SI-compatible unit of pressure.
  joule* = newton * meter ## \
    ## An SI-compatible unit of energy.
  watt* = joule / second ## \
    ## An SI-compatible unit of power.
  coulomb* = ampere * second ## \
    ## An SI-compatible unit of charge.
  volt* = watt / ampere ## \
    ## An SI-compatible unit of electric potential difference.
  farad* = coulomb / volt ## \
    ## An SI-compatible unit of capacitance.
  ohm* = volt / ampere ## \
    ## An SI-compatible unit of resistance.
  siemens* = one / ohm ## \
    ## An SI-compatible unit of conductance.
  weber* = volt * second ## \
    ## An SI-compatible unit of magnetic flux.
  tesla* = weber / meter ^ 2 ## \
    ## An SI-compatible unit of magnetic flux density.
  henry* = weber / ampere ## \
    ## An SI-compatible unit of inductance.
  lux* = candela / meter ^ 2 ## \
    ## An SI-compatible unit of illuminance.
  becquerel* = one / second ^ 2 ## \
    ## An SI-compatible unit of radioactivity.
  gray* = meter ^ 2 / second ^ 2 ## \
    ## An SI-compatible unit of absorbed radiation dose.
  sievert* = meter ^ 2 / second ^ 2 ## \
    ## An SI-compatible unit of equivalent radiation dose.
  katal* = mole / second ## \
    ## An SI-compatible unit of enzyme activity.

template deci*(x: auto): auto = 1e-1 * x
template centi*(x: auto): auto = 1e-2 * x
template milli*(x: auto): auto = 1e-3 * x
template micro*(x: auto): auto = 1e-6 * x
template nano*(x: auto): auto = 1e-9 * x
template pico*(x: auto): auto = 1e-12 * x
template femto*(x: auto): auto = 1e-15 * x
template atto*(x: auto): auto = 1e-18 * x
template zepto*(x: auto): auto = 1e-21 * x
template yocto*(x: auto): auto = 1e-24 * x
template deca*(x: auto): auto = 1e1 * x
template hecto*(x: auto): auto = 1e2 * x
template kilo*(x: auto): auto = 1e3 * x
template mega*(x: auto): auto = 1e6 * x
template giga*(x: auto): auto = 1e9 * x
template tera*(x: auto): auto = 1e12 * x
template peta*(x: auto): auto = 1e15 * x
template exa*(x: auto): auto = 1e18 * x
template zeta*(x: auto): auto = 1e21 * x
template yotta*(x: auto): auto = 1e24 * x

template withUnits*(body: untyped): untyped {. dirty .} =
  ## Allows to use unit constants in a scoped manner.
  block:
    const
      # common shorthands:
      # length:
      m {. used .} = meter
      mm {. used .} = milli m
      cm {. used .} = centi m
      dm {. used .} = deci m
      km {. used .} = kilo m

      inch {. used .} = 2.54 * cm
      foot {. used .} = 12.0 * inch
      yard {. used .} = 3.0 * foot
      mile {. used .} = 1760.0 * yard

      # area
      a {. used .} = 100.0 * m ^ 2
      ha {. used .} = hecto a

      # volume
      L {. used .} = dm ^ 3
      mL {. used .} = milli L
      µL {. used .} = micro L
      nL {. used .} = nano L
      pL {. used .} = pico L
      fL {. used .} = femto L

      # time:
      s {. used .} = second
      min {. used .} = 60.0 * second
      hour {. used .} = 60.0 * min
      day {. used .} = 24.0 * hour
      week {. used .} = 7.0 * day

      # mass:
      g {. used .} = 1e-3 * kilogram
      kg {. used .} = kilo g
      t {. used .} = mega g
      mg {. used .} = milli g
      µg {. used .} = micro g
      ng {. used .} = nano g
      pg {. used .} = pico g
      fg {. used .} = femto g

      # amount:
      mol {. used .} = mole
      mmol {. used .} = milli mol
      µmol {. used .} = micro mol
      nmol {. used .} = nano mol
      pmol {. used .} = pico mol
      fmol {. used .} = femto mol

      # concentration:
      M {. used .} = mol / L
      mMolar {. used .} = milli M
      µMolar {. used .} = micro M
      nMolar {. used .} = nano M
      pMolar {. used .} = pico M
      fMolar {. used .} = femto M

      # temperature:
      K {. used .} = kelvin

      # current:
      A {. used .} = ampere
      kA {. used .} = kilo A
      mA {. used .} = milli A

      # intensity:
      cd {. used .} = candela

      # derived shorthands:
      Pa {. used .} = pascal
      J {. used .} = joule
      W {. used .} = watt
      C {. used .} = coulomb
      V {. used .} = volt
      F {. used .} = farad
      S {. used .} = siemens
      Wb {. used .} = weber
      T {. used .} = tesla
      H {. used .} = henry
      lx {. used .} = lux
      Bq {. used .} = becquerel
      Gy {. used .} = gray
      Sv {. used .} = sievert
      kat {. used .} = katal
      N {. used .} = newton
    body
