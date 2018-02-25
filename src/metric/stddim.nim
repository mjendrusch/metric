import dimension

type
  Length* = object of BaseDimension
  Time* = object of BaseDimension
  Mass* = object of BaseDimension
  Amount* = object of BaseDimension
  Temperature* = object of BaseDimension
  Current* = object of BaseDimension
  Intensity* = object of BaseDimension
  Area* = Length ^ 2
  Volume* = Length ^ 3
  Velocity* = Length / Time
  Acceleration* = Velocity / Time
  Momentum* = Mass * Velocity
  Force* = Mass * Acceleration
  Energy* = Force * Length
  Action* = Energy * Time
  Frequency* = Dimensionless / Time
  Pressure* = Force / Area
  Power* = Energy / Time
  Charge* = Current * Time
  Voltage* = Energy / Current
  Capacitance* = Charge / Voltage
  Resistance* = Voltage / Current
  Conductance* = Dimensionless / Voltage
  MagneticFlux* = Voltage * Time
  MagneticFluxDensity* = MagneticFlux / Area
  Inductance* = MagneticFlux / Current
  Illuminance* = Intensity / Area
  Radioactivity* = Dimensionless / Time ^ 2
  RadiationDose* = Energy / Mass
  RadiationEffectiveDose* = Energy / Mass
  CatalyticActivity* = Amount / Time

template `$`*(x: typedesc[Length]): string = "m"
template `$`*(x: typedesc[Time]): string = "s"
template `$`*(x: typedesc[Mass]): string = "kg"
template `$`*(x: typedesc[Amount]): string = "mol"
template `$`*(x: typedesc[Temperature]): string = "K"
template `$`*(x: typedesc[Current]): string = "A"
template `$`*(x: typedesc[Intensity]): string = "cd"
template `$`*(x: typedesc[Dimensionless]): string = "1"
