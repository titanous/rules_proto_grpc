"""Generated definition of python_grpclib_library."""

load("//python:python_grpclib_compile.bzl", "python_grpclib_compile")
load("//internal:compile.bzl", "proto_compile_attrs")
load("@rules_python//python:defs.bzl", "py_library")

def python_grpclib_library(name, **kwargs):
    # Compile protos
    name_pb = name + "_pb"
    python_grpclib_compile(
        name = name_pb,
        **{
            k: v
            for (k, v) in kwargs.items()
            if k in proto_compile_attrs.keys()
        }  # Forward args
    )

    # Create python library
    py_library(
        name = name,
        srcs = [name_pb],
        deps = [
            "@com_google_protobuf//:protobuf_python",
        ] + GRPC_DEPS + kwargs.get("deps", []),
        imports = [name_pb],
        visibility = kwargs.get("visibility"),
        tags = kwargs.get("tags"),
    )

GRPC_DEPS = [
    # Don't use requirement(), since rules_proto_grpc_py3_deps doesn't necessarily exist when
    # imported by defs.bzl
    "@rules_proto_grpc_py3_deps//pypi__grpclib",
]
