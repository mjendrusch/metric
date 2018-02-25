# metric - bringing SI to Nim

[![nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble_js.png)](https://github.com/yglukhov/nimble-tag)

`metric` is a small library providing type-level dimensional analysis.
It allows you to keep track of the physical units of your programs, and can
be useful for writing scientific software.

## Installation

`metric` has no non-standard dependencies. Just type `nimble install metric`
and you're good to go.

## A small usage example

```nim
import metric, strformat

## Let's open a block with a lot of miscellaneous units predefinded:
withUnits:
  var
    v0 = 40.0 * mile / hour # Some non-SI units of velocity.
  echo "v0 in miles per hour: ", fmt"{v0 as mile / hour} [mph]"
  echo "v0 in decimeters per fortnight: ",
    fmt"{v0 as dm / (2.0 * week)} [dm / fortnight]"
  echo "v0 in SI units: ", v0
```

As you can see, `metric` makes it easy to handle units, and never have to
worry about keeping track of strange conversions.

## Custom dimensions

`metric` provides the means to handle all dimensionful quantities under the
SI system. Dimensions taken into consideration are:

* `Length`
* `Time`
* `Mass`
* `Amount`
* `Temperature`
* `Current`
* `Intensity`

Should you need different units, you can do that, by just defining them as
`object of BaseDimension`, with the following procs and constants:

```nim
type
  MyDimension = object of BaseDimension

proc `$`(x: typedesc[MyDimension]): string = "mydim" ## \
  ## Define how you want your dimension's base unit to be pretty-printed.

const
  myUnitValue = Unit[MyDimension](val: 1.0) ## The name does not matter here.
```

With those things defined, you are good to use your units in the same way, as
the built-ins.
