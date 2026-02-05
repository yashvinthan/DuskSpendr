// Package middleware contains HTTP middleware for the gateway
package middleware

import (
	"strings"

	"github.com/gofiber/fiber/v2"

	"duskspendr/gateway/internal/services"
)

// Auth middleware validates JWT tokens and sets user context
func Auth(jwtService *services.JWTService) fiber.Handler {
	return func(c *fiber.Ctx) error {
		// Get authorization header
		authHeader := c.Get("Authorization")
		if authHeader == "" {
			return c.Status(401).JSON(fiber.Map{
				"success": false,
				"error": fiber.Map{
					"code":    "UNAUTHORIZED",
					"message": "Authorization header is required",
				},
			})
		}

		// Extract token
		parts := strings.Split(authHeader, " ")
		if len(parts) != 2 || strings.ToLower(parts[0]) != "bearer" {
			return c.Status(401).JSON(fiber.Map{
				"success": false,
				"error": fiber.Map{
					"code":    "INVALID_TOKEN",
					"message": "Invalid authorization header format",
				},
			})
		}

		tokenString := parts[1]

		// Validate token
		claims, err := jwtService.ValidateAccessToken(tokenString)
		if err != nil {
			switch err {
			case services.ErrExpiredToken:
				return c.Status(401).JSON(fiber.Map{
					"success": false,
					"error": fiber.Map{
						"code":    "TOKEN_EXPIRED",
						"message": "Access token has expired",
					},
				})
			default:
				return c.Status(401).JSON(fiber.Map{
					"success": false,
					"error": fiber.Map{
						"code":    "INVALID_TOKEN",
						"message": "Invalid access token",
					},
				})
			}
		}

		// Set user context
		c.Locals("userID", claims.UserID)
		c.Locals("email", claims.Email)
		c.Locals("phone", claims.Phone)
		c.Locals("claims", claims)

		return c.Next()
	}
}

// GetUserID extracts user ID from context
func GetUserID(c *fiber.Ctx) string {
	if userID, ok := c.Locals("userID").(string); ok {
		return userID
	}
	return ""
}

// GetUserEmail extracts user email from context
func GetUserEmail(c *fiber.Ctx) string {
	if email, ok := c.Locals("email").(string); ok {
		return email
	}
	return ""
}

// GetUserPhone extracts user phone from context
func GetUserPhone(c *fiber.Ctx) string {
	if phone, ok := c.Locals("phone").(string); ok {
		return phone
	}
	return ""
}
