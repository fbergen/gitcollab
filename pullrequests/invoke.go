package main

import (
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
)

func main() {
	http.HandleFunc("/repo/", scriptHandler)

	// Determine port for HTTP service.
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
		log.Printf("Defaulting to port %s", port)
	}

	// Start HTTP server.
	log.Printf("Listening on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}

func scriptHandler(w http.ResponseWriter, r *http.Request) {
	path := strings.Split(r.URL.Path, "/")
	user := path[2]
	repo := path[3]
	log.Printf("PATH %s", path)
	log.Printf("USER %s", user)
	log.Printf("REPO %s", repo)

	// w.Header().Set("Content-Type", "text/html; charset=utf-8")
	cmd := exec.CommandContext(r.Context(), "/bin/sh", "script.sh", user, repo)
	cmd.Stderr = os.Stderr
	out, err := cmd.Output()
	if err != nil {
		w.WriteHeader(500)
	}
	w.Write(out)
}
