# Package

version       = "0.1.0"
author        = "Michael Jendrusch"
description   = "Unit types for Nim."
license       = "MIT"
srcDir        = "src"

# Dependencies

requires "nim >= 0.17.3"

proc testConfig() =
  --path: "../src"
  --run

task test, "run metric tests":
  testConfig()
  setCommand "c", "tests/tall.nim"
