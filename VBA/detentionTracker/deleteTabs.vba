Sub DeleteTabsExceptHomepage()
    Dim ws As Worksheet
    Dim wsToKeepList As Object
    Dim wsName As String

    ' Create a collection to hold the worksheet names to keep
    Set wsToKeepList = CreateObject("Scripting.Dictionary")
    
    ' Add worksheet names to the list
    wsToKeepList.Add "autoCreateTabs", 1
    wsToKeepList.Add "autoDeleteTabs", 1
    wsToKeepList.Add "createRollingTab", 1
    wsToKeepList.Add "Homepage", 1
    wsToKeepList.Add "How To Use", 1

    ' Loop through all worksheets in the workbook
    For Each ws In ThisWorkbook.Sheets
        wsName = ws.Name
        ' Check if the current worksheet's name is in the list
        If Not wsToKeepList.Exists(wsName) Then
            ' Delete the worksheet
            Application.DisplayAlerts = False ' Disable delete confirmation
            ws.Delete
            Application.DisplayAlerts = True ' Re-enable delete confirmation
        End If
    Next ws
End Sub