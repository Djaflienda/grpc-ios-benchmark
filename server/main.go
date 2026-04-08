package main

import (
	"log"
	"net"

	pb "benchmark/grpc/generated"
	grpcserver "benchmark/grpc"
	"benchmark/rest"

	"github.com/gin-gonic/gin"
	"google.golang.org/grpc"
)

func main() {
	// Генерируем данные один раз — используют оба сервера
	products := generateProducts(50)
	protoProducts := grpcserver.ToProtoProducts(products)

	// Запускаем REST-сервер в горутине
	go func() {
		r := gin.Default()
		restHandler := rest.NewHandler(products)
		restHandler.RegisterRoutes(r)
		log.Println("REST server listening on :8080")
		if err := r.Run(":8080"); err != nil {
			log.Fatalf("REST server error: %v", err)
		}
	}()

	// Запускаем gRPC-сервер
	lis, err := net.Listen("tcp", ":50051")
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	grpcSrv := grpc.NewServer()
	pb.RegisterProductServiceServer(grpcSrv, grpcserver.NewServer(protoProducts))

	log.Println("gRPC server listening on :50051")
	if err := grpcSrv.Serve(lis); err != nil {
		log.Fatalf("gRPC server error: %v", err)
	}
}
