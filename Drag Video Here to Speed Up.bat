@echo off
REM Batch file to speed up videos and correctly calculate new duration

set "ffmpeg_path=%~dp0ffmpeg.exe"
if not exist "%ffmpeg_path%" (
    echo ffmpeg.exe not found in the same folder as this batch file. Please ensure ffmpeg.exe is present.
    pause
    exit /b
)

REM Check if a file was dragged onto the batch file
if "%~1"=="" (
    echo No file provided. Please drag a video file onto this batch file.
    pause
    exit /b
)

REM File path and extension
set "input_file=%~1"
set "input_ext=%~x1"

REM Display input video file path to the user
echo Input video file:
echo %input_file%
echo.

REM Prompt for speed factor
echo This script will accept an input video and a speed factor (1.1x-4.0x), and will create a new accelerated video in the same folder as the original.
:input_speed
set /p speed_factor=Enter a speed factor between 1.1 and 4.0 (e.g., 1.5): 

REM Validate input (numeric and within range)
for /f "tokens=1,2 delims=." %%a in ("%speed_factor%") do (
    set "int_part=%%a"
    set "dec_part=%%b"
)

REM Handle integer speed factors by setting dec_part to 0 if not defined
if not defined dec_part set "dec_part=0"


if not defined int_part goto invalid_input
if %int_part% lss 1 goto invalid_input
if %int_part% gtr 4 goto invalid_input
if %int_part% equ 4 if defined dec_part if %dec_part% neq 0 goto invalid_input
if %int_part% equ 1 if defined dec_part if %dec_part% lss 1 goto invalid_input



REM Round speed factor to 2 decimal places
set "speed_factor=%int_part%.%dec_part:~0,2%"

REM Extract duration from FFmpeg output using a temporary file
"%ffmpeg_path%" -i "%input_file%" 2> temp_ffmpeg_output.txt
for /f "tokens=2-4 delims=:." %%a in ('findstr "Duration" temp_ffmpeg_output.txt') do (
    set /a "orig_hours=%%a"
    set /a "orig_minutes=%%b"
    set /a "orig_seconds=%%c"
)
del temp_ffmpeg_output.txt

REM Calculate the original duration in seconds (integer math)
set /a orig_hours=%orig_hours% * 3600
set /a orig_minutes=%orig_minutes% * 60
set /a orig_duration=%orig_hours% + %orig_minutes% + %orig_seconds%

REM Approximate new duration using floating-point math
echo Old video duration: %orig_duration% seconds
for /f %%a in ('powershell -command "[math]::Round(%orig_duration% / %speed_factor%)"') do set new_duration=%%a
echo New video duration: %new_duration% seconds
echo 

REM Validate the new duration
if "%new_duration%"=="" (
    echo Failed to calculate the new duration. Exiting.
    pause
    exit /b
)

REM Output file suffix and extension
set "speed_suffix=-%speed_factor%x"
set "output_file=%~dp1%~n1%speed_suffix%%input_ext%"

REM Check if the output file already exists
if exist "%output_file%" (
    echo Output file already exists: "%output_file%"
    echo Skipping encoding to avoid overwriting the file.
    echo Press Enter to exit.
    pause
    exit /b
)

REM Encode the video with the adjusted duration
"%ffmpeg_path%" -i "%input_file%" -filter_complex "[0:v]setpts=PTS/%speed_factor%[v];[0:a]atempo=%speed_factor%[a]" -map "[v]" -map "[a]" -t %new_duration% -c:v libx264 -preset fast -crf 23 -c:a aac -b:a 192k -movflags +faststart "%output_file%"

REM Check if encoding succeeded
if %errorlevel%==0 (
    cls
    echo Success!!
    echo ----------------------------------------
    echo Input video file: "%input_file%".
    echo Old video duration: %orig_duration% seconds
    echo Speed factor: %speed_factor%
    echo ----------------------------------------
    echo New output duration: %new_duration% seconds
    echo Video successfully sped up and saved as: "%output_file%"
    echo ----------------------------------------
    echo Press Enter to exit.
    pause
)