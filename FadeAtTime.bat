@echo off
REM Script to fade a video to black and silence at a specified point

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
set "output_file=%~dp1%~n1-faded%~x1"

REM Display input video file path to the user
echo Input video file:
echo %input_file%
echo.

REM Prompt for fade starting point
set /p fade_start_minutes=Enter the minutes for the fade starting point (e.g., 3): 
set /p fade_start_seconds=Enter the seconds for the fade starting point (e.g., 25): 

REM Prompt for fade duration
set /p fade_duration=Enter the fade duration in seconds (e.g., 2): 

REM Validate inputs
if not defined fade_start_minutes goto invalid_input
if not defined fade_start_seconds goto invalid_input
if not defined fade_duration goto invalid_input

REM Calculate total fade start time in seconds
set /a fade_start_time=(%fade_start_minutes% * 60) + %fade_start_seconds%

REM Calculate total end time
set /a fade_end_time=%fade_start_time% + %fade_duration%

REM Display calculated values
echo.
echo Fade will start at: %fade_start_time% seconds
echo Fade duration: %fade_duration% seconds
echo Video will end at: %fade_end_time% seconds
echo.

REM Run FFmpeg command
"%ffmpeg_path%" -i "%input_file%" ^
    -vf "fade=t=out:st=%fade_start_time%:d=%fade_duration%" ^
    -af "afade=t=out:st=%fade_start_time%:d=%fade_duration%" ^
    -t %fade_end_time% ^
    -c:v libx264 -preset fast -crf 23 ^
    -c:a aac -b:a 192k ^
    -movflags +faststart "%output_file%"

REM Check if encoding succeeded
if %errorlevel%==0 (
    echo Success!!
    echo ----------------------------------------
    echo Input video file: "%input_file%"
    echo Fade starts at: %fade_start_time% seconds
    echo Fade duration: %fade_duration% seconds
    echo Fade ends at: %fade_end_time% seconds
    echo Output video saved as: "%output_file%"
    echo ----------------------------------------
    echo Press Enter to exit.
    pause
) else (
    echo Error occurred during processing.
    pause
    exit /b
)

:invalid_input
echo Invalid input. Please provide valid numeric values for all inputs.
pause
exit /b
