$VerbosePreference = Continue
Foreach ($currItem in $args)
{
	"$currItem"
	Test-Path $currItem
	Get-ChildItem $CurrItem
}
