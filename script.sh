#!/bin/bash

# # Function to check if a command exists
# command_exists() {
#     command -v "$@" > /dev/null 2>&1
# }

# # Check for Docker
# if ! command_exists docker; then
#     echo "Docker is not installed. Attempting to install Docker..."
#     # Installation command for Docker will vary based on the OS
#     # For Ubuntu/Debian, uncomment the following line:
#     # sudo apt-get install docker-ce docker-ce-cli containerd.io -y
#     # For other OS, modify accordingly or provide instructions
# fi

# # Check for OpenSSL
# if ! command_exists openssl; then
#     echo "OpenSSL is not installed. Attempting to install OpenSSL..."
#     # Installation command for OpenSSL
#     # For Ubuntu/Debian, uncomment the following line:
#     # sudo apt-get install openssl -y
#     # For other OS, modify accordingly or provide instructions
# fi

# Generate SSL certificates if they do not exist
if [ ! -f "tomcat-key.pem" ] || [ ! -f "tomcat-cert.pem" ]; then
    echo "Generating SSL certificates..."
    openssl req -newkey rsa:4096 -nodes -keyout tomcat-key.pem -x509 -days 365 -out tomcat-cert.pem -sha256 -subj "/C=PT/ST=NORTH/L=PORTO/O=MyCOMP/CN=localhost"
else
    echo "SSL certificates already exist. Skipping generation..."
fi

# Build Docker image
echo "Building Docker image..."
docker build -t my-tomcat:latest .

# Run Docker container
echo "Running Docker container..."
docker run -p 4041:4041 my-tomcat:latest