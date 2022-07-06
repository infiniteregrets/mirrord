package main

import (
	"fmt"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	if r.Method == "GET" {
		fmt.Println("GET")
	} else if r.Method == "POST" {
		fmt.Println("POST")
	} else if r.Method == "PUT" {
		fmt.Println("PUT")
	} else if r.Method == "DELETE" {
		fmt.Println("DELETE")
	}

}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("listening on port 8080")
	http.ListenAndServe(":8080", nil)
}
