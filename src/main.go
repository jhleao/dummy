package main

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"strings"
	"time"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "80"
	}

	appName := os.Getenv("APP_NAME")
	motd := os.Getenv("MOTD")

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		message := "Hello"
		if appName != "" {
			message += " from " + appName
		}
		message += "!"
		w.Write([]byte(message))
	})

	http.HandleFunc("/healthz", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	http.HandleFunc("/reach/", func(w http.ResponseWriter, r *http.Request) {
		postfix := r.URL.Path[len("/reach/"):]
		uppercasePostfix := strings.ToUpper(postfix)
		reachURL := os.Getenv("REACH_URL_" + uppercasePostfix)

		if reachURL == "" {
			fmt.Fprintf(w, "REACH_URL_%s is not set.", uppercasePostfix)
			return
		}

		resp, err := http.Get(reachURL)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}
		defer resp.Body.Close()

		for k, v := range resp.Header {
			w.Header()[k] = v
		}
		w.WriteHeader(resp.StatusCode)
		io.Copy(w, resp.Body)
	})

	go func() {
		for {
			currentTime := time.Now().UTC().Format(time.RFC3339)

			message := "Logging"
			if appName != "" {
				message += fmt.Sprintf(" from %s", appName)
			}
			message += fmt.Sprintf(". It's %s now. %s", currentTime, motd)

			log.Println(message)
			time.Sleep(10 * time.Second)
		}
	}()

	log.Printf("Starting server on port %s", port)
	log.Fatal(http.ListenAndServe(":"+port, nil))
}
