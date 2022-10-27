Public Sub addPassword() 
    Dim FSO As Object 
    Dim folder As Object, subfolder As Object 
    Dim wb As Object 

    Set FSO = CreateObject("Scripting.FilseSystemObject") 
    'Update the path where the files are saved below'
    folderPath = "Example\Folder\Path\Here" 
    Set folder = FSO.GetFolder(folderPath) 

    With Application 
        .DisplayAlerts = False  
        .ScreenUpdating = False  
        .EnableEvents = False 
        .AskToUpdateLinks = False 
    End With 

    For Each wb In folder.Files 
        If Right(wb.Name, 3) = "xls" Or Right(wb.Name, 4) = "xlsx" Or Right(wb.Name, 4) = "xlsm" Or Right(wb.Name, 3) = "XLS" Or Right(wb.Name, 4) = "XLSX" Or Right(wb.Name, 4) = "XLSM" Then
            Set masterWB = Workbooks.Open(wb) 
            ' add in password below that you would like to add to files ' 
            ActiveWorkbook.SaveAs Filename:=Application.ActiveWorkbook.FullName, Password:="passwordTest"  
            ActiveWorkbook.Close True 
        End If 
    Next 
    For Each subfolder In folder.SubFolders 
        For Each wb In subfolder.Files 
            If Right(wb.Name, 3) = "xls" Or Right(wb.Name, 4) = "xlsx" Or Right(wb.Name, 4) = "xlsm" Or Right(wb.Name, 3) = "XLS" Or Right(wb.Name, 4) = "XLSX" Or Right(wb.Name, 4) = "XLSM" Then
                Set masterWB = Workbooks.Open(wb) 
                ' add in password below that you would like to add to files ' 
                ActiveWorkbook.SaveAs Filename:=Application.ActiveWorkbook.FullName, Password:="passwordTest" 
                ActiveWorkbook.Close True 
            End If 
        Next 
    Next 
    With Application 
        .DisplayAlerts = True    
        .ScreenUpdating = True   
        .EnableEvents = True  
        .AskToUpdateLinks = True 
    End With 
End Sub 