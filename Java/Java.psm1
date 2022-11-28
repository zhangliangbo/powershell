function New-VisualVM
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [String]$Home = 'C:\Program Files\Java\jdk1.8.0_271'
    )
    $bin = Join-Path -Path $Home -ChildPath 'bin'
    Write-Host $bin
    $jvisualvm = Join-Path -Path $bin -ChildPath 'jvisualvm.exe'
    Start-Process -FilePath $jvisualvm
}