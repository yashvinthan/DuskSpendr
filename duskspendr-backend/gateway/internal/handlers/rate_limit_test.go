package handlers

import (
	"fmt"
	"math"
	"testing"
	"time"
)

// BenchmarkRateLimiter_Allow measures the performance of allow() when the map is full of items.
func BenchmarkRateLimiter_Allow(b *testing.B) {
    // Set a huge burst so we don't get rate limited, allowing us to measure the overhead of allow() itself.
    // In the old implementation, allow() called cleanupLocked(), which was O(N).
    // In the new implementation, it should be O(1).
	l := newRateLimiter(600, math.MaxInt32)

    // Manually fill the buckets
    now := time.Now()
    l.mu.Lock()
	for i := 0; i < 10000; i++ {
        key := fmt.Sprintf("user-%d", i)
        l.buckets[key] = &tokenBucket{tokens: 100, last: now}
	}
    l.mu.Unlock()

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		l.allow("active-user")
	}
}

// TestRateLimiter_Cleanup confirms that items are cleaned up eventually.
func TestRateLimiter_Cleanup(t *testing.T) {
	l := newRateLimiter(600, 100)
	l.ttl = 100 * time.Millisecond // Short TTL for test

	l.allow("expired-user")
	time.Sleep(200 * time.Millisecond) // Wait for expiration

    // Since cleanup runs in background every minute, we manually trigger it here
    // to verify the logic.
    l.cleanup()

	l.mu.Lock()
	defer l.mu.Unlock()
	if _, exists := l.buckets["expired-user"]; exists {
		t.Errorf("expired-user should have been cleaned up")
	}
}
