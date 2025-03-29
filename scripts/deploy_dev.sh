#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting development deployment..."

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
echo "🔄 Activating virtual environment..."
source venv/bin/activate

# Install Python dependencies
echo "📚 Installing Python dependencies..."
pip install -r requirements.txt

# Install frontend dependencies
echo "🎨 Installing frontend dependencies..."
cd frontend
npm install

# Start development servers
echo "🌟 Starting development servers..."
# Start backend server in background
cd ..
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000 &

# Start frontend development server
cd frontend
npm run dev

# Note: This script keeps running with the frontend server
# To stop both servers, press Ctrl+C 