Sub calculateRolling()
    Dim ws As Worksheet
    Dim lr As Long
    Dim subWS As Worksheet
    Dim lastRow As Long
    Dim lastColumn As Long
    Dim populatedRange As Range
    Dim sheetName As String
    Dim rowCounter As Long


    Dim wsTemp As Worksheet
    Dim headerRange As Range
    Dim dataRange As Range
    
    ' Define the worksheet you want to clear
    Set wsTemp = ThisWorkbook.Worksheets("Rolling") ' Change "Sheet1" to your sheet's name
    
    ' Assuming your headers are in the first row, define the header range
    Set headerRange = wsTemp.Rows(1)
    
    ' Determine the data range (all rows except the first row)
    Set dataRange = wsTemp.Range(wsTemp.Cells(2, 1), wsTemp.Cells(wsTemp.Rows.Count, wsTemp.Columns.Count))
    
    ' Clear the data range
    dataRange.ClearContents

    ' Initialize lr with the next row to paste data in the "Rolling" worksheet
    lr = Sheets("Rolling").Cells(Sheets("Rolling").Rows.Count, "A").End(xlUp).Row + 1

    For Each ws In Worksheets
        ' Check if the worksheet name is not "Master" or "Homepage"
        If ws.Name <> "Rolling" And ws.Name <> "Homepage" Then
            sheetName = ws.Name ' Assign the worksheet name to the sheetName variable
            
            ' Set subWS to the target worksheet
            Set subWS = ThisWorkbook.Worksheets(sheetName)
            
            ' Find the last row and last column with data in subWS
            lastRow = subWS.Cells(subWS.Rows.Count, 1).End(xlUp).Row
            lastColumn = subWS.Cells(1, subWS.Columns.Count).End(xlToLeft).Column
            
            ' Initialize the row counter
            rowCounter = 0
            
            ' Loop through each row in the range (excluding header row)
            For rowCounter = 2 To lastRow
                ' Check if the first cell in the row is not empty
                If Not IsEmpty(subWS.Cells(rowCounter, 1)) Then
                    ' Define the populated range for the current row
                    Set populatedRange = subWS.Range(subWS.Cells(rowCounter, 1), subWS.Cells(rowCounter, lastColumn))
                    
                    ' Copy the populatedRange from subWS to the "Rolling" worksheet starting at lr
                    populatedRange.Copy Sheets("Rolling").Range("A" & lr)
                    
                    ' Increment lr by 1
                    lr = lr + 1
                End If
            Next rowCounter
        End If
    Next ws
End Sub