function New-ShaBranch
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [Boolean]$Push = $true
    )
    $branch = Invoke-Command -ScriptBlock { git symbolic-ref --short head }
    $sha1 = Invoke-Command -ScriptBlock { git rev-parse --short head }
    $newName = $branch + '-' + $sha1
    Invoke-Command -ScriptBlock { git branch $newName } -ErrorAction Stop
    if ($Push)
    {
        Invoke-Command -ScriptBlock { git push --set-upstream origin $newName } -ErrorAction Stop
    }
    Write-Host $newName
}


function Update-Branch
{
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [String]$Branch = 'qa'
    )
    $cur = Invoke-Command -ScriptBlock { git symbolic-ref --short HEAD }
    Invoke-Command -ScriptBlock { git checkout $Branch } -ErrorAction Stop
    Invoke-Command -ScriptBlock { git pull --ff-only } -ErrorAction Stop
    Invoke-Command -ScriptBlock { git checkout $cur } -ErrorAction Stop
}