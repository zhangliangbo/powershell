function New-JMeter
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [String]$Home = 'D:\apache-jmeter-5.4.1'
    )
    $bin = Join-Path -Path $Home -ChildPath 'bin'
    Write-Host $bin
    $jmeter=Join-Path -Path $bin -ChildPath 'jmeter.bat'
    Start-Process -FilePath $jmeter
}