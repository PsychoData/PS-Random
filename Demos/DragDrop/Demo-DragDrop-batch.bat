::Echo off
pushd %1

for /r %%i in (*.txt) do (
	echo notepad "%%i" 
	notepad "%%i" 
)
popd
