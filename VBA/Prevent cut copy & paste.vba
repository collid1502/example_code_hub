Option Explicit

Sub ToggleCutCopyAndPaste(Allow As Boolean) 
    'Activate / Deactivate cut, copy, paste and paste special menu items' 
    Call EnableMenuItem(21, Allow) ' cut 
    Call EnableMenuItem(19, Allow) ' copy 
    Call EnableMenuItem(22, Allow) ' paste 
    Call EnableMenuItem(755, Allow) ' paste special 

    'activate / deactivate drag and drop ability' 
    Application.CellDragAndDrop = Allow 

    'activate / deactivate cut, copy, paste and special paste shortcut keys' 
    With Application
        Select Case Allow
        Case Is = False  
            .OnKey "^c", "CutCopyPasteDisabled"
            .OnKey "^v", "CutCopyPasteDisabled"
            .OnKey "^x", "CutCopyPasteDisabled"
            .OnKey "+{DEL}", "CutCopyPasteDisabled"
            .OnKey "^{INSERT}", "CutCopyPasteDisabled"
        Case Is = True  
            .OnKey "^c"
            .OnKey "^v"
            .OnKey "^x"
            .OnKey "+{DEL}"
            .OnKey "^{INSERT}"
        End Select 
    End With 
End Sub 

Sub EnableMenuItem(ctlID As Integer, Enabled As Boolean)
    'Activate / Deactivate specific menu item' 
    Dim cBar As CommandBar  
    Dim cBarCtrl As CommandBarControl  
    For Each cBar In Application.CommandBars 
        If cBar.Name <> "Clipboard" Then  
            Set cBarCtrl = cBar.FindControl(ID:=ctlId, recursive:=True) 
            If Not cBarCtrl Is Nothing Then cBarCtrl.Enabled = Enabled 
        End If 
    Next 
End Sub 

Sub CutCopyPasteDisabled() 
    'Inform user that the functions have been disabled' 
    MsgBox "Sorry! - Cutting, Copying & Pasting have been disabled in this workbook!" 
End Sub 

' ---------------------------------------------------------------------------------------------------------' 
'*** In the ThisWorkbook Module ***' 
Option Explicit

Private Sub Workbook_Activate() 
    Call ToggleCutCopyAndPaste(False) 
End Sub 

Private Sub Workbook_BeforeClose(Cancel As Boolean) 
    Call ToggleCutCopyAndPaste(True) 
End Sub 

Private Sub Workbook_Deactivate() 
    Call ToggleCutCopyAndPaste(True) 
End Sub 

Private Sub Workbook_Open() 
    Call ToggleCutCopyAndPaste(False)
End Sub 
