package main

import (
	"net/http"
	"os"
	"time"
)

func main() {
	logFile := "/var/log/svcmon.log"
	if os.PathSeparator == '\\' {
		logFile = "C:\\svcmon.log"
	}
	for {
		resp, err := http.Get("https://www.rodrigobrito.dev.br")
		f, _ := os.OpenFile(logFile, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
		if err != nil {
			f.WriteString(time.Now().Format(time.RFC3339) + " - erro: " + err.Error() + "\n")
		} else {
			f.WriteString(time.Now().Format(time.RFC3339) + " - status: " + resp.Status + "\n")
			resp.Body.Close()
		}
		f.Close()
		time.Sleep(300 * time.Second)
	}
}
