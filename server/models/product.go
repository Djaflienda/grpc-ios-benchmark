package models

type Specification struct {
	Key   string `json:"key"`
	Value string `json:"value"`
	Unit  string `json:"unit"`
}

type Product struct {
	ID          string            `json:"id"`
	Name        string            `json:"name"`
	Description string            `json:"description"`
	Price       float64           `json:"price"`
	Currency    string            `json:"currency"`
	Category    string            `json:"category"`
	ImageURLs   []string          `json:"image_urls"`
	Specs       []Specification   `json:"specs"`
	Attributes  map[string]string `json:"attributes"`
	StockCount  int64             `json:"stock_count"`
	Rating      float64           `json:"rating"`
	ReviewCount int32             `json:"review_count"`
	IsAvailable bool              `json:"is_available"`
	SellerID    string            `json:"seller_id"`
	CreatedAt   string            `json:"created_at"`
}
