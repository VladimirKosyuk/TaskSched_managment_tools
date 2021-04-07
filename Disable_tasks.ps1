#Created by https://github.com/VladimirKosyuk

#Disables task $NameTask on all domain computers, which OS is Windows 10

# Build date: 07.04.2021

$list = Get-ADComputer -Filter * -properties *|
            Where-Object {$_.enabled -eq $true} |
                Where-Object {($_.OperatingSystem -like "*Windows 10*")}|
                        Select-Object -ExpandProperty "name"
                        foreach ($pc in $list) {

    Invoke-Command -ComputerName $pc -ErrorAction SilentlyContinue -ScriptBlock {
    $NameTask = #"My_Task"
    disable-ScheduledTask -TaskName $NameTask
    }
}

Remove-Variable -Name * -Force -ErrorAction SilentlyContinue
