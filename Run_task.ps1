#Created by https://github.com/VladimirKosyuk

#Run task $NameTask on remote $pc name

# Build date: 07.04.2021

$pc = #"Pc"
    Invoke-Command -ComputerName $pc -ErrorAction SilentlyContinue -ScriptBlock {
    $NameTask = #"My_Task"
    Start-ScheduledTask -TaskName $NameTask
    }

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue