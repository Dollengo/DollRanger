#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit
fi

# Detect Linux distribution and install necessary packages
if [ -f /etc/debian_version ]; then
    # Debian-based system (Ubuntu, etc.)
    apt update
    apt install -y python3 python3-pip cmake g++ git gcc libglm-dev libsfml-dev libvulkan-dev
elif [ -f /etc/redhat-release ]; then
    # Red Hat-based system (Fedora, CentOS, etc.)
    yum install -y python3 python3-pip cmake gcc-c++ git glm-devel sfml-devel vulkan-devel
elif [ -f /etc/arch-release ]; then
    # Arch-based system
    pacman -Syu --noconfirm python python-pip cmake g++ git gcc glm sfml vulkan-headers vulkan-tools vulkan-validation-layers
else
    echo "Unsupported system"
    exit 1
fi

# Install the requests library
pip3 install requests

# Create the Python script
cat <<EOF > update_script.py
import os
import requests
import shutil
import zipfile
import tarfile

GITHUB_API_URL = "https://api.github.com/repos/Dollengo/DollRanger/releases/latest"
DOWNLOAD_DIR = os.path.dirname(os.path.realpath(__file__))
PROJECTS_DIR = os.path.join(DOWNLOAD_DIR, "Projects")

def get_latest_release():
    response = requests.get(GITHUB_API_URL)
    response.raise_for_status()
    return response.json()

def download_file(url, output_path):
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(output_path, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192):
                f.write(chunk)

def extract_zip(file_path, extract_to):
    with zipfile.ZipFile(file_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)

def extract_tar(file_path, extract_to):
    with tarfile.open(file_path, 'r:gz') as tar_ref:
        tar_ref.extractall(extract_to)

def clean_project_directory(exclude_files):
    for item in os.listdir(DOWNLOAD_DIR):
        item_path = os.path.join(DOWNLOAD_DIR, item)
        if item not in exclude_files and item_path != PROJECTS_DIR:
            if os.path.isfile(item_path):
                os.remove(item_path)
            elif os.path.isdir(item_path):
                shutil.rmtree(item_path)

def main():
    latest_release = get_latest_release()
    latest_version = latest_release["tag_name"]
    download_url_zip = latest_release["assets"][0]["browser_download_url"]
    download_url_tar = latest_release["assets"][1]["browser_download_url"]
    
    print(f"Latest release version: {latest_version}")
    
    user_input = input("Do you want to download the latest release? (yes/no): ").strip().lower()
    if user_input != "yes":
        print("No updates will be downloaded.")
        return
    
    clean_project_directory(["update_script.py", "Projects", "setup.sh", "setup.bat"])
    
    file_type = input("Do you want to download the .zip or .tar.gz file? (zip/tar.gz): ").strip().lower()
    if file_type == "zip":
        download_file(download_url_zip, "latest_release.zip")
        extract_zip("latest_release.zip", "latest_release")
        os.remove("latest_release.zip")
        for item in os.listdir("latest_release"):
            shutil.move(os.path.join("latest_release", item), DOWNLOAD_DIR)
        os.rmdir("latest_release")
    elif file_type == "tar.gz":
        download_file(download_url_tar, "latest_release.tar.gz")
        extract_tar("latest_release.tar.gz", "latest_release")
        os.remove("latest_release.tar.gz")
        for item in os.listdir("latest_release"):
            shutil.move(os.path.join("latest_release", item), DOWNLOAD_DIR)
        os.rmdir("latest_release")
    else:
        print("Invalid file type specified.")
        return
    
    print("Update completed successfully.")

if __name__ == "__main__":
    main()
EOF

# Execute the Python script
python3 update_script.py

