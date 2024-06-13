# The "tools" directory contains binary targets that expose the public API of
# the passes in the project.

package(
    default_visibility = ["//visibility:public"],
)

# We name the tool `qe-opt` following the pattern of `mlir-opt`.
cc_binary(
    name = "qe-opt",
    srcs = ["qe-opt.cpp"],
    includes = ["include"],
    deps = [
        "//lib/Transform/Affine:Passes",
        "//lib/Transform/Arith:Passes",
        "@llvm-project//mlir:AllPassesAndDialects",
        "@llvm-project//mlir:MlirOptLib",
        "@llvm-project//mlir:Pass",
    ],
)