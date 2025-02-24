#!/bin/bash
echo "hi"
if [ -n "$1" ] 
then 
    echo "Testing '$1'"
else
    echo "Usage ./round_trip_test.sh {test file}" 
    exit 1
fi 

bazel run tools:qe-opt -- --help >/dev/null
if [ $? -ne 0 ]; then
    echo "Error: building qe-opt and library failed"
    exit 1
fi

./bazel-bin/tools/qe-opt --verify-roundtrip $1


# Run the inlining pass
./bazel-bin/tools/qe-opt -inline -inline-threshold=100000000  $1 -o inlined.mlir

# Use the time command to measure the duration of the transformation process
time (
    ./bazel-bin/tools/qe-opt -nativization inlined.mlir -o tests/transformation_results/nativized.mlir
    ./bazel-bin/tools/qe-opt -scf-to-affine tests/transformation_results/nativized.mlir -o tests/transformation_results/scf_to_affine.mlir
    ./bazel-bin/tools/qe-opt --affine-loop-fusion tests/transformation_results/scf_to_affine.mlir -o tests/transformation_results/affine_loop_fusion.mlir
    ./bazel-bin/tools/qe-opt --debug --gate-merging tests/transformation_results/affine_loop_fusion.mlir -o tests/transformation_results/gate_merged.mlir 
    # ./bazel-bin/tools/qe-opt  --gate-merging tests/transformation_results/affine_loop_fusion.mlir -o tests/transformation_results/gate_merged.mlir 
) > time_output.txt 2>&1

# Extract the real time from the time command output
elapsed_time=$(grep real time_output.txt | awk '{print $2}')

# Get the file size of the final output
file_size=$(stat -f%z "tests/transformation_results/gate_merged.mlir")

# Log the results
echo "$(basename $1), $elapsed_time, $file_size bytes" >> transformation_log.txt

cp tests/transformation_results/gate_merged.mlir tests/final_transformed_circuits/$(basename $1)
