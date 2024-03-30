#!/bin/bash

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