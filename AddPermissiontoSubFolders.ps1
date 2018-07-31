<# This Script use to add permissions to SubFolder of Shared Mailbox for Exchange Online. 
The Original Script is Created by Paul for Exchange 2010 and I modify on it for Exchnage Online.
.DESCRIPTION 
A proof of concept script for adding mailbox folder
permissions to all folders in a mailbox for Exchange Online.
.OUTPUTS
Console output for progress.
.PARAMETER Mailbox
The mailbox that the folder permissions will be added to.
.PARAMETER User
The user you are granting mailbox folder permissions to.
.PARAMETER Access
The permissions to grant for each folder.
.EXAMPLE
.\AddPermissiontoSubFolders.ps1 -Mailbox TestShare -User Test2 -Access Reviewer
This will grant Test2 "Reviewer" access to all folders in TestShare's mailbox.
.NOTES
Written by: Paul Cunningham "http://exchangeserverpro.com/grant-read-access-exchange-mailbox/"
Modified by: Mai Ali
#>

[CmdletBinding()]
param (
	[Parameter( Mandatory=$true)]
	[string]$Mailbox,
    
	[Parameter( Mandatory=$true)]
	[string]$User,
    
  	[Parameter( Mandatory=$true)]
	[string]$Access
)


#...................................
# Variables
#...................................

$exclusions = @("/Sync Issues",
                "/Sync Issues/Conflicts",
                "/Sync Issues/Local Failures",
                "/Sync Issues/Server Failures",
                "/Recoverable Items",
                "/Deletions",
                "/Purges",
                "/Versions"
                )


#...................................
# Initialize
#...................................
#...................................
# Script
#...................................

$mailboxfolders = @(Get-MailboxFolderStatistics $Mailbox | Where {!($exclusions -icontains $_.FolderPath)} | Select FolderPath)

foreach ($mailboxfolder in $mailboxfolders)
{
    $folder = $mailboxfolder.FolderPath.Replace("/","\")
    if ($folder -match "Top of Information Store")
    {
       $folder = $folder.Replace(“\Top of Information Store”,”\”)
    }
    $identity = "$($mailbox):$folder"
    Write-Host "Adding $user to $identity with $access permissions"
    try
    {
        Add-MailboxFolderPermission -Identity $identity -User $user -AccessRights $Access -ErrorAction STOP
    }
    catch
    {
        Write-Warning $_.Exception.Message
    }
}


#...................................
# End
#...................................