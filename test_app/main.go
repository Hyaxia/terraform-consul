package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"

	"github.com/gorilla/mux"
)

var serverNum = rand.Int()

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", func(rw http.ResponseWriter, r *http.Request) {
		response := map[string]string{
			"message": "Welcome to Dockerized app",
		}
		json.NewEncoder(rw).Encode(response)
		fmt.Println(serverNum)
	})

	router.HandleFunc("/{name}", func(rw http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		name := vars["name"]
		var message string
		if name == "" {
			message = "Hello World"
		} else {
			message = "Hello " + name
		}
		response := map[string]string{
			"message": message,
		}
		json.NewEncoder(rw).Encode(response)
	})

	log.Println("Server is running!")
	fmt.Println(http.ListenAndServe(":8080", router))
}
