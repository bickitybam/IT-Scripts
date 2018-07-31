On Error Resume Next

Set objNet = WScript.CreateObject( "WScript.Network" )

Const FOR_READING = 1

strFileName = "c:\targets-admin.txt"

strUser = "admin"

Set objFSO = CreateObject("Scripting.FileSystemObject")

Set objTextStream = objFSO.OpenTextFile(strFileName, FOR_READING)

Do Until objTextStream.AtEndOfStream
	'Disable user
	strComputer = objTextStream.ReadLine
	Set objUser = GetObject("WinNT://" & strComputer & "/" & strUser)
	objUser.AccountDisabled = True
	objUser.SetInfo
Loop
