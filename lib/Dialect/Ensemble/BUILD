load("@llvm-project//mlir:tblgen.bzl", "gentbl_cc_library", "td_library")

package(
    default_visibility = ["//visibility:public"],
)

td_library(
    name = "td_files",
    srcs = [
        "EnsembleDialect.td",
        "EnsembleTypes.td",
    ],
    includes = [],
    deps = [
        "@llvm-project//mlir:OpBaseTdFiles",
        "@llvm-project//mlir:SideEffectInterfacesTdFiles",

    ],
)

gentbl_cc_library(
    name = "dialect_inc_gen",
    tbl_outs = [
        (
            ["-gen-dialect-decls"],
            "EnsembleDialect.h.inc",
        ),
        (
            ["-gen-dialect-defs"],
            "EnsembleDialect.cpp.inc",
        ),
    ],
    tblgen = "@llvm-project//mlir:mlir-tblgen",
    td_file = "EnsembleDialect.td",
    deps = [
        ":td_files",
        "@llvm-project//mlir:SideEffectInterfaces",
    ],
)

gentbl_cc_library(
    name = "types_inc_gen",
    tbl_outs = [
        (
            ["-gen-typedef-decls"],
            "EnsembleTypes.h.inc",
        ),
        (
            ["-gen-typedef-defs"],
            "EnsembleTypes.cpp.inc",
        ),
    ],
    tblgen = "@llvm-project//mlir:mlir-tblgen",
    td_file = "EnsembleTypes.td",
    deps = [
        "@llvm-project//mlir:SideEffectInterfaces",
        ":dialect_inc_gen",
        ":td_files",
        
    ],
)

gentbl_cc_library(
    name = "ops_inc_gen",
    tbl_outs = [
        (
            ["-gen-op-decls"],
            "EnsembleOps.h.inc",
        ),
        (
            ["-gen-op-defs"],
            "EnsembleOps.cpp.inc",
        ),
    ],
    tblgen = "@llvm-project//mlir:mlir-tblgen",
    td_file = "EnsembleOps.td",
    deps = [
        "@llvm-project//mlir:SideEffectInterfaces",
        ":dialect_inc_gen",
        ":td_files",
        ":types_inc_gen",
    ],
)

cc_library(
    name = "Ensemble",
    srcs = ["EnsembleDialect.cpp", "EnsembleOps.cpp"],
    hdrs = [
        "EnsembleDialect.h",
        "EnsembleTypes.h",
        "EnsembleOps.h",
        "EnsembleInlinerInterface.h"
    ],
    deps = [
        ":dialect_inc_gen",
        ":types_inc_gen",
        ":ops_inc_gen",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:Support",
        "@llvm-project//mlir:ArithDialect",
        "@llvm-project//mlir:SideEffectInterfaces"
    ],
)

cc_library(
    name = "EnsembleInlinerInterface",
    srcs = ["EnsembleInlinerInterface.cpp"],
    hdrs = ["EnsembleInlinerInterface.h"],
    deps = [
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:Support",
        "@llvm-project//mlir:SideEffectInterfaces",
    ],
)