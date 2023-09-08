Public startYear As Integer
Public startMonth As Integer
Public startDay As Integer
Public endYear As Integer
Public endMonth As Integer
Public endDay As Integer

Sub CommandButton1_Click()
    ' Validate and process input
    'Dim startYear As Integer
    'Dim startMonth As Integer
    'Dim startDay As Integer
    'Dim endYear As Integer
    'Dim endMonth As Integer
    'Dim endDay As Integer
    
    ' Attempt to convert input values to integers
    If Not IsNumeric(TextBox1.Value) Or Not IsNumeric(TextBox2.Value) Or Not IsNumeric(TextBox3.Value) Or _
       Not IsNumeric(TextBox4.Value) Or Not IsNumeric(TextBox5.Value) Or Not IsNumeric(TextBox6.Value) Then
        MsgBox "Please enter valid numeric values for all date components.", vbExclamation
        Exit Sub
    End If
    
    ' Convert input values to integers
    startYear = CInt(TextBox1.Value)
    startMonth = CInt(TextBox2.Value)
    startDay = CInt(TextBox3.Value)
    endYear = CInt(TextBox4.Value)
    endMonth = CInt(TextBox5.Value)
    endDay = CInt(TextBox6.Value)
    
     ' Validate start and end dates as needed
    Debug.Print "startYear: " & startYear
    Debug.Print "startMonth: " & startMonth
    Debug.Print "startDay: " & startDay
    Debug.Print "endYear: " & endYear
    Debug.Print "endMonth: " & endMonth
    Debug.Print "endDay: " & endDay
    
    ' Check if the date is valid
    If Not IsDateValid(startYear, startMonth, startDay) Or Not IsDateValid(endYear, endMonth, endDay) Then
        MsgBox "Please enter a valid date.", vbExclamation
        Exit Sub
    End If

    ' Display the collected data or take action as needed
    MsgBox "Start Date: " & Format(DateSerial(startYear, startMonth, startDay), "dd-MMM-yyyy") & vbCrLf & _
           "End Date: " & Format(DateSerial(endYear, endMonth, endDay), "dd-MMM-yyyy")
    Unload Me ' Close the UserForm
End Sub

' Function to check if a date is valid
Function IsDateValid(ByVal year As Integer, ByVal month As Integer, ByVal day As Integer) As Boolean
    On Error Resume Next
    IsDateValid = IsDate(DateSerial(year, month, day))
    On Error GoTo 0
End Function
