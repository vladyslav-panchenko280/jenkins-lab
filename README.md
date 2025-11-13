# Jenkins Lab

A simple Node.js Express.js API server with comprehensive tests, Docker support, and Jenkins CI/CD pipeline integration.

## Description

RESTful API server built with Express.js that provides user management endpoints. Includes full test coverage using Jest and Supertest, Docker containerization, and a complete Jenkins CI/CD pipeline setup with helper scripts and documentation.

## Features

- RESTful API endpoints for user management
- Health check endpoint
- Comprehensive test suite
- Docker containerization
- Error handling and validation

## Prerequisites

- Node.js 18+ 
- npm or yarn
- Docker and Docker Compose

## Installation

```bash
npm install
```

## Usage

### Development

Start the server in development mode with auto-reload:

```bash
npm run dev
```

### Production

Start the server:

```bash
npm start
```

Server runs on `http://localhost:3000` by default (configurable via `PORT` environment variable).

## Testing

Run tests:

```bash
npm test
```

Run tests in watch mode:

```bash
npm run test:watch
```

## Docker

### Build Image

```bash
docker build -t jenkins-lab .
```

### Run Container

```bash
docker run -p 3000:3000 jenkins-lab
```

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/` | Welcome message |
| GET | `/health` | Health check |
| GET | `/api/users` | Get all users |
| GET | `/api/users/:id` | Get user by ID |
| POST | `/api/users` | Create new user |

### Examples

**Get all users:**
```bash
curl http://localhost:3000/api/users
```

**Get user by ID:**
```bash
curl http://localhost:3000/api/users/1
```

**Create user:**
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John Doe","email":"john@example.com"}'
```

**Health check:**
```bash
curl http://localhost:3000/health
```

## Jenkins CI/CD

This project includes a complete Jenkins setup with automated CI/CD pipeline.

### Quick Start

**Option 1: Using Docker Compose (Recommended)**
```bash
docker-compose up -d
```

**Option 2: Using Setup Script**
```bash
chmod +x scripts/*.sh
./scripts/jenkins-setup.sh
```

### Getting Initial Admin Password

After starting Jenkins, retrieve the initial admin password:

**Using Script:**
```bash
./scripts/jenkins-password.sh
```

**Manual Method:**
```bash
# If using docker-compose
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

# If using standalone container
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

**Access Jenkins:**
1. Open `http://localhost:8080` in your browser
2. Enter the initial admin password
3. Install suggested plugins
4. Create your admin user

### Jenkins CLI

The project includes a Jenkins CLI helper script for command-line operations.

#### Setup

The CLI script automatically downloads the Jenkins CLI jar on first use. Ensure Java is installed:
```bash
java -version
```

#### Basic Usage

```bash
# Show help
./scripts/jenkins-cli.sh help

# List all jobs
./scripts/jenkins-cli.sh list-jobs

# Get Jenkins version
./scripts/jenkins-cli.sh version

# Trigger a build
./scripts/jenkins-cli.sh build jenkins-lab

# Get job configuration
./scripts/jenkins-cli.sh get-job jenkins-lab

# View build console output
./scripts/jenkins-cli.sh console jenkins-lab 1
```

#### Environment Variables

```bash
export JENKINS_URL=http://localhost:8080
export JENKINS_USER=admin
export JENKINS_PASSWORD=your-password
```

#### Common CLI Commands

| Command | Description |
|---------|-------------|
| `list-jobs` | List all Jenkins jobs |
| `get-job <name>` | Get job configuration XML |
| `create-job <name> <xml>` | Create a new job from XML |
| `update-job <name> <xml>` | Update existing job |
| `delete-job <name>` | Delete a job |
| `build <name>` | Trigger a build |
| `console <name> <build>` | Get build console output |
| `get-build <name> <build>` | Get build information |
| `version` | Show Jenkins version |
| `who-am-i` | Show current user |

### Helper Scripts

The project includes several helper scripts in the `scripts/` directory:

#### `jenkins-setup.sh`
Sets up and starts Jenkins in a Docker container.

```bash
./scripts/jenkins-setup.sh
```

**Features:**
- Creates Jenkins home directory
- Starts Jenkins container with Docker socket access
- Displays initial admin password
- Provides next steps

**Environment Variables:**
- `JENKINS_HOME` - Jenkins home directory (default: `./jenkins_home`)
- `JENKINS_PORT` - Jenkins port (default: `8080`)

#### `jenkins-password.sh`
Retrieves the Jenkins initial admin password.

```bash
./scripts/jenkins-password.sh
```

#### `jenkins-cli.sh`
Jenkins CLI wrapper script for easy command-line operations.

```bash
./scripts/jenkins-cli.sh <command> [args...]
```

**Examples:**
```bash
# List jobs
./scripts/jenkins-cli.sh list-jobs

# Trigger build
./scripts/jenkins-cli.sh build jenkins-lab

# Get job config
./scripts/jenkins-cli.sh get-job jenkins-lab > job.xml
```

#### `jenkins-build.sh`
Quick script to trigger a Jenkins build.

```bash
./scripts/jenkins-build.sh [job-name]
```

