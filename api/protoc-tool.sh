#!/bin/bash -l
set -e
set -u
set -o pipefail

BASE=$(cd "$(dirname "${0}")" && pwd)
ROOT_DIRECTORY=$(dirname "${BASE}")

PROTO_FILES="${BASE}/sdk/image.proto ${BASE}/sdk/image_service.proto ${BASE}/sdk/product.proto ${BASE}/sdk/product_service.proto sdk/sdk.proto"
PROTO_INCLUDE_DIR=${BASE}
PROTO_GO_OUT_DIR=${ROOT_DIRECTORY}/server
PROTO_OBJC_OUT_DIR=${ROOT_DIRECTORY}/client/Catalog/API/Generated
PROTO_OBJC_PLUGIN=${ROOT_DIRECTORY}/client/Pods/protoc-grpc/grpc_objective_c_plugin
PROTO_LINT_PLUGIN=$(which protoc-gen-lint)

function usage() {
    echo "Usage $0 <lint|gen-go|gen-objc>"
    exit
}

if [[ ${#} -ne 1 ]]; then
    usage
fi

if [[ "${1}" == "gen-go" ]]; then
    echo "-> Generating go source code from proto"
    protoc \
        -I ${PROTO_INCLUDE_DIR} \
        --go_out=plugins=grpc:${PROTO_GO_OUT_DIR} \
        ${PROTO_FILES}
elif [[ "${1}" == "gen-objc" ]]; then
    echo "-> Generating objc source code from proto"
    protoc \
        -I ${PROTO_INCLUDE_DIR} \
        --plugin=protoc-gen-grpc=${PROTO_OBJC_PLUGIN} \
        --objc_out=${PROTO_OBJC_OUT_DIR} \
        --grpc_out=${PROTO_OBJC_OUT_DIR} \
        ${PROTO_FILES}
elif [[ "${1}" == "lint" ]]; then
    echo "-> Linting proto files"
    protoc \
        -I ${PROTO_INCLUDE_DIR} \
        --plugin=${PROTO_LINT_PLUGIN} \
        --lint_out=sort_imports:. \
        ${PROTO_FILES}
else
    usage
fi

echo "-> Done"
