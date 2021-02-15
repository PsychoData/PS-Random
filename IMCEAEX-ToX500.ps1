function IMCEAEX-ToX500 ($IMCEAEX)
{
    $X500 = $IMCEAEX -replace "_",'/' -replace "\+20"," " -replace "\+28","(" -replace "\+29",")" -replace "^IMCEAEX-",'' -replace "@(\w+.)+\w$",""-replace "^(.*)","X500:`$1" 
    return $X500 
}


IMCEAEX-ToX500 -IMCEAEX "IMCEAEX-_O=FIRST+20ORGANIZATION_OU=EXCHANGE+20ADMINISTRATIVE+20GROUP+20+28FYDIBOHF23SPDLT+29_CN=RECIPIENTS_CN=Comp+20Procurement@domain.com"

<#
Given a Sample address "IMCEAEX-_O={0}_OU={1}_CN=RECIPIENTS_CN=Comp+20Procurement@domain.com"
This IMCEAEX address has several parts, with some characters escaped in a certain way. This may hold 
        true for many more characters, but I could not find documentation specifying how explicitly
   - a space " " normally URL escapes to %20 so here it becomes +20
   -  a "("   normally URL escapes to $29 so here it becomes +29
   -  a ")"   normally URL escapes to %28 so here it becomes +28
                
"IMCEAEX-_O={0}_OU={1}_CN=RECIPIENTS_CN={2}"
            {0} = Exchange Organization name, here "FIRST ORGANIZATION" 
            FIRST+20ORGANIZATION
                   {1} = OU, here "EXCHANGE AADMINISTRATIVE GROUP (FYDIBOHF23SPDLT)"
                   EXCHANGE+20ADMINISTRATIVE+20GROUP+20+28FYDIBOHF23SPDLT+29
                                        {2} = Display name of the Recipient, here "Comp Procurement@domain.com"
                                        Comp+20Procurement@domain.com
#>
