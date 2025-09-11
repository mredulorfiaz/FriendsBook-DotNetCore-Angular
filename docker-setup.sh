#!/bin/bash

# FriendsBook Docker Setup Script
# This script provides easy commands to manage the FriendsBook Docker environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to check if docker-compose is available
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        print_error "docker-compose not found. Please install Docker Compose and try again."
        exit 1
    fi
}

# Function to show help
show_help() {
    echo -e "${BLUE}🐳 FriendsBook Docker Management Script${NC}"
    echo ""
    echo "Usage: ./docker-setup.sh [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start         Start production environment"
    echo "  dev           Start development environment with hot reload"
    echo "  stop          Stop all services"
    echo "  restart       Restart all services"
    echo "  logs          Show logs for all services"
    echo "  status        Show status of all services"
    echo "  clean         Stop services and clean up"
    echo "  reset         Reset everything (removes volumes)"
    echo "  build         Rebuild all images"
    echo "  help          Show this help message"
    echo ""
    echo "Examples:"
    echo "  ./docker-setup.sh start     # Start production environment"
    echo "  ./docker-setup.sh dev       # Start development environment"
    echo "  ./docker-setup.sh logs      # View logs"
    echo ""
}

# Function to start production environment
start_production() {
    print_info "Starting FriendsBook in production mode..."
    check_docker
    check_docker_compose
    
    docker-compose up -d
    
    print_success "FriendsBook started successfully!"
    print_info "Frontend: http://localhost:4200"
    print_info "API: http://localhost:5000"
    print_info "Database: localhost:3306"
    print_info "Use './docker-setup.sh logs' to view logs"
}

# Function to start development environment
start_development() {
    print_info "Starting FriendsBook in development mode with hot reload..."
    check_docker
    check_docker_compose
    
    docker-compose -f docker-compose.dev.yml up -d
    
    print_success "FriendsBook development environment started!"
    print_info "Frontend: http://localhost:4200 (with hot reload)"
    print_info "API: http://localhost:5000 (with hot reload)"
    print_info "Database: localhost:3306"
    print_info "Use './docker-setup.sh logs' to view logs"
}

# Function to stop services
stop_services() {
    print_info "Stopping FriendsBook services..."
    
    if [ -f docker-compose.dev.yml ]; then
        docker-compose -f docker-compose.dev.yml down
    fi
    
    docker-compose down
    
    print_success "All services stopped."
}

# Function to restart services
restart_services() {
    print_info "Restarting FriendsBook services..."
    stop_services
    start_production
}

# Function to show logs
show_logs() {
    print_info "Showing logs for all services..."
    
    if docker-compose ps | grep -q "friendsbook-.*-dev"; then
        docker-compose -f docker-compose.dev.yml logs -f
    else
        docker-compose logs -f
    fi
}

# Function to show status
show_status() {
    print_info "Service status:"
    
    if docker-compose ps | grep -q "friendsbook"; then
        docker-compose ps
    fi
    
    if [ -f docker-compose.dev.yml ] && docker-compose -f docker-compose.dev.yml ps | grep -q "friendsbook"; then
        echo ""
        print_info "Development services:"
        docker-compose -f docker-compose.dev.yml ps
    fi
}

# Function to clean up
clean_up() {
    print_warning "This will stop all services and remove containers..."
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Cleaning up..."
        
        if [ -f docker-compose.dev.yml ]; then
            docker-compose -f docker-compose.dev.yml down
        fi
        
        docker-compose down
        docker system prune -f
        
        print_success "Cleanup completed."
    else
        print_info "Cleanup cancelled."
    fi
}

# Function to reset everything
reset_everything() {
    print_warning "This will stop all services, remove containers, and DELETE ALL DATA!"
    read -p "Are you sure? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Resetting everything..."
        
        if [ -f docker-compose.dev.yml ]; then
            docker-compose -f docker-compose.dev.yml down -v
        fi
        
        docker-compose down -v
        docker system prune -a -f
        
        print_success "Reset completed. All data has been deleted."
    else
        print_info "Reset cancelled."
    fi
}

# Function to build images
build_images() {
    print_info "Building all Docker images..."
    check_docker
    check_docker_compose
    
    docker-compose build --no-cache
    
    if [ -f docker-compose.dev.yml ]; then
        docker-compose -f docker-compose.dev.yml build --no-cache
    fi
    
    print_success "All images built successfully."
}

# Main script logic
case "${1:-help}" in
    start)
        start_production
        ;;
    dev)
        start_development
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        show_logs
        ;;
    status)
        show_status
        ;;
    clean)
        clean_up
        ;;
    reset)
        reset_everything
        ;;
    build)
        build_images
        ;;
    help|*)
        show_help
        ;;
esac