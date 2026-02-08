package handlers

import (
	"errors"

	"github.com/gofiber/fiber/v2"
)

// GlobalErrorHandler handles global errors
func GlobalErrorHandler(c *fiber.Ctx, err error) error {
	code := fiber.StatusInternalServerError
	var e *fiber.Error
	if errors.As(err, &e) {
		code = e.Code
	}

	return c.Status(code).JSON(fiber.Map{
		"success": false,
		"error": fiber.Map{
			"code":    "SERVER_ERROR",
			"message": err.Error(),
		},
	})
}
