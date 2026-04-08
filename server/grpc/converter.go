package grpc

import (
	pb "benchmark/grpc/generated"
	"benchmark/models"
)

func ToProtoProducts(products []models.Product) []*pb.Product {
	result := make([]*pb.Product, len(products))
	for i, p := range products {
		specs := make([]*pb.Specification, len(p.Specs))
		for j, s := range p.Specs {
			specs[j] = &pb.Specification{
				Key:   s.Key,
				Value: s.Value,
				Unit:  s.Unit,
			}
		}
		result[i] = &pb.Product{
			Id:          p.ID,
			Name:        p.Name,
			Description: p.Description,
			Price:       p.Price,
			Currency:    p.Currency,
			Category:    p.Category,
			ImageUrls:   p.ImageURLs,
			Specs:       specs,
			Attributes:  p.Attributes,
			StockCount:  p.StockCount,
			Rating:      p.Rating,
			ReviewCount: p.ReviewCount,
			IsAvailable: p.IsAvailable,
			SellerId:    p.SellerID,
			CreatedAt:   p.CreatedAt,
		}
	}
	return result
}
