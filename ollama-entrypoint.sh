#!/bin/bash
# Start Ollama server in the background, pull the configured model, then wait.
# Used by the ollama service in docker-compose.yml (uncomment that service to activate).

# Start the Ollama server
ollama serve &
SERVER_PID=$!

# Wait for the server to be ready
echo "Waiting for Ollama server to start..."
for i in $(seq 1 30); do
  if curl -sf http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo "Ollama server is ready."
    break
  fi
  sleep 1
done

# Pull the model (skips download if already cached)
MODEL="${OLLAMA_MODEL:-llama3.2:3b}"
echo "Ensuring model '$MODEL' is available..."
ollama pull "$MODEL"
echo "Model '$MODEL' is ready."

# Keep the server running in the foreground
wait $SERVER_PID