**Example:**
```bash
./scripts/jenkins-build.sh jenkins-lab
```

#### `jenkins-status.sh`
Shows Jenkins status and information.

```bash
./scripts/jenkins-status.sh
```

**Displays:**
- Container status
- Jenkins URL accessibility
- Jenkins version
- List of jobs

### Jenkins Pipeline

The project includes a `Jenkinsfile` that defines a CI/CD pipeline with the following stages:

1. **Checkout** - Checks out source code from SCM
2. **Tests** - Runs npm install and test suite
3. **Build Docker** - Builds Docker image with build number tag
4. **Push** - Pushes image to Docker Hub registry

#### Pipeline Configuration

The pipeline uses:
- **Registry**: `docker.io/vladyslav280/jenkins-lab` (configurable)
- **Image Tag**: Build number (`${env.BUILD_NUMBER}`)
- **Credentials**: Docker Hub credentials stored in Jenkins (ID: `docker-hub`)

#### Setting Up Pipeline

1. **Create Pipeline Job:**
   ```bash
   # Using Jenkins CLI
   ./scripts/jenkins-cli.sh create-job jenkins-lab < Jenkinsfile
   ```

2. **Configure Docker Hub Credentials:**
   - Go to Jenkins → Manage Jenkins → Credentials
   - Add credentials with ID: `docker-hub`
   - Type: Username with password
   - Enter Docker Hub username and password

3. **Configure Pipeline:**
   - Create new Pipeline job
   - Select "Pipeline script from SCM"
   - Set SCM to Git
   - Enter repository URL
   - Set script path to `Jenkinsfile`

#### Running the Pipeline

**Via Web UI:**
- Navigate to job → Click "Build Now"

**Via CLI:**
```bash
./scripts/jenkins-build.sh jenkins-lab
```

**Via Script:**
```bash
./scripts/jenkins-cli.sh build jenkins-lab
```

### Jenkins Management

#### Start/Stop Jenkins

**Using Docker Compose:**
```bash
# Start
docker-compose up -d

# Stop
docker-compose stop

# Restart
docker-compose restart

# View logs
docker-compose logs -f jenkins
```

**Using Docker:**
```bash
# Start
docker start jenkins

# Stop
docker stop jenkins

# View logs
docker logs -f jenkins
```

#### Backup Jenkins

```bash
# Backup Jenkins home directory
docker exec jenkins tar czf /tmp/jenkins-backup.tar.gz /var/jenkins_home
docker cp jenkins:/tmp/jenkins-backup.tar.gz ./jenkins-backup.tar.gz
```

#### Restore Jenkins

```bash
# Restore from backup
docker cp jenkins-backup.tar.gz jenkins:/tmp/
docker exec jenkins tar xzf /tmp/jenkins-backup.tar.gz -C /
```

### Jenkins Configuration

#### Update Jenkins Plugins

1. Go to: Manage Jenkins → Manage Plugins → Updates
2. Select plugins to update
3. Click "Download now and install after restart"

#### Install Required Plugins

For this pipeline, ensure these plugins are installed:
- Pipeline
- Docker Pipeline
- Docker
- Git

Install via:
```bash
./scripts/jenkins-cli.sh install-plugin pipeline docker-workflow docker git
```

#### Configure Docker

Jenkins needs access to Docker socket for building images:

**Docker Compose** (already configured):
```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
```

**Manual Setup:**
```bash
docker run ... -v /var/run/docker.sock:/var/run/docker.sock ...
```

### Troubleshooting

#### Jenkins Not Starting

```bash
# Check container status
docker ps -a | grep jenkins

# Check logs
docker logs jenkins

# Check port availability
lsof -i :8080
```

#### Cannot Access Jenkins

```bash
# Verify container is running
docker ps | grep jenkins

# Check Jenkins status
./scripts/jenkins-status.sh

# Verify port mapping
docker port jenkins
```

#### CLI Authentication Issues

```bash
# Verify credentials
./scripts/jenkins-cli.sh who-am-i

# Set password explicitly
export JENKINS_PASSWORD=$(./scripts/jenkins-password.sh)
./scripts/jenkins-cli.sh version
```

#### Build Failures

```bash
# View build console
./scripts/jenkins-cli.sh console jenkins-lab <build-number>

# Check build status
./scripts/jenkins-cli.sh get-build jenkins-lab <build-number>
```

## Project Structure

```
jenkins-lab/
├── src/
│   ├── index.js          # Express server
│   └── index.test.js     # Test suite
├── scripts/
│   ├── jenkins-setup.sh      # Jenkins setup script
│   ├── jenkins-password.sh   # Get initial password
│   ├── jenkins-cli.sh        # Jenkins CLI wrapper
│   ├── jenkins-build.sh      # Trigger build script
│   └── jenkins-status.sh     # Status check script
├── Dockerfile            # Docker configuration
├── docker-compose.yml    # Jenkins Docker Compose setup
├── Jenkinsfile          # Jenkins CI/CD pipeline
├── jest.config.js       # Jest configuration
└── package.json         # Dependencies and scripts
```

