$profiles     = Get-Item "$ENV:LOCALAPPDATA\Microsoft\Edge\User Data\*\Edge Profile.ico" | select -ExpandProperty Directory
$EdgeExePath  = Get-Item "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
$ShortcutsDir = Get-Item 'C:\EdgeProfs'

Get-ChildItem -Path $ShortcutsDir -Filter "*.lnk" | Remove-Item 

$WorkAccounts  = 0
$PersonalAccts = 0
$ProfileProperties = $profiles | Foreach {
    $CurrJsonProfile = Join-Path -path $_ -ChildPath Preferences | Get-item | Get-Content | ConvertFrom-Json

    [pscustomObject]@{
    ProfileName = $CurrJsonProfile.Profile.name
    ProfileDir  = $_.Name
    DisplayName =   if ($null -ne ($CurrJsonProfile.Account_info)) {
    $Prefix = switch ($CurrJsonProfile.account_info.edge_account_type) 
    {
        $null   {"null"}
        1       {"MSA "}
        2       {"AAD "}
        Default {"IDFK "}
    }
        $prefix + $CurrJsonProfile.Account_info.Email
    } else  {$CurrJsonProfile.Profile.Name}
    ProfileIcon = Join-Path -path $_ -ChildPath 'Edge Profile.ico' | Get-item
    TargetExe   = $EdgeExePath.FullName
    LaunchArgs  = " --profile-directory=""$($_.Name)"""
    }
    
}
#$ProfileProperties2 = $ProfileProperties | where {$_.DisplayName -match "@"}

$ProfileProperties | %{  

    #New-Item -ItemType SymbolicLink -Path $ShortcutsDir -Name ($_.ProfileName) -Value $EdgeExePath 

    $WScriptShell = New-Object -ComObject WScript.Shell
    #$Shortcut = ($WScriptShell.CreateShortcut((Join-Path ($ShortcutsDir) -ChildPath ("$($_.DisplayName) - Edge.lnk"))))
    $Shortcut = ($WScriptShell.CreateShortcut((Join-Path ($ShortcutsDir) -ChildPath ("$($_.DisplayName).lnk"))))
    $Shortcut.TargetPath = $_.TargetExe
    $Shortcut.IconLocation = $_.ProfileIcon
    $Shortcut.Arguments = $_.LaunchArgs
    $Shortcut.Save()

}

