#!/bin/bash
echo "hi"
if [ -n "$1" ] 
then 
    echo "Testing '$1'"
else
    echo "Usage ./round_trip_test.sh {test file}" 
fi 


bazel run tools:qe-opt -- --help >/dev/null
if [ $? -ne 0 ]; then
    echo "Error: building qe-opt and library failed"
    exit 1
fi

# ./bazel-bin/tools/qe-opt --verify-roundtrip $1
# ./bazel-bin/tools/qe-opt --print-each-operation $1
# First mark the function for forced inlining

# Then run the inlining pass
# ./bazel-bin/tools/qe-opt --inline $1
# ./bazel-bin/tools/qe-opt --affine-full-unroll $1
# ./bazel-bin/tools/qe-opt --inlinex $1
# ./bazel-bin/tools/qe-opt --inline="op-pipelines=func.func(canonicalize,cse)" $1 -o inlined.mlir
# ./bazel-bin/tools/qe-opt --inline="op-pipelines=func.func(canonicalize,cse),inline-threshold=100000000" $1 -o inlined.mlir

./bazel-bin/tools/qe-opt -inline -inline-threshold=100000000  $1 -o inlined.mlir
# ./bazel-bin/tools/qe-opt -zero-noise-extrapolation inlined.mlir -o tests/transformation_results/zero_noise_extrapolated.mlir

./bazel-bin/tools/qe-opt -nativization inlined.mlir -o tests/transformation_results/nativized.mlir

./bazel-bin/tools/qe-opt -scf-to-affine tests/transformation_results/nativized.mlir -o tests/transformation_results/scf_to_affine.mlir

./bazel-bin/tools/qe-opt --affine-loop-fusion tests/transformation_results/scf_to_affine.mlir -o tests/transformation_results/affine_loop_fusion.mlir