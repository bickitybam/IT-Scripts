$AllLicensingPlans = Get-MsolAccountSku
for($i = 0; $i -lt $AllLicensingPlans.Count; $i++)
{
    $O365Licences = New-MsolLicenseOptions -AccountSkuId $AllLicensingPlans[$i].AccountSkuId -DisabledPlans "MCOSTANDARD"
    Set-MsolUserLicense -UserPrincipalName Robin.Horner@docuware.com -LicenseOptions $O365Licences
}