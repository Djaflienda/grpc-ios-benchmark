package main

import (
	"benchmark/models"
	"fmt"
)

func generateProducts(n int) []models.Product {
	products := make([]models.Product, n)
	for i := 0; i < n; i++ {
		products[i] = models.Product{
			ID:   fmt.Sprintf("product-%d", i+1),
			Name: fmt.Sprintf("Product %d — Premium Edition", i+1),
			Description: fmt.Sprintf(
				"This is a detailed description for product %d. "+
					"It contains rich information about the item including "+
					"materials, dimensions, care instructions, and warranty. "+
					"The product has been carefully crafted to meet the highest "+
					"standards of quality and durability. Suitable for everyday use.",
				i+1,
			),
			Price:    float64(100+i*10) + 0.99,
			Currency: "RUB",
			Category: []string{"Electronics", "Clothing", "Home", "Sports", "Books"}[i%5],
			ImageURLs: []string{
				fmt.Sprintf("https://cdn.example.com/products/%d/image1.jpg", i+1),
				fmt.Sprintf("https://cdn.example.com/products/%d/image2.jpg", i+1),
				fmt.Sprintf("https://cdn.example.com/products/%d/image3.jpg", i+1),
			},
			Specs: []models.Specification{
				{Key: "weight", Value: fmt.Sprintf("%.1f", float64(i+1)*0.5), Unit: "kg"},
				{Key: "width", Value: fmt.Sprintf("%d", 10+i), Unit: "cm"},
				{Key: "height", Value: fmt.Sprintf("%d", 20+i), Unit: "cm"},
				{Key: "depth", Value: fmt.Sprintf("%d", 5+i), Unit: "cm"},
				{Key: "color", Value: []string{"red", "blue", "green", "black", "white"}[i%5], Unit: ""},
				{Key: "material", Value: "premium", Unit: ""},
				{Key: "warranty", Value: "12", Unit: "months"},
				{Key: "voltage", Value: "220", Unit: "V"},
				{Key: "power", Value: fmt.Sprintf("%d", 50+i*5), Unit: "W"},
				{Key: "frequency", Value: "50", Unit: "Hz"},
			},
			Attributes: map[string]string{
				"brand":   fmt.Sprintf("Brand-%d", i%10),
				"model":   fmt.Sprintf("Model-X%d", i+1),
				"origin":  "Russia",
				"sku":     fmt.Sprintf("SKU-%06d", i+1),
				"barcode": fmt.Sprintf("460%09d", i+1),
			},
			StockCount:  int64(100 + i*7),
			Rating:      float64(int((3.5+float64(i%3)*0.5)*10)) / 10,
			ReviewCount: int32(50 + i*13),
			IsAvailable: i%7 != 0,
			SellerID:    fmt.Sprintf("seller-%d", i%20+1),
			CreatedAt:   "2024-01-15T10:00:00Z",
		}
	}
	return products
}
