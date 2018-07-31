$users = Get-AzureADUser -All 1 | Select-Object @{e={$_.ProxyAddresses -cmatch '^SMTP\:.*'};name='Primaryaddress'}, mail, UserPrincipalName | Where-Object Primaryaddress -ne $null

$Output = @()

foreach ($User in $Users)
{
    $UPN = $User.UserPrincipalName
    $mail = $User.mail
    $primaryaddress = ($User.Primaryaddress).Substring(5)

        if ($UPN -ne $primaryaddress)
        {
            $Output += New-Object -TypeName PSObject -Property @{
                Name = $UPN
                mail = $mail
                Primary = $primaryaddress
            } | Select-Object Name, mail, Primary
        }
}

$Output | Format-List