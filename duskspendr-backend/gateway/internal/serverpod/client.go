package serverpod

import (
  "bytes"
  "context"
  "crypto/hmac"
  "crypto/sha256"
  "encoding/base64"
  "io"
  "net/http"
  "strconv"
  "time"
)

type Client struct {
  BaseURL string
  HTTP    *http.Client
  SyncSharedSecret string
}

func New(baseURL string, syncSecret string) *Client {
  return &Client{
    BaseURL: baseURL,
    HTTP: &http.Client{
      Timeout: 5 * time.Second,
    },
    SyncSharedSecret: syncSecret,
  }
}

func (c *Client) Health(ctx context.Context) bool {
  if c.BaseURL == "" {
    return false
  }
  req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.BaseURL+"/health", nil)
  if err != nil {
    return false
  }
  resp, err := c.HTTP.Do(req)
  if err != nil {
    return false
  }
  defer resp.Body.Close()
  return resp.StatusCode >= 200 && resp.StatusCode < 300
}

func (c *Client) SyncTransactions(ctx context.Context, userID string, payload []byte) bool {
  if c.BaseURL == "" {
    return false
  }
  req, err := http.NewRequestWithContext(
    ctx,
    http.MethodPost,
    c.BaseURL+"/sync/transactions",
    http.NoBody,
  )
  if err != nil {
    return false
  }
  if len(payload) > 0 {
    req.Body = io.NopCloser(bytes.NewReader(payload))
    req.ContentLength = int64(len(payload))
    req.Header.Set("Content-Type", "application/json")
  }
  req.Header.Set("X-User-Id", userID)
  if c.SyncSharedSecret != "" {
    timestamp := strconv.FormatInt(time.Now().UTC().Unix(), 10)
    signature := signSyncPayload(c.SyncSharedSecret, timestamp, userID, payload)
    req.Header.Set("X-Sync-Timestamp", timestamp)
    req.Header.Set("X-Sync-Signature", signature)
  }
  resp, err := c.HTTP.Do(req)
  if err != nil {
    return false
  }
  defer resp.Body.Close()
  return resp.StatusCode >= 200 && resp.StatusCode < 300
}

func signSyncPayload(secret, timestamp, userID string, payload []byte) string {
  msg := append([]byte(timestamp+"."+userID+"."), payload...)
  mac := hmac.New(sha256.New, []byte(secret))
  _, _ = mac.Write(msg)
  return base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}
