# DSPA802Project
#Project Requirements - MATLAB R2023a Update 5 (9.14.0.2237262) or higher ...
There are two files of interest. 

scrambled.m - Voice scrambling application. 

Note: Requires audio files to be pre-recorded and saved as a .wav file. You can use the LastMain3.m file to record audio clips. 
How to use. 
Run m file in MATLAB. 
THe command window will display a list of audio files in the directory the m file is located. 
Use the number in from of the name to choose a file. e.g. Enter 10 in the command window 
The original clip will first be play
Press any key to listen to the first scrambled audio clip 
Press any key to listen to the second scrambled audio clip 
The application will terminate after the last keystroke 

LastMain3.m 

Voice identifitication 

How to use. 
Run m file in MATLAB
THe command window will promt fot 4 actions, respond only withe corresponding letter. 
i.e. E - Exit, O - Open, V - Validate, R - Record 
Cycle will keep looping until E is sent to the system. 

OPEN FUNCTION 
- Used for training audio clips to a user ID in the database file.
- A list of clips will be listed in the command window. Select using the number associated with the clip. e.g. 10
- The clip will then be analysed and the USER ID can then be assigned. F0 will also be displayed on the command window and graphically.
- You will then be re-directed to the main loop for a choice.

Validate
-Used for validating audio clips. 
- A list of clips will be listed in the command window. Select using the number associated with the clip. e.g. 10
- The clip will then be analysed and a Validation success or failed will be printed.
- You will then be re-directed to the main loop for a choice.

Record 
- Used for recording clips
- Promt for recording time - user decision
- The recording will take place
- If your not satisfied with the clip, you may discard and restart the recording process.
- If your satisfied, you will need to enter a file name to store the file.

Exit
- Terminate the application 
  
