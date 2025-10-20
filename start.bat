@echo off

REM Make sure the bash script is executable every time, just in case
wsl chmod +x "/mnt/c/[ DEV ]/[ LEMP ]/start_lemp.sh"

REM Now launch the script
wsl bash "/mnt/c/[ DEV ]/[ LEMP ]/start_lemp.sh"

wsl