package main

import (
	"fmt"
	"log"
	"log/slog"
	"net/http"
)

func hello(w http.ResponseWriter, r *http.Request) {
	slog.Info("hello",
		slog.String("method", r.Method),
		slog.String("path", r.URL.Path))
	fmt.Fprintf(w, "hello %s", r.URL.Path)
}

func main() {
	http.Handle("/", http.HandlerFunc(hello))
	log.Fatal(http.ListenAndServe(":8080", nil))
}
