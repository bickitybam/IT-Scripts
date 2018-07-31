'Created by Cheyenne Harden 1.10.07

On Error Resume Next

Dim arrPrinterName()
Dim strComputer, i, PrintServer
Dim objWMIService, objNetwork, colInstalledPrinters, objPrinter

strComputer = "."
i = 0
PrintServer = "server" 'Your Print server name goes here

Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colInstalledPrinters =  objWMIService.ExecQuery _
    ("Select * from Win32_Printer")

	For Each objPrinter in colInstalledPrinters
	'This line is used for trouble shooting
    'Wscript.Echo "Name: " & objPrinter.Name
	
	ReDim Preserve arrPrinterName(i)
	arrPrinterName(i) = objPrinter.Name
		If InStr(arrPrinterName(i), PrintServer) Then
			Set objNetwork = WScript.CreateObject("WScript.Network")
			objNetwork.RemovePrinterConnection arrPrinterName(i)
			i=i+1
		
		Else
			'This line is used for trouble shooting.
			'WScript.Echo  "Name: " & objPrinter.Name
			
		End If

	
Next