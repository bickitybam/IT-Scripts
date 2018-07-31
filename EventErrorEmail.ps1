#add EventRecordID value to XML export of Event Viewer Scheduled task and add as an argument to the script

param([Int32]$EventRecordID)

$event = get-eventlog -LogName Application -Index $EventRecordID
#get-help get-eventlog will show there are a handful of other options available for selecting the log entry you want.
if ($event.EntryType -eq "Error")
{
    $EventTime = $event.TimeGenerated
    $Source = $event.Source
    $PCName = $env:COMPUTERNAME
    $EmailBody = $event.Message
    $EmailFrom = "Error Alerts <ErrorAlerts@notification.domain.com>"
    $EmailTo = "monitoring@domain.com" 
    $EmailSubject = "${PCName}: $EventRecordID - $Source Error logged at $EventTime"
    $SMTPServer = "server.domain.com"
    Write-host "Sending Email"
    Send-MailMessage -From $EmailFrom -To $EmailTo -Subject $EmailSubject -body $EmailBody -SmtpServer $SMTPServer
}
else
{
    write-host "No error found"
    write-host "Here is the log entry that was inspected:"
    $event
}