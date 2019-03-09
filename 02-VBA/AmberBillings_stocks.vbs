Sub Stocks()

    Dim Ticker As String
    Dim TSV As Double
    Dim sumRow As Integer
    Dim year_open As Double
    Dim year_close As Double
    Dim ychange As Double
    
    'Run for each worksheet
    For Each ws In Worksheets
    ws.Activate
    
    'Set stock volume to 0
    TSV = 0

    'Start summary lists in Row 2
    sumRow = 2
    
    'Add headers
    ws.Range("I1").Value = "Ticker"
    ws.Range("J1").Value = "Yearly Change"
    ws.Range("K1").Value = "Percent Change"
    ws.Range("L1").Value = "Total Stock Volume"
    ws.Range("P1").Value = "Ticker"
    ws.Range("Q1").Value = "Value"
    ws.Range("O2").Value = "Greatest % Increase"
    ws.Range("O3").Value = "Greatest % Decrease"
    ws.Range("O4").Value = "Greatest Total Volume"
    
    'Find last row
    lastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
    
        'Loop through all stocks
        For i = 2 To lastRow

            'If stock name is not the same as the next stock name
            If Cells(i + 1, 1).Value <> Cells(i, 1).Value Then

                'Set values
                Ticker = ws.Cells(i, 1).Value
                year_open = ws.Cells(i - 260, 3).Value
                year_close = ws.Cells(i, 6).Value
                
                'If opening value is zero
                If year_open = 0 Then
                
                    'Print "N/A" in percent change"
                    ychange = year_close - year_open
                    pchange = "N/A"
                
                'If opening value is anything other than zero
                Else
                
                    'Calculate year change and percentage change
                    ychange = year_close - year_open
                    pchange = (year_close - year_open) / year_open
                    
                End If
                
                'Add to stock volume count
                TSV = TSV + ws.Cells(i, 7).Value

                'Print values in summary table
                ws.Range("I" & sumRow).Value = Ticker
                ws.Range("L" & sumRow).Value = TSV
                ws.Range("J" & sumRow).Value = ychange
                ws.Range("K" & sumRow).Value = pchange

                'Start on next row of summary table
                sumRow = sumRow + 1
                
                'Reset stock volume to 0
                TSV = 0

            Else

                'Add volume for same values in column A
                TSV = TSV + ws.Cells(i, 7).Value

            End If
            
            Next i
            
    'Find last row in summary list
    sumLastRow = ws.Cells(Rows.Count, 9).End(xlUp).Row
    
    'Format percents
    ws.Range("K2:K" & sumLastRow).Style = "Percent"
            
            'Loop through yearly change
            For j = 2 To sumLastRow
                
                'Highlight positive cells in green
                If ws.Cells(j, 10).Value > 0 Then
                ws.Cells(j, 10).Interior.ColorIndex = 4
                
                'Highlight negative cells in red
                ElseIf ws.Cells(j, 10).Value < 0 Then
                ws.Cells(j, 10).Interior.ColorIndex = 3
                
                End If
                
            Next j
            
    'Find greatest % increase, greatest % decrease and greatest total volume
    GPI = Application.WorksheetFunction.Max(Range("K2:K" & sumLastRow))
    GPD = Application.WorksheetFunction.Min(Range("K2:K" & sumLastRow))
    GTV = Application.WorksheetFunction.Max(Range("L2:L" & sumLastRow))
    
    'Loop through percent change
    For k = 2 To sumLastRow
    
        'Pull ticker and value for greatest % increase
        If ws.Cells(k, 11).Value = GPI Then
        ws.Range("Q2").Value = GPI
        ws.Range("P2").Value = ws.Cells(k, 9).Value
        ws.Range("Q2").Style = "Percent"
        
        End If
    
    Next k
    
    'Loop through percent change
    For l = 2 To sumLastRow
    
        'Pull ticker and value for greatest % decrease
        If ws.Cells(l, 11).Value = GPD Then
        ws.Range("Q3").Value = GPD
        ws.Range("P3").Value = ws.Cells(l, 9).Value
        ws.Range("Q3").Style = "Percent"
        
        End If
    
    Next l

    'Loop through total stock volume
    For m = 2 To sumLastRow
    
        'Pull ticker and value for greatest total volume
        If ws.Cells(m, 12).Value = GTV Then
        ws.Range("Q4").Value = GTV
        ws.Range("P4").Value = ws.Cells(m, 9).Value
        
        End If
    
    Next m

    Next ws

End Sub