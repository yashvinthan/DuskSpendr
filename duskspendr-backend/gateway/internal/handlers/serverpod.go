package handlers

import (
  "net/http"

  "duskspendr/gateway/internal/serverpod"
)

type ServerpodHandler struct {
  Client *serverpod.Client
}

func (h *ServerpodHandler) Health(w http.ResponseWriter, r *http.Request) {
  if h.Client == nil {
    writeJSON(w, http.StatusOK, map[string]any{
      "available": false,
      "status":    "unconfigured",
    })
    return
  }
  ok := h.Client.Health(r.Context())
  status := "down"
  if ok {
    status = "ok"
  }
  writeJSON(w, http.StatusOK, map[string]any{
    "available": ok,
    "status":    status,
  })
}
