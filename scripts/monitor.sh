#!/bin/bash

# Exit on error
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to check service health
check_service() {
    local service=$1
    local url=$2
    echo -n "Checking $service... "
    
    if curl -s "$url" > /dev/null; then
        echo -e "${GREEN}OK${NC}"
        return 0
    else
        echo -e "${RED}FAILED${NC}"
        return 1
    fi
}

# Function to check container status
check_container() {
    local container=$1
    echo -n "Checking container $container... "
    
    if docker ps | grep -q $container; then
        echo -e "${GREEN}RUNNING${NC}"
        return 0
    else
        echo -e "${RED}NOT RUNNING${NC}"
        return 1
    fi
}

# Function to check disk space
check_disk_space() {
    local threshold=90
    echo "Checking disk space..."
    
    local usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ $usage -gt $threshold ]; then
        echo -e "${RED}WARNING: Disk usage is at $usage%${NC}"
        return 1
    else
        echo -e "${GREEN}Disk usage: $usage%${NC}"
        return 0
    fi
}

# Function to check memory usage
check_memory() {
    echo "Checking memory usage..."
    free -h | awk 'NR==2 {printf "Memory Usage: %s/%s (%.2f%%)\n", $3, $2, $3/$2 * 100}'
}

# Function to check container logs for errors
check_logs() {
    local container=$1
    local hours=1
    echo "Checking logs for $container in last $hours hour(s)..."
    
    local errors=$(docker logs --since ${hours}h $container 2>&1 | grep -i "error" | wc -l)
    if [ $errors -gt 0 ]; then
        echo -e "${YELLOW}Found $errors error(s) in logs${NC}"
        return 1
    else
        echo -e "${GREEN}No errors found in logs${NC}"
        return 0
    fi
}

echo "🔍 Starting system health check..."

# Check services
check_service "Backend API" "http://localhost:8000/health"
check_service "Frontend" "http://localhost"

# Check containers
check_container "mysql-mcp_backend_1"
check_container "mysql-mcp_frontend_1"

# Check system resources
check_disk_space
check_memory

# Check logs
check_logs "mysql-mcp_backend_1"
check_logs "mysql-mcp_frontend_1"

# Show docker stats
echo -e "\n📊 Container Resource Usage:"
docker stats --no-stream

echo -e "\n✅ Monitoring check completed!" 