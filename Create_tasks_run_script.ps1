#Created by https://github.com/VladimirKosyuk

#Foreach of domain PCs, which OS is Windows 10, creates task to execute powershell script. Task execution time is 01:00:00 with random 5 minutes delay, for the first one pc from the $list, for each one next run time will be +10 minutes step. Task run account is system.

#IMPORTANT - target PCs execution policy should not be restricted, execution script path should be accessible via target PCs system account. 

# Build date: 07.04.2021

$list = Get-ADComputer -Filter * -properties *|
            Where-Object {$_.enabled -eq $true} |
                Where-Object {$_.OperatingSystem -like "*Windows 10*"}|
                        Select-Object -ExpandProperty name
[DateTime]$Date = "01:00:00"
$i=0
foreach ($pc in $list) {
$i++
    Invoke-Command -ComputerName $pc -ErrorAction SilentlyContinue -ArgumentList $Date, $i -ScriptBlock {
    param($Date, $i)
    $NameTask = #"My_Task"
    $DescriptionTask = #"My_Description"
        $Action = New-ScheduledTaskAction `
        -Execute 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe' `
        -Argument #'-File "\\SRV\share\script.ps1"'
        $trigger =  New-ScheduledTaskTrigger -Weekly -WeeksInterval 1  -DaysOfWeek Monday -RandomDelay "00:05" -At $Date.Addminutes($i*10).ToString("HH:mm:ss")
        $Principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $Principal -TaskName $NameTask -Description $DescriptionTask
    }
}

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue