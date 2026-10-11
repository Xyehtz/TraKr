package main

import (
	"fmt"
	"log"
	"trakr/host"
)

func main() {
	information, err := host.GetHostInformation()

	if err != nil {
		log.Printf("%v", err)
	}

	fmt.Println(information)
}
