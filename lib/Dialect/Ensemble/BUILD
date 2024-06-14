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
        # the base mlir target for defining operations and dialects in tablegen
        "@llvm-project//mlir:OpBaseTdFiles",
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
        # the base mlir target for defining operations and dialects in tablegen
        ":td_files"
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
        ":dialect_inc_gen",
        ":td_files",
    ],
)

cc_library(
    name = "Ensemble",
    srcs = ["EnsembleDialect.cpp"],
    hdrs = [
        "EnsembleDialect.h",
        "EnsembleTypes.h"
    ],
    deps = [
        ":dialect_inc_gen",
        ":types_inc_gen",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:Support"
    ],
)