#
# metric - bringing the SI to Nim.
#
# (c) Copyright 2018 Michael Jendrusch. All rights reserved.
# This library is licensed under the MIT license.
# For more information see LICENSE.

import math, strformat
import dimension

type
  Metric*[D, T] = object
    ## A value endowed with dimension.
    val*: T
  Unit*[D] = Metric[D, float]

proc `+`*[U, X](x, y: Metric[U, X]): auto =
  ## Sum of two dimensionful quantities.
  let
    res = x.val + y.val
  Metric[U, X](val: res)

proc `-`*[U, X](x, y: Metric[U, X]): auto =
  ## Difference of two dimensionful quantities.
  let
    res = x.val - y.val
  Metric[U, X](val: res)

proc `*`*[U, X](x: Metric[U, X]; y: X): auto =
  ## Product of a number and a dimensionful quantity.
  let
    res = x.val * y
  Metric[U, type res](val: res)

proc `*`*[U, X](x: X; y: Metric[U, X]): auto =
  ## Product of a number and a dimensionful quantity.
  let
    res = x * y.val
  Metric[U, type res](val: res)

proc `*`*[U, V, X, Y](x: Metric[U, X]; y: Metric[V, Y]): auto =
  ## Product of two dimensionful quantities.
  let
    res = x.val * y.val
  when U * V is Dimensionless:
    result = res
  else:
    Metric[U * V, type res](val: res)

proc `/`*[U, X](x: Metric[U, X]; y: X): auto =
  ## Quotient of a number and a dimensionful quantity.
  let
    res = x.val / y
  Metric[U, type res](val: res)

proc `/`*[U, X](x: X; y: Metric[U, X]): auto =
  ## Quotient of a number and a dimensionful quantity.
  let
    res = x / y.val
  Metric[U, type res](val: res)

proc `/`*[U, V, X, Y](x: Metric[U, X]; y: Metric[V, Y]): auto =
  ## Quotient of two dimensionful quantities.
  let
    res = x.val / y.val
  when U / V is Dimensionless:
    result = res
  else:
    Metric[U / V, type res](val: res)

proc `^`*[U, X](x: Metric[U, X]; y: static[Natural]): auto =
  ## Natural power of a dimensionful quantity.
  let
    res = pow(x.val, y)
  Metric[U ^ y, type res](val: res)

{. experimental .}

template setAs*[U, X](x: var Metric[U, X]; units: Metric[U, X]; y: X) =
  ## Sets ``x`` to ``y`` in units of ``units``.
  x.val = units.val * y

template `.=`*[U, X](x: var Metric[U, X]; units: Metric[U, X]; y: X) =
  ## Sets ``x`` to ``y`` in units of ``units``.
  x.val = units.val * y

template `as`*[U, X](x: Metric[U, X]; units: Metric[U, X]): X =
  ## Retrieves the value of ``x`` in units of ``units``
  x.val / units.val

template `.`*[U, X](x: Metric[U, X]; units: Metric[U, X]): X =
  ## Retrieves the value of ``x`` in units of ``units``
  x.val / units.val

proc `$`*[U, X](x: Metric[U, X]): string = fmt"{x.val} [{U}]"
proc toStringWithUnit*[U, X](x: Metric[U, X]; unit: Metric[U, X];
                             expression: string): string =
  ## Stringifies a dimensionful value, with a given unit and unit-expression.
  let
    unitVal = x.unit
  fmt"{unitVal} [{expression}]"
