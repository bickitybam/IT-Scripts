$Folder = "C:\Users\user\OneDrive"
$Items = Get-ChildItem -Path $Folder -Recurse

$UnsupportedChars = '[#%]'

foreach ($item in $items){
    filter Matches($UnsupportedChars){
    $item.Name | Select-String -AllMatches $UnsupportedChars |
    Select-Object -ExpandProperty Matches
    Select-Object -ExpandProperty Values
    }

    $newFileName = $item.Name
    Matches $UnsupportedChars | ForEach-Object {
        Write-Host "$($item.FullName) has the illegal character $($_.Value)" -ForegroundColor Red
        #These characters may be used on the file system but not SharePoint
        if ($_.Value -match "#") { $newFileName = ($newFileName -replace "#", "") }
        if ($_.Value -match "%") { $newFileName = ($newFileName -replace "%", "") }
     }
     if (($newFileName -ne $item.Name)){
        Rename-Item $item.FullName -NewName ($newFileName)
        Write-Host "$($item.Name) has been changed to $newFileName" -ForegroundColor Green
     }
}