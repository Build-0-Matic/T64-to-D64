@echo off
rem T64 to D64 Bulk Converter
rem Version 0.2
rem By: Build-0-Matic

rem I created this short script out of necessity.
rem I have too many T64 files that I want to convert to D64 format.
rem And since there seems to be no option that will easily do batch jobs,
rem I ended up writing this script.
rem It relies on C1541.exe that comes with the excellent
rem Vice 64 emulator (http://vice-emu.sourceforge.net/).
rem The script does the conversion in one easy step from the
rem badly engineered T64 file format to the now common D64 format.

rem So now the diskette images are fully compatible with both emulators
rem and the SD2IEC adapter for the original Commodore computers.

rem Enjoy!

rem -------------------------------------------------------
rem -----------------------IMPORTANT-----------------------
rem -------------------------------------------------------
rem set the path to the C1541 application on the next line.
set C1541_PATH="%~dp0\C1541"
rem -------------------------------------------------------

rem Check if the path and the executable exist
if exist %C1541_PATH% set PATH=%PATH%;%C1541_PATH%
if not exist %C1541_PATH%\C1541.exe goto Error

rem Get final extension of dropped files to see if it is a folder
echo File Extension: %~x1
if "%~x1" equ ".t64" goto F_Error
if "%~x1" equ ".T64" goto F_Error
rem Go to drag and drop folder
if "%~1" == "" goto Error
cd "%~1"

rem Get current dir name
for %%* in (.) do set CurrDirName=%%~n*

rem change codepage to allow nice graphics ;-)
chcp 65001
rem set title
title T64 to D64
rem switch to 120 columns
mode con:cols=120 lines=24
rem Change to Commodore 64 colors (or at least close to it)
color 9B
rem clear screen
cls

echo                ░▒▓▓███▓▓▒░                                                                                              
echo            ░▒▓████████████▒                                                                                             
echo         ▒█████████████████▓                                                                                             
echo       ▒███████████████████▓                                                                                             
echo     ░█████████████████████▓                                                                                             
echo    ▓█████████████▓▒▒▒▒▒▓▓█▓                                                                                             
echo   ▓███████████▒                         ░                                                                               
echo  ░██████████▒              █████████████▓    ███▓▓▓███▒  ░▓██▓       ▓█▒    ░              ▓▓▓███▓▒      ▓██▓▒      ░█▓ 
echo  ██████████               ░████████████░     ▓▓▒███▒▓▓░ ▓██▒▓██     ▓██▓   ░██▓░           ▓██▒▓▓███░  ░██▒▒██▒    ▒███ 
echo ▒█████████                ░██████████░          ▒█▓    ░██         ██▓█▒    █████▓▒        ▓█▓    ▒██  ██░        ▒█▓██ 
echo ██████████                 ▓▒▒▒▒▒▒▒             ▒██    ▒██▓███▒   ██ ▒█▒    ███▓█████▓▒    ▓█▓     ██  ██▓███▓   ▓█  ██ 
echo ██████████                 ▒▒░░░░▒▒             ▒██    ▒██   ██░ ██  ▓█▓    ██▓███████▓    ▓█▓     ██  ██▓  ▒█▓ ▓█▒ ░██ 
echo ▒█████████░               ░██▓▓▓▓▓██▓░          ▒██    ░██   ▓█░▒████████   ██████▓░       ▓█▓    ▓██  ██▒  ░██ ████████
echo  ██████████               ░██▓▓▓▓▓▓███▓░        ▓██     ▓██▓▓██      ▓█▓   ░██▓▒           █████████   ░██▓▓██░     ░██ 
echo   ██████████▒              █████████████▓       ░▓▒       ▓▓▓▒       ░▓░    ▒              ▒▒▒▓▓▓▒░      ▒▓▓▒        ▓▒ 
echo   ▒███████████▒                                                                                                         
echo    ▒█████████████▓▓▒▒▒▒▓██▓                         BULK CONVERTER
echo     ░█████████████████████▓                                                                                             
echo       ▒███████████████████▓                        By: Build-0-Matic
echo         ░▓████████████████▓                                                                                             
echo             ░▒▓▓▓█████████▒                                                                                             
echo                 ███████▓█▓                                                                                                                     
echo.
echo.
rem Count number of files in folder.
for %%A in (*.t64) do set /A NumFiles += 1
echo File count = %NumFiles%
echo.
echo Converting...
rem Parse every file in the folder and perform the magic.
for %%x in (*.t64) do (
call :progress
%C1541_PATH%\c1541.exe -verbose off -silent on -format "fromt64,01" d64 "%%~nx.d64" -tape "%%x"
)
echo Thank you for using the T64 to D64 script
pause
exit

:progress
rem sequentially increase the file counter by 1 at each iteration.
set /A Count += 1
rem calculate the process percentage. you have to multiply first by 100 because the set /a function doesn't support fractions.
set /A pct=100 * Count / NumFiles
rem set title to show the progress made.
title Progress: %pct%/100
exit /b

:F_Error
cls
echo FILE ERROR
echo.
echo This script only works on folders, not individual files.
pause
exit

:Error
cls
echo ---------------------- ERROR! ----------------------
echo.
echo Please drag and drop a folder on this batch file!
echo Please make sure C1541.exe is in the 
echo correct folder and that the path value in 
echo this file points to it.
echo Look near the top of the script, it is identified.
echo.
pause
exit
