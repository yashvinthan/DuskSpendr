package utils

import (
	"regexp"
)

// ValidatePhoneE164 validates a phone number in E.164 format
func ValidatePhoneE164(phone string) bool {
	re := regexp.MustCompile(`^\+[1-9]\d{7,14}$`)
	return re.MatchString(phone)
}
