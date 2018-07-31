'************************************************* 
' File:        Disable Local User Accounts.vbs 
' Author:    Andrew Barnes 
' version:     1.0 Date: 07 September 2009 By : Andrew D Barnes 
' Lists local accounts and disables all except local admin and ASPNET 
'************************************************* 
 
Set objShell = CreateObject("Wscript.Shell") 
Set objNetwork = CreateObject("Wscript.Network") 
 
strComputer = objNetwork.ComputerName 
 
Set colAccounts = GetObject("WinNT://" & strComputer & "") 

Dim hasDA
Dim username
Dim admins
hasDA = FALSE
admins = Array("admin","profile","temp","tempuser")
 
colAccounts.Filter = Array("user") 
    Message = Message & "Local User accounts:" & vbCrLf & vbCrLf 
 
For Each objUser In colAccounts
	username = LCase(objUser.Name)
	If username = "localadmin" Then
		hasDA = TRUE
	End If
Next

If hasDA = FALSE Then
	WScript.Echo "localadmin is missing!"
	WScript.Quit
End If

 
For Each objUser In colAccounts 
	username = LCase(objUser.Name)
	For Each x In admins
		If username = x Then 
				Message = Message & objUser.Name 
				If objUser.AccountDisabled = TRUE then 
					Message = Message & " is currently disabled" & vbCrLf 
				Else 
					Message = Message & " was enabled" & vbCrLf 
					objUser.AccountDisabled = True 
					objUser.SetInfo 
				End if 
		End If 
	Next
Next 
 
' Initialize title text. 
Title = "Local User Accounts By Andrew Barnes" 
objShell.Popup Message, , Title, vbInformation + vbOKOnly