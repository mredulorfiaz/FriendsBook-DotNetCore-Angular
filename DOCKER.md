# 🐳 Docker Setup for FriendsBook

This document provides comprehensive instructions for running FriendsBook locally using Docker. The setup includes both production and development environments with hot reload capabilities.

## 📋 Prerequisites

- Docker (v20.10 or later)
- Docker Compose (v2.0 or later)
- Git

## 🏗️ Architecture

The Docker setup consists of three main services:

1. **friendsbook-db**: MySQL 8.0 database
2. **friendsbook-api**: .NET 8.0 Web API
3. **friendsbook-spa**: Angular 17 Single Page Application

## 🚀 Quick Start

### Production Build

Run the complete application stack:

```bash
# Clone the repository
git clone <repository-url>
cd FriendsBook-DotNetCore-Angular

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f
```

Access the application:
- **Frontend**: http://localhost:4200
- **API**: http://localhost:5000
- **Database**: localhost:3306

### Development Build (with Hot Reload)

For development with hot reload capabilities:

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up -d

# View logs
docker-compose -f docker-compose.dev.yml logs -f
```

## 📁 Directory Structure

```
FriendsBook-DotNetCore-Angular/
├── docker-compose.yml              # Production setup
├── docker-compose.dev.yml          # Development setup with hot reload
├── DOCKER.md                       # This documentation
├── FriendsBookAPI/
│   ├── Dockerfile                  # Production API container
│   ├── Dockerfile.dev              # Development API container
│   ├── .dockerignore               # Docker ignore file
│   ├── appsettings.Docker.json     # Docker-specific configuration
│   └── ...
└── FriendsBookSPA/
    ├── Dockerfile                  # Production SPA container
    ├── Dockerfile.dev              # Development SPA container
    ├── .dockerignore               # Docker ignore file
    ├── nginx.conf                  # Nginx configuration
    └── ...
```

## 🔧 Configuration

### Environment Variables

#### API Service
- `ASPNETCORE_ENVIRONMENT`: Set to `Development` or `Production`
- `ConnectionStrings__DefaultConnection`: MySQL connection string
- `ASPNETCORE_URLS`: API listening URLs

#### Database Service
- `MYSQL_ROOT_PASSWORD`: Root password (friendsbook123)
- `MYSQL_DATABASE`: Database name (friendsbook)
- `MYSQL_USER`: Application user (friendsbook)
- `MYSQL_PASSWORD`: User password (friendsbook123)

### Database Initialization

The MySQL database is automatically initialized with the schema from `FriendsBookAPI/mysql.sql` on first startup.

## 🛠️ Development Workflow

### Hot Reload Development

1. **Start development environment**:
   ```bash
   docker-compose -f docker-compose.dev.yml up -d
   ```

2. **Make code changes**:
   - API changes in `FriendsBookAPI/` trigger automatic rebuild
   - Angular changes in `FriendsBookSPA/` trigger hot reload

3. **View logs**:
   ```bash
   # All services
   docker-compose -f docker-compose.dev.yml logs -f
   
   # Specific service
   docker-compose -f docker-compose.dev.yml logs -f friendsbook-api
   ```

### Database Management

#### Access MySQL CLI
```bash
docker exec -it friendsbook-db mysql -u friendsbook -p
# Password: friendsbook123
```

#### Run Migrations (Development)
```bash
docker exec -it friendsbook-api-dev dotnet ef database update
```

#### Backup Database
```bash
docker exec friendsbook-db mysqldump -u friendsbook -pfriensbook123 friendsbook > backup.sql
```

## 🐛 Troubleshooting

### Common Issues

#### Port Already in Use
```bash
# Check what's using the port
netstat -tulpn | grep :4200
netstat -tulpn | grep :5000
netstat -tulpn | grep :3306

# Stop conflicting services or change ports in docker-compose.yml
```

#### Database Connection Issues
```bash
# Check database logs
docker-compose logs friendsbook-db

# Restart database service
docker-compose restart friendsbook-db
```

#### API Not Starting
```bash
# Check API logs
docker-compose logs friendsbook-api

# Common issues:
# - Database not ready (wait for MySQL to fully start)
# - Port conflicts
# - Configuration errors
```

#### Angular Build Failures
```bash
# Check SPA logs
docker-compose logs friendsbook-spa

# Clear node_modules and rebuild
docker-compose down
docker-compose build --no-cache friendsbook-spa
docker-compose up -d
```

### Reset Everything

If you encounter persistent issues:

```bash
# Stop all services
docker-compose down

# Remove volumes (⚠️ This deletes database data)
docker-compose down -v

# Remove images (forces rebuild)
docker-compose down --rmi all

# Start fresh
docker-compose up -d --build
```

## 📊 Monitoring

### Health Checks

The API service includes health checks:
```bash
# Check API health
curl http://localhost:5000/api/values

# Check service status
docker-compose ps
```

### Resource Usage
```bash
# View resource usage
docker stats

# View disk usage
docker system df
```

## 🔒 Security Notes

### Development Security
- Default passwords are used for development convenience
- Cloudinary credentials are exposed for development
- CORS is configured for localhost access

### Production Considerations
For production deployment:
1. Change all default passwords
2. Use environment variables for secrets
3. Configure proper CORS origins
4. Use HTTPS with SSL certificates
5. Implement proper logging and monitoring
6. Use production database with backups

## 📝 Useful Commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Rebuild specific service
docker-compose build [service-name]

# Execute commands in containers
docker exec -it friendsbook-api bash
docker exec -it friendsbook-spa sh

# Clean up
docker system prune -a
```

## 🆘 Getting Help

If you encounter issues:

1. Check the logs: `docker-compose logs -f`
2. Verify ports are available
3. Ensure Docker daemon is running
4. Try rebuilding: `docker-compose build --no-cache`
5. Reset everything: `docker-compose down -v && docker-compose up -d --build`

For additional support, please refer to the main project documentation or create an issue in the repository.