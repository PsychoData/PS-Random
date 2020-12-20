function Get-DKIMRecordsO365 ($Domain, $TenantName)
{
    $TenantName = $TenantName -replace "(.*?)\.onmicrosoft.com",'$1'
    "selector1","selector2" | Foreach {
        [pscustomobject]@{
            CNAME = "{0}._domainkey.{1}" -f $_,$Domain
            Destination = "{0}-{1}._domainkey.{2}.onmicrosoft.com" -f $_,($Domain -replace "\.","-"),$TenantName 
        }
    }
} ; 
Write-Host 'Domain Name, like company.com'
$domName    = Read-Host -Prompt 'Domain Name?'
Write-Host 'Tenant Name, like company.onmicrosoft.com'
$tenantName = Read-Host -Prompt 'Tenant Name?'
Get-DKIMRecordsO365 -Domain $domName -TenantName $tenantName
