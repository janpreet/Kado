package config

var ValidBeadNames = map[string]bool{
	"ansible":   true,
	"terraform": true,
	"opa":       true,
}

func GetValidBeads() map[string]struct{} {
	return map[string]struct{}{
		"ansible":   {},
		"terraform": {},
		"opa":       {},
	}
}