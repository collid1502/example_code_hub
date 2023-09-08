
Sub CreateRollingTab()
    Dim StartDate As Date
    Dim EndDate As Date
    Dim CurrentDate As Date
    Dim ws As Worksheet
    Dim latestWS As Worksheet
    Dim cell1 As Range
    Dim cell2 As Range
    Dim cell3 As Range
    Dim cell4 As Range
    Dim cell5 As Range
    Dim validationList As String
    Dim house As Range
    Dim ColumnRange As Range
    Dim ColumnRange2 As Range
    Dim dateCheck As Range
    Dim dateCol As Range
    Dim dateCell As Range
    Dim lastRow As Long
    Dim formulaCell As Range
    Dim lastColumn As Long

    ' Set latestWS = sophie_detention_tracker.Sheets("Homepage")
    Set latestWS = ThisWorkbook.Sheets("Homepage")

            ' Create a new worksheet
            Set ws = ThisWorkbook.Sheets.Add(After:=latestWS) ' This will ensure worksheets are built to the right, not left
            ' Set the name of the worksheet based on the current date
            ws.Name = "Rolling"
            
            ' Define the range where you added columns (columns A to C)
            Set ColumnRange = ws.Range("A:D")
            ' specified range and centre them plus set width
            ColumnRange.HorizontalAlignment = -4108
            ColumnRange.ColumnWidth = 30
            
            Set ColumnRange2 = ws.Range("E:E")
            ColumnRange2.ColumnWidth = 200
            
            ' underline columns with borders & colour grey
            Set cell1 = ws.Range("A1")
            cell1.Borders(xlEdgeBottom).LineStyle = xlContinuous
            cell1.Borders(xlEdgeBottom).Weight = xlMedium
            cell1.Interior.Color = RGB(211, 211, 211) ' RGB value for gray
            
            Set cell2 = ws.Range("B1")
            cell2.Borders(xlEdgeBottom).LineStyle = xlContinuous
            cell2.Borders(xlEdgeBottom).Weight = xlMedium
            cell2.Interior.Color = RGB(211, 211, 211) ' RGB value for gray
            
            Set cell3 = ws.Range("C1")
            cell3.Borders(xlEdgeBottom).LineStyle = xlContinuous
            cell3.Borders(xlEdgeBottom).Weight = xlMedium
            cell3.Interior.Color = RGB(211, 211, 211) ' RGB value for gray
            
            Set cell4 = ws.Range("D1")
            cell4.Borders(xlEdgeBottom).LineStyle = xlContinuous
            cell4.Borders(xlEdgeBottom).Weight = xlMedium
            cell4.Interior.Color = RGB(211, 211, 211) ' RGB value for gray
            
            Set cell5 = ws.Range("E1")
            cell5.Borders(xlEdgeBottom).LineStyle = xlContinuous
            cell5.Borders(xlEdgeBottom).Weight = xlMedium
            cell5.Interior.Color = RGB(211, 211, 211) ' RGB value for gray
            
            ' Set column names in the first row of the inserted columns
            ws.Cells(1, 1).Value = "STUDENT" ' Replace with your column names
            ws.Cells(1, 2).Value = "HOUSE"
            ws.Cells(1, 3).Value = "DATE"
            ws.Cells(1, 4).Value = "WEEKDAY"
            ws.Cells(1, 5).Value = "NOTES"
            ws.Cells(1, 5).Font.Italic = True ' sets the cell text to italic
            
            ' format columns
            ws.Columns("A:B").NumberFormat = "@"
            ws.Columns("C:C").NumberFormat = "dd/mm/yyyy"
            
            ' Assuming your data starts in cell A1, determine the last column in the heading row
            lastColumn = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
    
            ' Add filters to the heading row
            ws.Range("A1").AutoFilter Field:=1, Criteria1:="FilterCriteria" ' Change Field and Criteria1 as needed

End Sub