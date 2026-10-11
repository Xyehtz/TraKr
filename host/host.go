package host

import (
	"errors"
	"fmt"

	"github.com/shirou/gopsutil/v4/host"
)

func GetHostInformation() (string, error) {
	platform, family, version, err := host.PlatformInformation()

	if err != nil {
		return "", errors.New(err.Error())
	}

	return fmt.Sprintf("Platform: %s\nFamily: %s\nVersion: %s", platform, family, version), nil
}
