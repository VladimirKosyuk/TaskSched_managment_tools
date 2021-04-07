#Created by https://github.com/VladimirKosyuk

#Creates ExecutionPolicy RemoteSigned task on remote pc. Task execution time is 01:00:00. Task run account is system.

# Build date: 07.04.2021

$pc = #"Pc"
[DateTime]$Date = "01:00:00"
    Invoke-Command -ComputerName $pc -ErrorAction SilentlyContinue -ArgumentList $Date -ScriptBlock {
    param($Date)
        $Action = New-ScheduledTaskAction `
        -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' `
        -Argument '-Command Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force'
        $trigger =  New-ScheduledTaskTrigger -Daily -At $Date
        $Principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $Principal -TaskName "Set execution policy" -Description "Set-ExecutionPolicy RemoteSigned"
    }

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue

