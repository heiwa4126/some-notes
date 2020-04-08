$now = Get-Date
$start = $now - (New-TimeSpan -Hours 1)
Get-EventLog Application |
Where-Object { (($_.TimeGenerated -ge $start) -and ($_.TimeGenerated -le $now)) } |
Sort-Object -Property TimeGenerated |
ConvertTo-Csv -NoTypeInformation |
Out-File -Encoding default 'R:\ProgramData\test.csv'
