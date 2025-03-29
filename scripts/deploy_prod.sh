#!/bin/bash

# Exit on error
set -e

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env file from .env.production template"
    exit 1
fi

echo "🚀 Starting production deployment..."

# Pull latest changes
echo "📥 Pulling latest changes from git..."
git pull origin main

# Build and deploy using docker-compose
echo "🏗️ Building Docker containers..."
docker-compose -f docker-compose.yml build

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose down

# Start new containers
echo "✨ Starting new containers..."
docker-compose up -d

# Wait for services to be healthy
echo "🔍 Checking service health..."
attempt=1
max_attempts=30
until curl -s http://localhost:8000/health > /dev/null; do
    if [ $attempt -eq $max_attempts ]; then
        echo "❌ Services failed to start properly"
        exit 1
    fi
    echo "⏳ Waiting for services to be ready... ($attempt/$max_attempts)"
    sleep 2
    attempt=$((attempt + 1))
done

echo "✅ Services are healthy!"
echo "🌐 Application is now running at:"
echo "   Frontend: http://localhost"
echo "   Backend API: http://localhost:8000"

# Show logs
echo "📋 Showing container logs (Ctrl+C to exit)..."
docker-compose logs -f 