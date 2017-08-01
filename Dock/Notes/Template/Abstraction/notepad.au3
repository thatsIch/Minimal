;~ Dim $file = "C:\Users\Badhard\Documents\Rainmeter\Skins\Minimal\Notes\Note1\note.txt"
HotKeySet ( "{Esc}", "captureEsc" )

if $CmdLine[0] > 1 Then
	Local $file = $CmdLine[1]
	Local $updateCommand = $CmdLine[2]

	RunWait ( @WindowsDir & "\notepad.exe " & $file, @WindowsDir )
	Run ( $updateCommand )
EndIf

Func captureEsc()
	WinWaitActive( "[CLASS:Notepad]" )
	Send( "^s" )
	WinClose ( "[CLASS:Notepad]" )
EndFunc


