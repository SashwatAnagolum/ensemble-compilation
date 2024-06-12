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
bazel build @llvm-project//mlir/…:all
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
