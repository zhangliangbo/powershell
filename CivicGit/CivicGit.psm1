function New-ShaBranch
{
    param(
        $Push
    )
    $branch = Invoke-Command -ScriptBlock { git symbolic-ref --short head }
    $sha1 = Invoke-Command -ScriptBlock { git rev-parse --short head }
    $newName = $branch + '-' + $sha1
    Invoke-Command -ScriptBlock { git branch $newName }
    Invoke-Command -ScriptBlock { git push --set-upstream origin $newName }
    Write-Host $newName
}