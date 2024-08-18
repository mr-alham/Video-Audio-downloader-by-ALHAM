#!/bin/bash

echo -e "\nDownloading and Installing the app."

echo -e "\nDownloading the executable file.\n"

# Download the executable file
curl -o download https://raw.githubusercontent.com/mr-alham/Video-Audio-downloader-by-ALHAM/main/download.sh

# Move the executable to '/usr/local/bin'
echo -e "\nsudo mv download /usr/local/bin"
sudo mv download /usr/local/bin

# Add executable permissions
echo -e "\nchmod +x /usr/local/bin/download"
chmod +x /usr/local/bin/download

# Download utilities
# curl -o download https://raw.githubusercontent.com/mr-alham/Video-Audio-downloader-by-ALHAM/main/download

# Move the data file to '/usr/local/etc,
# sudo mv download /usr/local/etc

# Install dependencies
download --install
