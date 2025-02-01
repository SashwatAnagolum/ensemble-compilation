# Analysis passes for the Ensemble Dialect

package(
    default_visibility = ["//visibility:public"],
)

cc_library(
    name = "CountGatelikeOps",
    srcs = ["CountGatelikeOps.cpp"],
    hdrs = ["CountGatelikeOps.h"],
    deps = [
        "//lib/Dialect/Ensemble",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Transforms",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:SCFDialect"
    ],
)
