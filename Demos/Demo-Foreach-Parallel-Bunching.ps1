#Requires -Version 7.1
#SourceURL - https://github.com/PsychoData/PS-Random/blob/master/Demos/Demo-Foreach-Parallel-Bunching.ps1
$source = @"
[
    {
        customer: "red",
        inventory: ['host001', 'host002','host003']
    },
    {
        customer: "green",
        inventory: ['host001', 'host002', 'host003', 'host004','host005', 'host006', 'host007']
    },
    {
        customer: "yellow",
        inventory: ['host001', 'host002', 'host003', 'host004']
    }
]
"@
$groupBy = 3
$entries = ($source | ConvertFrom-Json) | foreach { 
    $customer = $_.Customer
    $_.Inventory | foreach { 
        [pscustomobject]@{
            Customer = $customer
            Host     = $_
        }
    }
}

$groups = $entries | ForEach-Object -Begin { $i = 1 } -Process {
    #Hand out 1 from each source to each output group, then repeat
    ##This might evenly Spread out sources among different testers 
    #$_ | Add-Member -NotePropertyName 'Grouping' -NotePropertyValue ($i % $groupBy) -PassThru  ; 

    #Hand out multiple until a given group is full from each source to each output group, then repeat
    ##This might Group objects from a similar source database on a session that was already loading some of that in memory, improving performance in large models
    $_ | Add-Member -NotePropertyName 'Grouping' -NotePropertyValue ([math]::Floor(($i - 1) / $groupBy) + 1 ) -PassThru  ; 
    
    $i++
} | Group-Object -Property Grouping 

$groups |  ForEach-Object -Parallel { 
    $GroupName = $_.Name
    "Initial Setup - group $GroupName"

    $_.Group | ForEach-Object {
        "Do-stuff - group $GroupName - Customer $($_.Customer) - Host $($_.Host)"
    }
}
