# 创建子分支
function New-SubBranch
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [String[]]$SubName = @('master', 'qa'),
        [Boolean]$Push = $true
    )
    $branch = Invoke-Command -ScriptBlock { git symbolic-ref --short head }
    for($i = 0; $i -lt $SubName.Length; $i++){
        $sub = $SubName.Get($i)
        $newName = $branch + '-' + $sub
        Write-Host $newName
        Invoke-Command -ScriptBlock { git branch $newName } -ErrorAction Stop
        if ($Push)
        {
            Invoke-Command -ScriptBlock { git push --set-upstream origin $newName } -ErrorAction Stop
        }
        if ($i -eq 0)
        {
            Write-Host ('checkout ' + $newName)
            Invoke-Command -ScriptBlock { git checkout $newName } -ErrorAction Stop
        }
    }
}

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

function New-HotfixBranch
{
    [CmdletBinding()]
    param(
        [ValidateNotNullOrEmpty()]
        [String]$Branch = 'master',
        [Boolean]$Push = $true
    )
    Write-Host ('>checkout ' + $Branch)
    Invoke-Command -ScriptBlock{ git checkout $Branch } -ErrorAction Stop

    $branch = Invoke-Command -ScriptBlock { git symbolic-ref --short head }
    $sha1 = Invoke-Command -ScriptBlock { git rev-parse --short head }
    $newName = 'hotfix-' + $branch + '-' + $sha1 + '-' + (Get-Date -Format 'yyyyMMdd')

    Write-Host ('>pull ' + $branch)
    Invoke-Command -ScriptBlock { git pull --ff-only } -ErrorAction Stop

    Write-Host ('>create and checkout ' + $newName)
    Invoke-Command -ScriptBlock { git checkout -b $newName } -ErrorAction Stop

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
    Write-Host ('checkout ' + $Branch)
    Invoke-Command -ScriptBlock{ git checkout $Branch } -ErrorAction Stop
    Write-Host ('pull ' + $Branch)
    Invoke-Command -ScriptBlock { git pull --ff-only } -ErrorAction Stop
    Write-Host ('checkout ' + $cur)
    Invoke-Command -ScriptBlock { git checkout $cur } -ErrorAction Stop
}

function Remove-LocalBranch
{
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [String]$Branch
    )
    $list = Invoke-Command -ScriptBlock { git branch --list $Branch } -ErrorAction Stop
    Write-Host ('branch list is ' + $list)
}