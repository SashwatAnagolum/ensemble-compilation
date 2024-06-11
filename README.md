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

Follow the instructions at https://www.jeremykun.com/2023/08/10/mlir-getting-started/

We also needed to install zlib o nLinux:

```
sudo yum install zlib-devel
```