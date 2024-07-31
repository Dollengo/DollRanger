@echo off
setlocal

:: Check if Python is installed
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python not found, installing Python...
    :: Download and install Python
    powershell -Command "Start-Process msiexec.exe -ArgumentList '/i, https://www.python.org/ftp/python/3.9.5/python-3.9.5-amd64.exe, /quiet, InstallAllUsers=1, PrependPath=1' -NoNewWindow -Wait"
)

:: Install the requests library
pip install requests

:: Check if MinGW is installed
where mingw32-gcc >nul 2>&1
if %errorlevel% neq 0 (
    echo MinGW not found, installing MinGW...
    :: Download and install MinGW
    powershell -Command "Start-Process msiexec.exe -ArgumentList '/i, https://sourceforge.net/projects/mingw-w64/files/latest/download, /quiet, InstallAllUsers=1' -NoNewWindow -Wait"
)

:: Install GLFW
echo Installing GLFW...
powershell -Command "Start-Process msiexec.exe -ArgumentList '/i, https://github.com/GladysHegglund/GLFW/releases/download/3.3.8/glfw-3.3.8.zip, /quiet' -NoNewWindow -Wait"

:: Install glm
echo Installing glm...
powershell -Command "Start-Process msiexec.exe -ArgumentList '/i, https://github.com/g-truc/glm/releases/download/0.9.9.8/glm-0.9.9.8.zip, /quiet' -NoNewWindow -Wait"

:: Install SFML
echo Installing SFML...
powershell -Command "Start-Process msiexec.exe -ArgumentList '/i, https://www.sfml-dev.org/files/SFML-2.5.1-windows-vc15-64-bit.zip, /quiet' -NoNewWindow -Wait"

:: Install Vulkan SDK
echo Installing Vulkan SDK...
powershell -Command "Start-Process msiexec.exe -ArgumentList '/i, https://sdk.lunarg.com/sdk/download/1.3.204.0/windows/vulkan-sdk-windows-x86_64-1.3.204.0.20230922.zip, /quiet' -NoNewWindow -Wait"

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
