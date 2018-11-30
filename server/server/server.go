package server

import (
	"context"
	"fmt"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"grpc-introduction-server/sdk"
)

// GrpcServer is the gRPC server implementation.
type GrpcServer struct {
	products         []*sdk.ProductWithUniqueId
	currentProductID int64
}

// CreateProduct is used for creating a product in the in-memory database.
func (server *GrpcServer) CreateProduct(context context.Context, request *sdk.CreateProductRequest) (*sdk.CreateProductResponse, error) {
	product := server.createProductFromInput(request)
	server.products = append(server.products, product)

	return &sdk.CreateProductResponse{Product: product}, nil
}

// UpdateProduct is used for updating a product in the in-memory database.
func (server *GrpcServer) UpdateProduct(context context.Context, request *sdk.UpdateProductRequest) (*sdk.UpdateProductResponse, error) {
	product := server.findProductByUniqueID(request.UniqueId)
	if product == nil {
		return nil, status.New(codes.NotFound, "Product not found").Err()
	}

	server.updateProductFromInput(product, request)

	return &sdk.UpdateProductResponse{Product: product}, nil
}

// DeleteProduct is used for deleting a product from the in-memory database.
func (server *GrpcServer) DeleteProduct(context context.Context, request *sdk.DeleteProductRequest) (*sdk.DeleteProductResponse, error) {
	if server.deleteProductByUniqueID(request.UniqueId) {
		return &sdk.DeleteProductResponse{}, nil
	}

	return nil, status.New(codes.NotFound, "Product not found").Err()
}

// GetProducts is used for retrieving all products from the in-memory database.
func (server *GrpcServer) GetProducts(context.Context, *sdk.GetProductsRequest) (*sdk.GetProductsResponse, error) {
	return &sdk.GetProductsResponse{Product: server.products}, nil
}

func (server *GrpcServer) createProductFromInput(input *sdk.CreateProductRequest) *sdk.ProductWithUniqueId {
	server.currentProductID = server.currentProductID + 1

	product := &sdk.ProductWithUniqueId{
		UniqueId: fmt.Sprintf("%d", server.currentProductID),
		Product:  input.Product,
	}

	if input.Image != nil {
		product.Image = input.Image.Image
	}

	return product
}

func (server *GrpcServer) findProductByUniqueID(uniqueID string) *sdk.ProductWithUniqueId {
	for _, product := range server.products {
		if product.UniqueId != uniqueID {
			continue
		}

		return product
	}

	return nil
}

func (server *GrpcServer) updateProductFromInput(product *sdk.ProductWithUniqueId, input *sdk.UpdateProductRequest) {
	if input.Product != nil {
		product.Product = input.Product
	}

	if input.Image != nil {
		product.Image = input.Image.Image
	}
}

func (server *GrpcServer) deleteProductByUniqueID(uniqueID string) bool {
	for i, product := range server.products {
		if product.UniqueId != uniqueID {
			continue
		}

		server.products = append(server.products[:i], server.products[i+1:]...)
		return true
	}

	return false
}
