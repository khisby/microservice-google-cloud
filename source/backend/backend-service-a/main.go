package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func homePage(w http.ResponseWriter, r *http.Request) {
	serviceName := "backend service a"
	hostName, err := os.Hostname()
	if err != nil {
		panic(err)
	}
	log.Println(fmt.Sprintf("Endpoint Hit %s at %s", serviceName, hostName))
	w.Write([]byte(fmt.Sprintf("Welcome to %s at %s", serviceName, hostName)))

}

func handleRequest() {
	http.HandleFunc("/", homePage)
	log.Println("Golang service is running on port 80")
	log.Fatal(http.ListenAndServe(":80", nil))
}

func main() {
	handleRequest()
}
