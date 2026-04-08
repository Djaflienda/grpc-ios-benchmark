package grpc

import (
	"context"
	pb "benchmark/grpc/generated"
)

type Server struct {
	pb.UnimplementedProductServiceServer
	products []*pb.Product
}

func NewServer(products []*pb.Product) *Server {
	return &Server{products: products}
}

func (s *Server) GetProducts(
	ctx context.Context,
	req *pb.ProductRequest,
) (*pb.ProductList, error) {
	return &pb.ProductList{
		Products:  s.products,
		Total:     int32(len(s.products)),
		Timestamp: 1704067200,
	}, nil
}
