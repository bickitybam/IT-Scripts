$TargetE3s = Import-Csv -Path ".\TargetE3s.csv"
$LO = New-MsolLicenseOptions -AccountSkuId DocuwareGroup:ENTERPRISEPACK -DisabledPlans "MCOSTANDARD"
$TargetE3s | ForEach {Set-MsolUserLicense -UserPrincipalName $_.UserPrincipalName -LicenseOptions $LO}