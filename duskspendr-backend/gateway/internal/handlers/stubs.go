package handlers

import (
	"github.com/gofiber/fiber/v2"
	"github.com/jackc/pgx/v5/pgxpool"

	"duskspendr-gateway/internal/services"
)

type NotificationHandler struct {
	Pool    *pgxpool.Pool
	Service *services.NotificationService
}

func NewNotificationHandler(pool *pgxpool.Pool, service *services.NotificationService) *NotificationHandler {
	return &NotificationHandler{
		Pool:    pool,
		Service: service,
	}
}

func (h *NotificationHandler) List(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"items": []interface{}{}})
}

func (h *NotificationHandler) MarkRead(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"status": "ok"})
}

func (h *NotificationHandler) Subscribe(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"status": "subscribed"})
}

type SplitHandler struct {
	Pool *pgxpool.Pool
}

func NewSplitHandler(pool *pgxpool.Pool) *SplitHandler {
	return &SplitHandler{Pool: pool}
}

func (h *SplitHandler) ListGroups(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"items": []interface{}{}})
}

func (h *SplitHandler) CreateGroup(c *fiber.Ctx) error {
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"id": "group_123"})
}

func (h *SplitHandler) GetGroup(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"id": c.Params("groupId")})
}

func (h *SplitHandler) AddExpense(c *fiber.Ctx) error {
	return c.Status(fiber.StatusCreated).JSON(fiber.Map{"id": "expense_123"})
}

func (h *SplitHandler) GetBalances(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"balances": []interface{}{}})
}

func (h *SplitHandler) SettleUp(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"status": "settled"})
}

type ExportHandler struct {
	Pool *pgxpool.Pool
}

func NewExportHandler(pool *pgxpool.Pool) *ExportHandler {
	return &ExportHandler{Pool: pool}
}

func (h *ExportHandler) Request(c *fiber.Ctx) error {
	return c.Status(fiber.StatusAccepted).JSON(fiber.Map{"id": "export_123"})
}

func (h *ExportHandler) Status(c *fiber.Ctx) error {
	return c.JSON(fiber.Map{"status": "processing"})
}

func (h *ExportHandler) Download(c *fiber.Ctx) error {
	return c.SendString("file content")
}
