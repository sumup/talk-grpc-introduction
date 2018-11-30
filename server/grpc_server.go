package main

import (
	"google.golang.org/grpc"
	"grpc-introduction-server/sdk"
	"grpc-introduction-server/server"
	"log"
	"net"
)

var network = "tcp"
var address = "localhost:6666"

func main() {
	listener, err := net.Listen(network, address)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	sdk.RegisterProductServiceServer(grpcServer, &server.GrpcServer{})
	_ = grpcServer.Serve(listener)
}
