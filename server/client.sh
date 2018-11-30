#!/bin/bash -l
set -e
set -u
set -o pipefail

BASE=$(cd "$(dirname "${0}")" && pwd)
ROOT_DIRECTORY=$(dirname "${BASE}")

PROTO_PATH=${ROOT_DIRECTORY}/api
PROTO_SDK=sdk/sdk.proto
PROTO_URL=localhost:6666

CREATE_PRODUCT_METHOD=sdk.ProductService/CreateProduct
UPDATE_PRODUCT_METHOD=sdk.ProductService/UpdateProduct
DELETE_PRODUCT_METHOD=sdk.ProductService/DeleteProduct
GET_PRODUCTS_METHOD=sdk.ProductService/GetProducts

# Create product
grpcurl \
    -plaintext \
    -import-path ${PROTO_PATH} \
    -proto=${PROTO_SDK} \
    -d '{"product": {"name": "Test Product", "description": "Test Description", "price": 6.66}}' \
    ${PROTO_URL} \
    ${CREATE_PRODUCT_METHOD}

# Update product
grpcurl \
    -plaintext \
    -import-path ${PROTO_PATH} \
    -proto=${PROTO_SDK} \
    -d '{"unique_id": "1", "product": {"name": "Test Product1", "description": "Test Description1", "price": 9.99}}' \
    ${PROTO_URL} \
    ${UPDATE_PRODUCT_METHOD}

# Get products
grpcurl \
    -plaintext \
    -import-path ${PROTO_PATH} \
    -proto=${PROTO_SDK} \
    ${PROTO_URL} \
    ${GET_PRODUCTS_METHOD}

# Delete product
grpcurl \
    -plaintext \
    -import-path ${PROTO_PATH} \
    -proto=${PROTO_SDK} \
    -d '{"unique_id": "1"}' \
    ${PROTO_URL} \
    ${DELETE_PRODUCT_METHOD}

# Get products
grpcurl \
    -plaintext \
    -import-path ${PROTO_PATH} \
    -proto=${PROTO_SDK} \
    ${PROTO_URL} \
    ${GET_PRODUCTS_METHOD}
