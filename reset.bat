@echo off

REM This script will stop and remove all Docker containers related to your LAMP stack
REM Run as administrator if needed

REM Make sure the reset script is executable
wsl chmod +x "/mnt/c/[ DEV ]/[ LAMP ]/reset_lemp.sh"

REM Run the reset script in WSL
wsl bash "/mnt/c/[ DEV ]/[ LAMP ]/reset_lemp.sh"
