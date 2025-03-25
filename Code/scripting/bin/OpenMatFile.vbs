'============================================= FILE HEADER =============================================
' Title: OpenMatFile
' File Type: <type> (vbs)
' Author: Zakary Steenhoek
'
' Created: March 2025
' Updated: March 2025
'
' Purpose: 
'
' In: 
'
' Out: 
'
'
'=======================================================================================================

' **BEGIN**

Set args = WScript.Arguments
filepath = args(0)

' On Error Resume Next
' Explicitly attempt to get running MATLAB instance
Set Matlab = GetObject(, "Matlab.Application.Single")

If Err.Number <> 0 Or Matlab Is Nothing Then
    Err.Clear
    ' Explicitly create new MATLAB instance if none is running
    Set Matlab = CreateObject("Matlab.Application.Single")
    Matlab.Visible = True
    ' Wait explicitly for MATLAB to initialize
    WScript.Sleep 8000
End If

If Matlab Is Nothing Then
    WScript.Echo "ERROR: MATLAB COM server couldn't be created."
    WScript.Quit 1
End If

' Ensure MATLAB visibility explicitly
Matlab.Visible = True

' Open the file explicitly via MATLAB desktop editor API
Matlab.Execute("matlab.desktop.editor.openDocument('" & Replace(filepath, "\", "/") & "');")

' Explicit short pause ensures command completes before script exit
WScript.Sleep 1500




' **END**
