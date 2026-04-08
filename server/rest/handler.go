package rest

import (
	"net/http"
	"benchmark/models"
	"github.com/gin-gonic/gin"
)

type Handler struct {
	products []models.Product
}

func NewHandler(products []models.Product) *Handler {
	return &Handler{products: products}
}

func (h *Handler) RegisterRoutes(r *gin.Engine) {
	r.GET("/products", func(c *gin.Context) {
		c.JSON(http.StatusOK, h.products)
	})
}
