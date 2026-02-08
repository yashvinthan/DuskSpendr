package handlers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/proxy"
)

// ProxyTo creates a reverse proxy handler
func ProxyTo(targetURL string) fiber.Handler {
	return func(c *fiber.Ctx) error {
		url := targetURL + c.Path()
		if err := proxy.Do(c, url); err != nil {
			return err
		}
		// Remove Server header
		c.Response().Header.Del(fiber.HeaderServer)
		return nil
	}
}
