function IMCEAEX-ToX500 ($IMCEAEX)
{
    $X500 = $IMCEAEX -replace "_",'/' -replace "\+20"," " -replace "\+28","(" -replace "\+29",")" -replace "^IMCEAEX-",'' -replace "@(\w+.)+\w$",""-replace "^(.*)","X500:`$1" 
    return $X500 
}


IMCEAEX-ToX500 -IMCEAEX "IMCEAEX-_O=FIRST+20ORGANIZATION_OU=EXCHANGE+20ADMINISTRATIVE+20GROUP+20+28FYDIBOHF23SPDLT+29_CN=RECIPIENTS_CN=Comp+20Procurement9ca@domain.com"


