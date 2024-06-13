#ifndef LIB_TRANSFORM_ARITH_PASSES_TD_
#define LIB_TRANSFORM_ARITH_PASSES_TD_

include "mlir/Pass/PassBase.td"

def MulToAdd : Pass<"mul-to-add"> {
  let summary = "Convert multiplications to repeated additions";
  let description = [{
    Convert multiplications to repeated additions.
  }];
}

def MulToShiftAndAdd : Pass<"mul-to-shift-and-add"> {
  let summary = "Convert multiplications to a left shift and repeated additions";
  let description = [{
    Convert multiplications to a left shift and repeated additions.
  }];
}

#endif  // LIB_TRANSFORM_ARITH_PASSES_TD_