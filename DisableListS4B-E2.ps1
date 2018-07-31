$TargetE2s = Import-Csv -Path ".\TargetE2s.csv"
$LO = New-MsolLicenseOptions -AccountSkuId DocuwareGroup:STANDARDWOFFPACK -DisabledPlans "MCOSTANDARD"
$TargetE2s | ForEach {Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -LicenseOptions $LO}