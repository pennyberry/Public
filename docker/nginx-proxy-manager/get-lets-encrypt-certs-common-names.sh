#!/bin/bash

# Define the base directory
BASE_DIR="/home/joe/Public/docker/nginx-proxy-manager/volumes/letsencrypt/live"

# Iterate over each subdirectory in the base directory
for dir in "$BASE_DIR"/*; do
    if [ -d "$dir" ]; then
        # Path to the cert.pem file
        cert_file="$dir/cert.pem"
        
        # Check if cert.pem exists
        if [ -f "$cert_file" ]; then
            # Extract the Common Name (CN) and Subject Alternative Names (SANs) from cert.pem
            echo "Processing $dir"
            echo "Certificate for: $(openssl x509 -in "$cert_file" -noout -subject)"
        else
            echo "No cert.pem found in $dir"
        fi
    fi
done
