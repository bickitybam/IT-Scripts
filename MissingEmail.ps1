$users = Get-AzureADUser -All 1 | Select-Object mail, UserPrincipalName | Where-Object mail -eq $null

$Output = @()

foreach ($User in $Users)
{
    $UPN = $User.UserPrincipalName
    $mail = $User.mail
        {
            $Output += New-Object -TypeName PSObject -Property @{
                Name = $UPN
                mail = $mail
                
            } | Select-Object Name, mail
        }
}

$Output | Format-List