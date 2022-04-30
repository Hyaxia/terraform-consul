package main

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"math/rand"
	"net/http"
	"strconv"

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

	router.HandleFunc("/friend/{port}", func(rw http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		port := vars["port"]

		fmt.Println(fmt.Sprintf("server: %s, trying to access a friend at port %s", strconv.Itoa(serverNum), port))

		resp, err := http.Get(fmt.Sprintf("http://localhost:%s/hi-friend", port))
		if err != nil {
			fmt.Println(err)
			return
		}
		defer resp.Body.Close()
		if resp.StatusCode != http.StatusOK {
			fmt.Println(
				fmt.Sprintf(
					"received %s from the friend using port %s", strconv.Itoa(http.StatusOK),
					port,
				),
			)
			return
		}

		bodyBytes, err := io.ReadAll(resp.Body)
		if err != nil {
			log.Fatal(err)
		}
		bodyString := string(bodyBytes)

		response := map[string]string{
			"message": fmt.Sprintf("reached a friend at port %s, received %s", port, bodyString),
		}
		json.NewEncoder(rw).Encode(response)
		fmt.Println(fmt.Sprintf("success accessing friend at port %s", port))
	})

	router.HandleFunc("/{name}", func(rw http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		name := vars["name"]

		fmt.Println(fmt.Sprintf("server: %s, received request with name %s", strconv.Itoa(serverNum), name))

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
