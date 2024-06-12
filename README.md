# Quantum Ensemble Dialect

## Setup

To build the dialect, you need to perform the following steps: 

### Install Bazel

We use Bazel 7.20.0 as a build system for LLVM and MLIR, and to manage testing for our dialect and passes.

First, download the Bazel installer:

```
wget https://github.com/bazelbuild/bazel/releases/download/7.2.0/bazel-7.2.0-installer-linux-x86_64.sh
```

This will create a script named ```bazel-7.2.0-installer-linux-x86_64.sh``` on your device.

Next, add execution permissions to the script:

```
chmod +x bazel-7.2.0-installer-linux-x86_64.sh
```

Before we can install Bazel, we need to install a few dependencies:

```
sudo dnf install g++ zip unzip
```

Then we can install Bazel:

```
./bazel-7.2.0-installer-linux-x86_64.sh --user
```

This will install Bazel in the $HOME/bin directory on your device, and will set the .bazelrc path (required to access bazel from the command line) to $HOME/.bazelrc.

Finally, we can store the location of the Bazel binary in PATH:

```
export PATH="$PATH:$HOME/bin"
```

### Build LLVM + MLIR

Installing LLVM and MLIR via Bazel is very simple. Before we can do so, however, we must install zlib:

```
sudo yum install zlib-devel
```

Now, we can use Bazel to install LLVM and MLIR. Run the following command in the root folder of the copy of the repository on your device, i.e. in the same folder as the WORKSPACE file that is stored in this repository:

```
bazel build @llvm-project//mlir/...:all
```

This command will take a while to execute, but once it is complete, LLVM and MLIR will be installed on your device. We can test MLIR by trying to run the mlir-opt binary:

```
bazel run @llvm-project//mlir:mlir-opt -- --help
```

If the build was successful, you should see something like this in your terminal:

```
OVERVIEW: MLIR modular optimizer driver

Available Dialects: acc, affine, amdgpu, amx, arith, arm_neon, arm_sve, async, bufferization, builtin, cf,
complex, dlti, emitc, func, gpu, index, irdl, linalg, llvm, math, memref, ml_program, nvgpu, nvvm, omp, pdl,
pdl_interp, quant, rocdl, scf, shape, sparse_tensor, spirv, tensor, test, test_dyn, tosa, transform, vector,
x86vector
USAGE: mlir-opt [options] <input file>

OPTIONS:
...
```

### Building the Quantum Ensemble Dialect


### Running tests

To run the tests for the Quantum Ensemble Dialect, execute the following command from the root directory of the repository:

```
bazel test //...
```

WARNING: some of the tests (those that use qe-opt) will fail, since qe-opt is currently not properly registed as a tool with bazel's test mechanism. I will figure out a solution for this soon, but for now am focused on building out the first part of the dialect + the ZNE compiler pass.

### Running individual compiler passes

We can run individual compiler passes using the qe-opt binary, which acts as a custom version of the mlir-opt tool that includes all of the Quantum Ensemble passes as well as built-in MLIR passes.

For example, to run the mul-to-shift-and-add optimization pass, which converts multiplications into a left shift and multiple additions, we first need to build the qe-opt binary and verify that the pass is registered:

```
bazel run tools:qe-opt -- --help
``` 

This will print a list of the passes available using qe-opt, which should include mul-to-shift-and-add:

```
OVERVIEW: Quantum Ensemble Compilation Pass Driver
Available Dialects: acc, affine, ...
USAGE: qe-opt [options] <input file>

...

General options:

  Compiler passes to run
    Passes:
      --affine-full-unroll                             -   Fully unroll all affine loops
      --affine-full-unroll-rewrite                     -   Fully unroll all affine loops using pattern rewrite engine
      --mul-to-add                                     -   Convert multiplicatoins to repeated additions
      --mul-to-shift-and-add                           -   Convert multiplications to shifts and additions
...
```

Next, execute the binary and pass in the MLIR code you want to compile (written in the arith dialect, since this compiler pass is defined for multiplication operations in the arith dialect: arith::MulIOp). We can pass in the file at ```./tests/mul_to_add.mlir```, which contains the following code:

```
func.func @just_power_of_two(%arg: i32) -> i32 {
  %0 = arith.constant 8 : i32
  %1 = arith.muli %arg, %0 : i32
  func.return %1 : i32
}

func.func @power_of_two_plus_one(%arg: i32) -> i32 {
  %0 = arith.constant 9 : i32
  %1 = arith.muli %arg, %0 : i32
  func.return %1 : i32
}
```

We can compile this by executing the following command:

```
./bazel-bin/tools/qe-opt --mul-to-shift-and-add ./tests/mul_to_add.mlir
```

The output will be something like the code shown below - notice how the arith.muli operations are gone, and some new arith.shli and arith.addi operations have been added instead:

```
module {
  func.func @just_power_of_two(%arg0: i32) -> i32 {
    %c3_i32 = arith.constant 3 : i32
    %0 = arith.shli %arg0, %c3_i32 : i32
    return %0 : i32
  }

  func.func @power_of_two_plus_one(%arg0: i32) -> i32 {
    %c3_i32 = arith.constant 3 : i32
    %0 = arith.shli %arg0, %c3_i32 : i32
    %1 = arith.addi %0, %arg0 : i32
    return %1 : i32
  }
}
```

### TODOs

* Fix tests using qe-opt binary which error out with ''qe-opt': command not found'
* Add GitHub actions for CI to do testing on every new commit / merge: https://github.com/j2kun/mlir-tutorial/commit/b17efb4fdc98f9f48a680ef771ccb9e165d255f5