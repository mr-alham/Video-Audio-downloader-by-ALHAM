#!/bin/bash

# Download the executable file
curl -o download https://raw.githubusercontent.com/mr-alham/Video-Audio-downloader-by-ALHAM/main/download.sh

# Move the executable to '/usr/local/bin'
sudo mv download /usr/local/bin/

# Download utilities
# curl -o download https://raw.githubusercontent.com/mr-alham/Video-Audio-downloader-by-ALHAM/main/download

# Move the data file to '/usr/local/etc,
# sudo mv download /usr/local/etc

# Install dependencies
download --install
