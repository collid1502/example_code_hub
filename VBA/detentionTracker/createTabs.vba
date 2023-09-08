Sub CreateDatedTabs()
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
    
    ' Create an instance of your UserForm
    Dim myForm As DateSubmit ' Replace DateSubmit with your UserForm's actual name
    Set myForm = New DateSubmit ' Replace DateSubmit with your UserForm's actual name
    
    ' Show the UserForm to collect start and end dates
    myForm.Show
    
    ' Retrieve input values from the UserForm (assuming you have public properties or variables in your UserForm)
    Dim startYear As Integer
    Dim startMonth As Integer
    Dim startDay As Integer
    Dim endYear As Integer
    Dim endMonth As Integer
    Dim endDay As Integer
    
    startYear = CInt(myForm.startYear)
    startMonth = CInt(myForm.startMonth)
    startDay = CInt(myForm.startDay)
    endYear = CInt(myForm.endYear)
    endMonth = CInt(myForm.endMonth)
    endDay = CInt(myForm.endDay)
    
    Debug.Print "startYear: " & myForm.startYear
    Debug.Print "startMonth: " & myForm.startMonth
    Debug.Print "startDay: " & myForm.startDay
    Debug.Print "endYear: " & myForm.endYear
    Debug.Print "endMonth: " & myForm.endMonth
    Debug.Print "endDay: " & myForm.endDay
    
    ' Validate start and end dates as needed
    Debug.Print "startYear: " & startYear
    Debug.Print "startMonth: " & startMonth
    Debug.Print "startDay: " & startDay
    Debug.Print "endYear: " & endYear
    Debug.Print "endMonth: " & endMonth
    Debug.Print "endDay: " & endDay
    
    ' Define the start and end dates for your loop
    StartDate = DateSerial(startYear, startMonth, startDay) ' Adjust the start date as needed
    EndDate = DateSerial(endYear, endMonth, endDay) ' Adjust the end date as needed

    ' Set latestWS = sophie_detention_tracker.Sheets("Homepage")
    Set latestWS = ThisWorkbook.Sheets("Homepage")
    
    ' Loop through the dates and create tabs for weekdays
    CurrentDate = EndDate
    Do While CurrentDate >= StartDate
        ' Check if the current date is not Saturday (vbSaturday = 7) or Sunday (vbSunday = 1)
        If Weekday(CurrentDate, vbSunday) <> 1 And Weekday(CurrentDate, vbSunday) <> 7 Then
            ' Create a new worksheet
            Set ws = ThisWorkbook.Sheets.Add(After:=latestWS) ' This will ensure worksheets are built to the right, not left
            ' Set the name of the worksheet based on the current date
            ws.Name = Format(CurrentDate, "ddd dd-mm-yyyy") ' You can adjust the date format or use "yyyy-mm-dd"
            
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
            
            ' Create some data validation sheets
            ' --------------------------------------------------------------------------
            ' validate the house names so no incorrect ones can enter
            Set house = ws.Columns("B")
            validationList = "BIRKBECK,IMPERIAL,KINGS,QUEEN MARYS,ST GEORGES"
            ' Apply data validation with a dropdown list
            With house.Validation
                .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, Operator:= _
                xlBetween, Formula1:=validationList
            End With
            
            ' validate dates only in date column
            Set dateCheck = ws.Columns("C")
            With dateCheck.Validation
                .Add Type:=xlValidateDate, AlertStyle:=xlValidAlertStop, Operator:= _
                xlBetween, Formula1:="1/1/1900", Formula2:="12/31/9999"
            End With
            
            ' create auto date population in Column C
            ' Find the last row in the column where you want to set the formula
            'lastRow = ws.Cells(ws.Rows.Count, "C").End(xlUp).Row ' Assuming you want to set the formula in column C
            ' Loop through each cell in the column and set the formula
            For Each formulaCell In ws.Range("A2:A500") ' Start from row 2 to avoid the header
                ' Set the formula for each cell in the column
                ' If cell in A is not Null, populate with todays date
                formulaCell.Offset(0, 2).Formula = "=IF(A" & formulaCell.Row & "<>"""",TODAY(),"""")"
                formulaCell.Offset(0, 3).Formula = "=IF(A" & formulaCell.Row & "<>"""", TEXT(TODAY(), ""dddd""), """")"

            Next formulaCell

            ' Set the event handler to the new sheet
            'Set sheetHandler.Worksheet = ws
            
        End If
        ' Move to the next date
        CurrentDate = CurrentDate - 1
    Loop
End Sub