#!/bin/bash

# Development script for emote-generator
# This script starts both the backend API and frontend with live reload

echo "🚀 Starting emote-generator development environment..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Build and start the services
echo "📦 Building and starting services..."
docker compose up --build

echo "✅ Development environment started!"
echo "🌐 Frontend: http://localhost:5173"
echo "🔧 Backend API: http://localhost:4000"
echo ""
echo "Press Ctrl+C to stop the services"
