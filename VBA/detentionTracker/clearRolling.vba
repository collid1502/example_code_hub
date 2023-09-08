Sub ClearRollingData()
    Dim ws As Worksheet
    Dim headerRange As Range
    Dim dataRange As Range
    
    ' Define the worksheet you want to clear
    Set ws = ThisWorkbook.Worksheets("Rolling") ' Change "Sheet1" to your sheet's name
    
    ' Assuming your headers are in the first row, define the header range
    Set headerRange = ws.Rows(1)
    
    ' Determine the data range (all rows except the first row)
    Set dataRange = ws.Range(ws.Cells(2, 1), ws.Cells(ws.Rows.Count, ws.Columns.Count))
    
    ' Clear the data range
    dataRange.ClearContents
End Sub

