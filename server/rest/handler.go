package rest

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Handler struct {
	products interface{}
}

func NewHandler(products interface{}) *Handler {
	return &Handler{products: products}
}

func (h *Handler) RegisterRoutes(r *gin.Engine) {
	r.GET("/products", func(c *gin.Context) {
		c.JSON(http.StatusOK, h.products)
	})
}
