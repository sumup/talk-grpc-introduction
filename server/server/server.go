package server

import (
	"context"
	"fmt"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"grpc-introduction-server/sdk"
)

var products []*sdk.ProductWithUniqueId
var currentProductID = 0

// GrpcServer is the gRPC server implementation.
type GrpcServer struct {
}

// CreateProduct is used for creating a product in the in-memory database.
func (GrpcServer) CreateProduct(context context.Context, request *sdk.CreateProductRequest) (*sdk.CreateProductResponse, error) {
	product := createProductFromInput(request)
	products = append(products, product)

	return &sdk.CreateProductResponse{Product: product}, nil
}

// UpdateProduct is used for updating a product in the in-memory database.
func (GrpcServer) UpdateProduct(context context.Context, request *sdk.UpdateProductRequest) (*sdk.UpdateProductResponse, error) {
	product := findProductByUniqueID(request.UniqueId)
	if product == nil {
		return nil, status.New(codes.NotFound, "Product not found").Err()
	}

	updateProductFromInput(product, request)

	return &sdk.UpdateProductResponse{Product: product}, nil
}

// DeleteProduct is used for deleting a product from the in-memory database.
func (GrpcServer) DeleteProduct(context context.Context, request *sdk.DeleteProductRequest) (*sdk.DeleteProductResponse, error) {
	if deleteProductByUniqueID(request.UniqueId) {
		return &sdk.DeleteProductResponse{}, nil
	}

	return nil, status.New(codes.NotFound, "Product not found").Err()
}

// GetProducts is used for retrieving all products from the in-memory database.
func (GrpcServer) GetProducts(context.Context, *sdk.GetProductsRequest) (*sdk.GetProductsResponse, error) {
	return &sdk.GetProductsResponse{Product: products}, nil
}

func createProductFromInput(input *sdk.CreateProductRequest) *sdk.ProductWithUniqueId {
	currentProductID = currentProductID + 1

	product := &sdk.ProductWithUniqueId{
		UniqueId: fmt.Sprintf("%d", currentProductID),
		Product:  input.Product,
	}

	if input.Image != nil {
		product.Image = input.Image.Image
	}

	return product
}

func findProductByUniqueID(uniqueID string) *sdk.ProductWithUniqueId {
	for _, product := range products {
		if product.UniqueId != uniqueID {
			continue
		}

		return product
	}

	return nil
}

func updateProductFromInput(product *sdk.ProductWithUniqueId, input *sdk.UpdateProductRequest) {
	if input.Product != nil {
		product.Product = input.Product
	}

	if input.Image != nil {
		product.Image = input.Image.Image
	}
}

func deleteProductByUniqueID(uniqueID string) bool {
	for i, product := range products {
		if product.UniqueId != uniqueID {
			continue
		}

		products = append(products[:i], products[i+1:]...)
		return true
	}

	return false
}
