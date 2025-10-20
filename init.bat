@echo off
REM -------------------------------------
REM MAKE SURE TO RUN THIS AS ADMINISTRATOR!
REM -------------------------------------

REM Set your target and link locations
SET NEW_WWW=C:\[ DEV ]\[ LEMP ]\www

SET LINK_WWW=I:\[ WWWROOT ]

REM --- Create symlinks (junctions) ---
echo Creating symlink for wwwroot...
mklink /J "%NEW_WWW%" "%LINK_WWW%"

REM --- Generate SSL certificates ---
echo Generating SSL certificates...
wsl bash ssl/generate-cert.sh

echo.
echo Done!
pause
