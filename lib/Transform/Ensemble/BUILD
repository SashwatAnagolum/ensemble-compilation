# Passes that work with the Ensemble dialect

load("@llvm-project//mlir:tblgen.bzl", "gentbl_cc_library")

package(
    default_visibility = ["//visibility:public"],
)

gentbl_cc_library(
    name = "pass_inc_gen",
    tbl_outs = [
        (
            [
                "-gen-pass-decls",
                "-name=Ensemble",
            ],
            "Passes.h.inc",
        ),
        (
            ["-gen-pass-doc"],
            "EnsemblePasses.md",
        ),
    ],
    tblgen = "@llvm-project//mlir:mlir-tblgen",
    td_file = "Passes.td",
    deps = [
        "@llvm-project//mlir:OpBaseTdFiles",
        "@llvm-project//mlir:PassBaseTdFiles",
    ],
)

cc_library(
    name = "ZeroNoiseExtrapolation",
    srcs = ["ZeroNoiseExtrapolation.cpp"],
    hdrs = [
        "ZeroNoiseExtrapolation.h",
        "Passes.h",
    ],
    deps = [
        ":pass_inc_gen",
        "//lib/Dialect/Ensemble",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:AffineUtils",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:FuncDialect",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Transforms",
    ],
)

cc_library(
    name = "PDagParse",
    srcs = ["PDagParse.cpp"],
    hdrs = [
        "PDagParse.h",
        "Passes.h",
    ],
    deps = [
        ":pass_inc_gen",
        "//lib/Dialect/Ensemble",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:AffineUtils",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:FuncDialect",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Transforms",
        ":PDag",

    ],
)

cc_library(
    name = "Inlinex",
    srcs = ["Inlinex.cpp"],
    hdrs = [
        "Inlinex.h",
        "Passes.h",
    ],
    deps = [
        ":pass_inc_gen",
        "//lib/Dialect/Ensemble",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:AffineUtils",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:FuncDialect",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Transforms",
    ],
)

cc_library(
    name = "PDag",
    srcs = ["PDag.cpp"],
    hdrs = ["PDag.h"],
)

cc_library(
    name = "Nativization",
    srcs = ["Nativization.cpp"],
    hdrs = [
        "Nativization.h",
        "Passes.h",
    ],
    deps = [
        ":pass_inc_gen",
        "//lib/Dialect/Ensemble",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:AffineUtils",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:FuncDialect",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Transforms",
    ],
)

cc_library(
    name = "SCFToAffine",
    srcs = ["SCFToAffine.cpp"],
    hdrs = ["SCFToAffine.h", "Passes.h"],
    deps = [
        ":pass_inc_gen",
        "//lib/Dialect/Ensemble",
        "@llvm-project//mlir:AffineDialect",
        "@llvm-project//mlir:AffineUtils",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:SCFDialect",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Transforms",
    ],
)

cc_library(
    name = "Passes",
    hdrs = ["Passes.h"],
    deps = [
        ":ZeroNoiseExtrapolation",
        ":PDagParse",
        ":Inlinex",
        ":Nativization",
        ":SCFToAffine",
        ":pass_inc_gen",
    ],
)





