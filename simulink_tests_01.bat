@echo off
REM This batch file is a short example of how to call
REM MATLAB from the command line.

REM Options:
REM -nosplash Don't display the MATLAB Splash screen
REM -wait     Don't return to the script until MATLAB is closed.
REM -c        explicitly specify the license file.
REM -logfile  Log all script output to the logfile.
REM -r        Run the specified matlab commands.

"C:\Program Files\MATLAB\R2015b\bin\matlab.exe" -nosplash -wait -logfile "%~n0.log" -sd "%WORKSPACE%" -r "cd('%~dp0');run('%~n0')"
