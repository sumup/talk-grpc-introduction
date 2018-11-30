# Structure

* [sdk](sdk) - Contains all gRPC definitions. The `*_service.proto` contains the service definitions
for the different parts of the gRPC server, while the [sdk.proto](sdk/sdk.proto) contains the
publicly exposed services. All other `*.proto` files are related to the gRPC models themselves.

* [protoc-tool.sh](protoc-tool.sh) - The proto generation for different languages (go and objc for
this demo) and a linter for the proto files.

# Prerequisites

In order to use the [protoc-tool.sh](protoc-tool.sh) you need `protoc`, which can be installed via
Homebrew on OSX:

```bash
brew install protobuf
```

You also need a few protoc plugins:

* [protoc-gen-go](https://github.com/golang/protobuf)
* [protoc-gen-lint](https://github.com/ckaznocha/protoc-gen-lint)
* [grpc_objective_c_plugin](https://cocoapods.org/pods/!ProtoCompiler-gRPCPlugin), which is going
to be installed by [CocoaPods](https://cocoapods.org) later on.