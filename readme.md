# SpeedVid

SpeedVid is a simple "drop" script for Windows computers to solve the specific problem of slow worship videos. 

For unencrypted videos in common formats supported by the conversion tool FFMpeg, drop the video icon onto the "Drag Video Here to Speed Up.bat file", choose a speed factor between 1.1x and 4.0x, and the script will output a new accelerated version of the video in the same folder as the source video.

The larger one is called "ffmpeg.exe", and this is the "engine" that does the video conversion.
One is called  "Drag Video Here to Speed Up.bat" and it is my script to do the work. Both files must be in the same folder to work, but the video can be anywhere on the computer or a flash drive.

1. Extract the `.bat` and `.exe` files from this repository.
2. Open up a new folder window (`Ctrl+n`) and find the video you want to convert.
3. Select the video file and drag it on top of `Drag Video Here to Speed Up.bat`.
![Selecting a file](/img/select.png)
![Dragging and dropping the video on the script.](/img/drop.png)
4. Let go of the file, and a new window will pop up asking how much you want to speed it up. Type any speed factor between `1.1` and `4.0` and press Enter. `2.0` is a good starting point for a very slow song and you can adjust up or down if needed.
![Choosing a speed factor.](/img/Input.png)
5. You may get a security prompt here, as the script has to call Powershell to do some math that normal `.bat` files can't handle. You can examine the code if you are concerned, but you will need to allow the script to continue. 
6. Lots of text will fly by as the video is converted, and hopefully you will get this message. You notice that the output file ends in `-2.0x` in my case which was the speed multiplier I chose.
![Success](/img/output.png)
7. Play the new video it created to see how it feels. 
8. If you want more or less speed, start again and drag the original video onto the script and choose a different speed multiplier. Delete any versions you don't need. 
## Notes:
1. Make sure you always keep and drag the original file, don't reprocess the output file (the one with `-2.0x`) again or it will lose quality.  
2. If something goes wrong, the script should explain what is wrong.

# FadeAtTime 

FadeAtTime is a simple "drop" script for Windows computers to solve the specific problem of long worship videos.

0. Preview the video and note the time in minutes and seconds where you want to fade to black.
1. Extract the `.bat` and `.exe` files from this repository.
2. Open up a new folder window (`Ctrl+n`) and find the video you want to convert.
3. Select the video file and drag it on top of `FadeAtTime.bat`.
![Selecting a file](/img/select.png)
4. Let go of the file, and a new window will pop up asking about the cut. In this example, we'll cut at 3m 28s, and make the fade 2 seconds long. This means that the video will end at 3:30.
  - Enter the minutes first (ex. `3`)
  - Enter the seconds on the next question (ex. `28`).
  - Then choose how many seconds you want the fade to last. (ex. `2`).
5. Lots of text will fly by as the video is converted, and hopefully you will see a success message. You'll notice that the output filename ends in `-faded`.
6. Play the new video it created to verify the fade. 

## Notes
1. Make sure you always keep and drag the original file, as the new copy will not include the end of the video.  
2. If something goes wrong, the script should explain what is wrong.