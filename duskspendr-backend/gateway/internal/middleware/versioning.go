// Package middleware contains API versioning middleware for Chi router
package middleware

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
)

// APIVersion represents supported API versions
type APIVersion string

const (
	// APIVersionV1 is the first version
	APIVersionV1 APIVersion = "v1"
	// APIVersionV2 is the second version (future)
	APIVersionV2 APIVersion = "v2"
	// APIVersionLatest is the current latest version
	APIVersionLatest = APIVersionV1
)

// Context key for API version
type contextKey string

const apiVersionKey contextKey = "api_version"

// VersionConfig holds versioning configuration
type VersionConfig struct {
	// DefaultVersion is used when no version is specified
	DefaultVersion APIVersion
	// SupportedVersions lists all supported versions
	SupportedVersions []APIVersion
	// DeprecatedVersions lists deprecated (but still working) versions
	DeprecatedVersions []APIVersion
}

// DefaultVersionConfig returns the default versioning configuration
func DefaultVersionConfig() VersionConfig {
	return VersionConfig{
		DefaultVersion:     APIVersionV1,
		SupportedVersions:  []APIVersion{APIVersionV1},
		DeprecatedVersions: []APIVersion{},
	}
}

// APIVersioning returns middleware that handles API versioning
// Supports versioning via URL path (/v1/...) or header (X-API-Version)
func APIVersioning(config VersionConfig) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			var version APIVersion

			// Check URL path first
			path := r.URL.Path
			if strings.HasPrefix(path, "/v1") {
				version = APIVersionV1
			} else if strings.HasPrefix(path, "/v2") {
				version = APIVersionV2
			}

			// Check header if not in path
			if version == "" {
				headerVersion := r.Header.Get("X-API-Version")
				if headerVersion != "" {
					version = APIVersion(headerVersion)
				}
			}

			// Accept header version (e.g., application/vnd.duskspendr.v1+json)
			if version == "" {
				accept := r.Header.Get("Accept")
				if strings.Contains(accept, "vnd.duskspendr.v1") {
					version = APIVersionV1
				} else if strings.Contains(accept, "vnd.duskspendr.v2") {
					version = APIVersionV2
				}
			}

			// Default version
			if version == "" {
				version = config.DefaultVersion
			}

			// Validate version is supported
			if !isVersionSupported(version, config.SupportedVersions) {
				w.Header().Set("Content-Type", "application/json")
				w.WriteHeader(http.StatusBadRequest)
				json.NewEncoder(w).Encode(map[string]any{
					"success": false,
					"error": map[string]any{
						"code":    "UNSUPPORTED_VERSION",
						"message": "API version not supported",
						"details": map[string]any{
							"requested":  version,
							"supported":  config.SupportedVersions,
							"deprecated": config.DeprecatedVersions,
						},
					},
				})
				return
			}

			// Check if deprecated
			if isVersionDeprecated(version, config.DeprecatedVersions) {
				w.Header().Set("X-API-Deprecated", "true")
				w.Header().Set("X-API-Deprecation-Date", "2027-01-01")
				w.Header().Set("Warning", `299 - "This API version is deprecated. Please migrate to the latest version."`)
			}

			// Set response header
			w.Header().Set("X-API-Version", string(version))

			// Store version in context
			ctx := context.WithValue(r.Context(), apiVersionKey, version)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// GetAPIVersion retrieves the API version from context
func GetAPIVersion(r *http.Request) APIVersion {
	if v, ok := r.Context().Value(apiVersionKey).(APIVersion); ok {
		return v
	}
	return APIVersionLatest
}

// GetAPIVersionFromContext retrieves the API version from context.Context
func GetAPIVersionFromContext(ctx context.Context) APIVersion {
	if v, ok := ctx.Value(apiVersionKey).(APIVersion); ok {
		return v
	}
	return APIVersionLatest
}

// isVersionSupported checks if a version is in the supported list
func isVersionSupported(version APIVersion, supported []APIVersion) bool {
	for _, v := range supported {
		if v == version {
			return true
		}
	}
	return false
}

// isVersionDeprecated checks if a version is deprecated
func isVersionDeprecated(version APIVersion, deprecated []APIVersion) bool {
	for _, v := range deprecated {
		if v == version {
			return true
		}
	}
	return false
}

// VersionedHandler creates handlers for different API versions
type VersionedHandler struct {
	handlers map[APIVersion]http.HandlerFunc
}

// NewVersionedHandler creates a new versioned handler
func NewVersionedHandler() *VersionedHandler {
	return &VersionedHandler{
		handlers: make(map[APIVersion]http.HandlerFunc),
	}
}

// V1 registers a handler for v1
func (vh *VersionedHandler) V1(handler http.HandlerFunc) *VersionedHandler {
	vh.handlers[APIVersionV1] = handler
	return vh
}

// V2 registers a handler for v2
func (vh *VersionedHandler) V2(handler http.HandlerFunc) *VersionedHandler {
	vh.handlers[APIVersionV2] = handler
	return vh
}

// ServeHTTP implements http.Handler
func (vh *VersionedHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	version := GetAPIVersion(r)

	// Try exact version match
	if handler, ok := vh.handlers[version]; ok {
		handler(w, r)
		return
	}

	// Fall back to v1 if available
	if handler, ok := vh.handlers[APIVersionV1]; ok {
		handler(w, r)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(http.StatusNotImplemented)
	json.NewEncoder(w).Encode(map[string]any{
		"success": false,
		"error": map[string]any{
			"code":    "VERSION_NOT_IMPLEMENTED",
			"message": "This endpoint is not available for the requested API version",
		},
	})
}
