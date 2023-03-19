import Alloy.C
open scoped Alloy.C

alloy c include <lean/lean.h>

alloy c extern def myAdd (x y : UInt32) : UInt32 := {
  return x + y;
}


def hello := s!"world {myAdd 0 0}"
