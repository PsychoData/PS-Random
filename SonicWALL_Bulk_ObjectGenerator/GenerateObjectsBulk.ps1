#################
#Source https://github.com/PsychoData/PS-Random/tree/master/SonicWALL_Bulk_ObjectGenerator
#Based on https://www.phy2vir.com/sonicwall-script-generator-create-multiple-address-objects-and-add-them-to-an-address-group/
$NetPrefixString = "AppRiver_Network" + "_" +(Get-Date -Format 'yyyy-MM-dd')
$CSVToImport = '.\SonicWALL_ObjectsToCreate.csv'
$OutputFile  = ".\ObjectCommands-$(Get-Date -Format 'yyyy-MM-dd_HH_mm_ss').txt"
$DefaultZone = 'LAN'
#################
#Import CSV, Split Out IPs and SubnetMasks, if they are found

$objects = Import-Csv $CSVToImport | 
    Select-Object `
    @{N='IP';E={($_.IPAddress -split '/')[0]}},
    @{N='Subnet';E={"/" + [string]($_.IPAddress -split '/')[1]}},
    ObjectName,
    Zone

#If a CIDR Mask wasn't found, set it to /32 for a host
$objects | Where-Object {$_.Subnet -eq '/' } | ForEach-Object{ $_.Subnet = '/32'}
$i = 1
#Add a unique ID for each net that we add. Supports up to 99 Objects at once
$objects | Where-Object {($null -eq $_.ObjectName) -or ($_.ObjectName -eq '') } | ForEach-Object{ $_.ObjectName = ("${NetPrefixString}_{0:00}" -f $i); $i++}
#Add Zone if it wasn't Specified in CSV
$objects | Where-Object {$null -eq $_.Zone  -or ($_.Zone -eq '') }| ForEach-Object{ $_.Zone = $DefaultZone}

Write-Verbose -Verbose "Adding Commands to start configure session"
$commands = 'configure' | Out-String

Write-Verbose -Verbose "Adding Commands to create Each Object"
$commands += $objects | ForEach-Object{ "address-object ipv4 " + $_.ObjectName + " network " + $_.IP + " " + $_.Subnet + " zone " + $_.Zone } | Out-String 
$commands += "exit",'yes','configure' | Out-String

Write-Verbose -Verbose "Adding Commands to create the Address Group"
$commands += "address-group ipv4" + $NetPrefixString + "_IPs" | Out-String
$commands += $objects | ForEach-Object{ "address-object ipv4 " + $_.ObjectName} | Out-String

Write-Verbose -Verbose "Adding Commands to close config session"
$commands += 'exit','exit','yes' | Out-String

Write-Verbose -Verbose "Writing Commands to commands file"
$commands | Out-File -FilePath $OutputFile -Encoding ascii -Verbose

