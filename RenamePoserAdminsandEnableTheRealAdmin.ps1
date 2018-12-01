Write-Verbose "Fetching all the users... this may take a minute" -Verbose 
$LocalUsers = Get-CimInstance Win32_UserAccount
$administrator = $LocalUsers | where {($_.SID -match "^.*?-500$")}

#If the local account with SID ending in -500 is "Administrator" we're done
if (($administrator.Name -eq "administrator") -and ($administrator.SID -match "^.*?-500$")) {
    Write-Verbose "W00T! The Real Administrator is already named right" -Verbose
}
else {
    Write-Verbose "Shit. The Real Administrator isn't 'Administrator', he's something ...else.... but what?" -Verbose
    Start-Sleep -Seconds 2
    Write-Verbose ("Found him! He's still here, he's just hiding as '{0}'" -f $administrator.Name) -Verbose

    $fakeadministrator = $LocalUsers | where {($_.Name -eq "Administrator") }
    if ($fakeadministrator -ne $null) {
        Write-Verbose "And there's some *poser* pretending to be The Real Administrator!" -Verbose
        
        $newPoserAccountName = 'administrator2'
        Write-Verbose ("Renaming the poser to {0}" -f $newPoserAccountName) -Verbose
        Invoke-CimMethod -InputObject $fakeadministrator -MethodName Rename -Arguments @{ Name = $newPoserAccountName}
    }

    Write-Verbose ("Renaming The Real Administrator from '{0}' back to 'Administrator'" -f $administrator.Name) -Verbose
    Invoke-CimMethod -InputObject $administrator -MethodName Rename -Arguments @{ Name = 'Administrator'}
}

if ($administrator.Disabled -eq $true) {
    Write-Verbose ("Some asshole **DISABLED** The Real Administrator!!! Enabling him!!!") -Verbose
    $enableAdmin = " net user Administrator /active:yes"
    Iex $enableAdmin
}
