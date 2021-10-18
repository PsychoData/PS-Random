function Set-WindowStyle {
#Example     (Get-Process -Name notepad).MainWindowHandle | foreach { Set-WindowStyle -Style SHOWMAXIMIZED -MainWindowHandle  $_ }
#Example     (Get-Process -Name notepad).MainWindowHandle | foreach { Set-WindowStyle -Style 6 -MainWindowHandle  $_ }

    param(
        [Parameter()]
        [WindowStyles]$Style = 'SHOW',
        [Parameter(ParameterSetName = 'MainWindowHandle')]
        $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle,
        [Parameter(ParameterSetName = 'ProcessName')]
        [string]$ProcessName,
        [Parameter(ParameterSetName = 'Process')]
        [System.Diagnostics.Process]$Process
    )
    begin {
    enum WindowStyles {
            FORCEMINIMIZE   = 11; HIDE            = 0
            MAXIMIZE        = 3;  MINIMIZE        = 6
            RESTORE         = 9;  SHOW            = 5
            SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
            SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
            SHOWNA          = 8;  SHOWNOACTIVATE  = 4
            SHOWNORMAL      = 1
        }
    
        $Win32ShowWindowAsync = Add-Type -MemberDefinition @"
        [DllImport("user32.dll")] 
        public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
"@ -name "Win32ShowWindowAsync" -namespace Win32Functions –passThru | Out-Null
        
    }
    process {
    
        if ($ProcessName) {$MainWindowHandle = $processName.MainWindowHandle}
    
        Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $Style)
    

        $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $Style) | Out-Null
    }
    }
    


    
