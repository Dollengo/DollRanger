@echo off
setlocal

:: Function to install a package using Chocolatey or winget
:install_package
set "PACKAGE_NAME=%1"
choco install %PACKAGE_NAME% -y
if %errorlevel% neq 0 (
    winget install -e --id %PACKAGE_NAME%
)
goto :eof

:: Check if Chocolatey is installed
choco -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Chocolatey not found, installing Chocolatey...
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
)

:: Check if winget is installed
winget -v >nul 2>&1
if %errorlevel% neq 0 (
    echo winget not found. Please install winget manually.
    exit /b 1
)

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found, installing Python...
    call :install_package python3
)

:: Install the requests library
pip install requests

:: Check if MinGW is installed
where mingw32-gcc >nul 2>&1
if %errorlevel% neq 0 (
    echo MinGW not found, installing MinGW...
    call :install_package mingw
)

:: Install GLFW
echo Installing GLFW...
call :install_package glfw

:: Install glm
echo Installing glm...
call :install_package glm

:: Install SFML
echo Installing SFML...
call :install_package sfml

:: Install Vulkan SDK
echo Installing Vulkan SDK...
call :install_package "LunarG.VulkanSDK"

:: Create the Python script
echo import os > update_script.py
echo import requests >> update_script.py
echo import shutil >> update_script.py
echo import zipfile >> update_script.py
echo import tarfile >> update_script.py
echo. >> update_script.py
echo GITHUB_API_URL = "https://api.github.com/repos/Dollengo/DollRanger/releases/latest" >> update_script.py
echo DOWNLOAD_DIR = os.path.dirname(os.path.realpath(__file__)) >> update_script.py
echo PROJECTS_DIR = os.path.join(DOWNLOAD_DIR, "Projects") >> update_script.py
echo. >> update_script.py
echo def get_latest_release(): >> update_script.py
echo.    response = requests.get(GITHUB_API_URL) >> update_script.py
echo.    response.raise_for_status() >> update_script.py
echo.    return response.json() >> update_script.py
echo. >> update_script.py
echo def download_file(url, output_path): >> update_script.py
echo.    with requests.get(url, stream=True) as r: >> update_script.py
echo.        r.raise_for_status() >> update_script.py
echo.        with open(output_path, 'wb') as f: >> update_script.py
echo.            for chunk in r.iter_content(chunk_size=8192): >> update_script.py
echo.                f.write(chunk) >> update_script.py
echo. >> update_script.py
echo def extract_zip(file_path, extract_to): >> update_script.py
echo.    with zipfile.ZipFile(file_path, 'r') as zip_ref: >> update_script.py
echo.        zip_ref.extractall(extract_to) >> update_script.py
echo. >> update_script.py
echo def extract_tar(file_path, extract_to): >> update_script.py
echo.    with tarfile.open(file_path, 'r:gz') as tar_ref: >> update_script.py
echo.        tar_ref.extractall(extract_to) >> update_script.py
echo. >> update_script.py
echo def clean_project_directory(exclude_files): >> update_script.py
echo.    for item in os.listdir(DOWNLOAD_DIR): >> update_script.py
echo.        item_path = os.path.join(DOWNLOAD_DIR, item) >> update_script.py
echo.        if item not in exclude_files and item_path != PROJECTS_DIR: >> update_script.py
echo.            if os.path.isfile(item_path): >> update_script.py
echo.                os.remove(item_path) >> update_script.py
echo.            elif os.path.isdir(item_path): >> update_script.py
echo.                shutil.rmtree(item_path) >> update_script.py
echo. >> update_script.py
echo def main(): >> update_script.py
echo.    latest_release = get_latest_release() >> update_script.py
echo.    latest_version = latest_release["tag_name"] >> update_script.py
echo.    download_url_zip = latest_release["assets"][0]["browser_download_url"] >> update_script.py
echo.    download_url_tar = latest_release["assets"][1]["browser_download_url"] >> update_script.py
echo.    >> update_script.py
echo.    print(f"Latest release version: {latest_version}") >> update_script.py
echo.    >> update_script.py
echo.    user_input = input("Do you want to download the latest release? (yes/no): ").strip().lower() >> update_script.py
echo.    if user_input != "yes": >> update_script.py
echo.        print("No updates will be downloaded.") >> update_script.py
echo.        return >> update_script.py
echo.    >> update_script.py
echo.    clean_project_directory(["update_script.py", "Projects", "setup.sh", "setup.bat"]) >> update_script.py
echo.    >> update_script.py
echo.    file_type = input("Do you want to download the .zip or .tar.gz file? (zip/tar.gz): ").strip().lower() >> update_script.py
echo.    if file_type == "zip": >> update_script.py
echo.        download_file(download_url_zip, "latest_release.zip") >> update_script.py
echo.        extract_zip("latest_release.zip", "latest_release") >> update_script.py
echo.        os.remove("latest_release.zip") >> update_script.py
echo.        for item in os.listdir("latest_release"): >> update_script.py
echo.            shutil.move(os.path.join("latest_release", item), DOWNLOAD_DIR) >> update_script.py
echo.        os.rmdir("latest_release") >> update_script.py
echo.    elif file_type == "tar.gz": >> update_script.py
echo.        download_file(download_url_tar, "latest_release.tar.gz") >> update_script.py
echo.        extract_tar("latest_release.tar.gz", "latest_release") >> update_script.py
echo.        os.remove("latest_release.tar.gz") >> update_script.py
echo.        for item in os.listdir("latest_release"): >> update_script.py
echo.            shutil.move(os.path.join("latest_release", item), DOWNLOAD_DIR) >> update_script.py
echo.        os.rmdir("latest_release") >> update_script.py
echo.    else: >> update_script.py
echo.        print("Invalid file type specified.") >> update_script.py
echo.        return >> update_script.py
echo.    >> update_script.py
echo.    print("Update completed successfully.") >> update_script.py
echo. >> update_script.py
echo if __name__ == "__main__": >> update_script.py
echo.    main() >> update_script.py

:: Run the Python script
python update_script.py

endlocal

