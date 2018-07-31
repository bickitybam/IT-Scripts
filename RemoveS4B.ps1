Connect-MsolService
$LO = New-MsolLicenseOptions -AccountSkuId "Group:ENTERPRISEPACK" -DisabledPlans "MCOSTANDARD"
$acctSKU="Group:ENTERPRISEPACK"
$AllLicensed = Get-MsolUser -All | Where {$_.isLicensed -eq $true -and $_.licenses[0].AccountSku.SkuPartNumber -eq ($acctSKU).Substring($acctSKU.IndexOf(":")+1, $acctSKU.Length-$acctSKU.IndexOf(":")-1)}
$AllLicensed | ForEach-Object {Set-MsolUserLicense -LicenseOptions $LO}