@echo off

setlocal EnableDelayedExpansion
:: count to 5 storing the results in a variable
set _tst=0
FOR /l %%G in (1,1,5) Do (
echo [!_tst!] 
set /a _tst+=1
echo [!_tst!] 
set /a _tst+=1
echo [!_tst!] 
set /a _tst+=1
)
echo Total = %_tst%

pause
