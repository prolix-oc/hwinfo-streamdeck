@echo off
CALL .\kill-streamdeck.bat
xcopy com.prolix.hwinfo.sdPlugin %APPDATA%\\Elgato\\StreamDeck\\Plugins\\com.prolix.hwinfo.sdPlugin\\ /E /Q /Y
CALL .\start-streamdeck.bat