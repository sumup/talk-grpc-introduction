# Structure
* [sdk](sdk) - Contains all gRPC definitions. The `*_service.proto` contains the service definitions
for the different parts of the gRPC server, while the [sdk.proto](sdk/sdk.proto) contains the
publicly exposed services. All other `*.proto` files are related to the gRPC models themselves.

* [protoc-tool.sh](protoc-tool.sh) - The proto generation for different languages (go and objc for
this demo) and a linter for the proto files.
