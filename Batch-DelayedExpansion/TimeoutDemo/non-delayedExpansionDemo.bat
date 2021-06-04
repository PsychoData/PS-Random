@echo off
::NOOOOOO EnableDelayedExpansion 
FOR /l %%G in (1,1,5) Do (call dateTime.cmd && Timeout /T 5 /noBreak)

pause
