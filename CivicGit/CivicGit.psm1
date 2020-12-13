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