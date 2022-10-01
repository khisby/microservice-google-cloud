package main

import (
	"fmt"
	"log"
	"net/http"
)

func homePage(w http.ResponseWriter, r *http.Request) {
	serviceName := "backend service b"
	log.Println(fmt.Sprintf("Endpoint Hit %s", serviceName))
	w.Write([]byte(fmt.Sprintf("Welcome to %s!", serviceName)))
}

func handleRequest() {
	http.HandleFunc("/", homePage)
	log.Println("Golang service is running on port 80")
	log.Fatal(http.ListenAndServe(":80", nil))
}

func main() {
	handleRequest()
}
