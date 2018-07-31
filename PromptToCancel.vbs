Set objShell = CreateObject("Wscript.Shell")
intReturn = objShell.Popup("Do you want to delete this file?", 10, "Delete File", 4 + 32)

If intReturn = 6 Then
Wscript.Quit(6)
ElseIf intReturn = 7 Then
Wscript.Quit(7)
Else
Wscript.Quit(6)
End If