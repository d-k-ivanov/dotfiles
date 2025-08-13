<#
.SYNOPSIS
Java scripts.

.DESCRIPTION
Java scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    exit
}

function java-list-paths
{
    $javaBases = @(
        'C:\Program Files\Amazon Corretto'
        'C:\Program Files\Eclipse Adoptium\'
        'C:\Program Files\Java\'
        'C:\Program Files\Microsoft\'
        'C:\Program Files\OpenJDK\'
        'C:\Program Files (x86)\Java\'
        'C:\Program Files (x86)\OpenJDK\'
    )

    $javas = @()
    foreach ($javaBase in $javaBases)
    {
        if (Test-Path $javaBase)
        {
            $((Get-ChildItem $javaBase -Filter "*j*" -Directory).FullName | ForEach-Object { $javas += $_ })
        }
    }

    $javasValidated = @()
    foreach ($java in $javas)
    {
        if (Test-Path $java)
        {
            $javasValidated += $java
        }
    }

    return $javasValidated
}

function java-list
{
    ${local:coffee_cups} = java-list-paths

    Write-Host "List of Java Kits on this PC:"
    foreach ($cup in $coffee_cups)
    {
        $javaBin = (Join-Path $cup "bin/java.exe")

        if (Test-Path $javaBin)
        {
            $javaVersion = $($(& "${javaBin}"-version 2>&1 | Select-Object -First 1) -replace '\D+(\d+.\d+.\d+)\D.*', '$1')
            Write-Host "- [${javaVersion}]`t-> $cup"
        }
    }
}

function java-unset
{
    [Environment]::SetEnvironmentVariable("JAVA_HOME", [NullString]::Value, "User")
    [Environment]::SetEnvironmentVariable("JAVA_HOME", [NullString]::Value, "Machine")

    if ($Env:JAVA_HOME)
    {
        ${local:javaBinPath} = Join-Path $Env:JAVA_HOME "bin"

        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'Machine')
        $path = $path -replace [regex]::Escape("${javaBinPath};"), ''
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'Machine')

        $path = [System.Environment]::GetEnvironmentVariable('PATH', 'User')
        $path = $path -replace [regex]::Escape("${javaBinPath};"), ''
        [System.Environment]::SetEnvironmentVariable('PATH', $path, 'User')

        $Env:PATH = $Env:PATH -replace [regex]::Escape("${javaBinPath};"), ''

        Remove-Item Env:JAVA_HOME
    }
}

function java-set
{
    java-unset
    ${local:coffee_cups} = java-list-paths
    ${local:validatedPaths} = @()
    ${local:validatedVersions} = @()

    foreach ($cup in $coffee_cups)
    {
        $javaBin = (Join-Path $cup "bin/java.exe")

        if (Test-Path $javaBin)
        {
            $validatedPaths += $cup
            $javaVersion = $($(& "${javaBin}"-version 2>&1 | Select-Object -First 1) -replace '\D+(\d+.\d+.\d+)\D.*', '$1')
            $javaDistribution = Split-Path (Split-Path $cup -Parent) -Leaf
            if ($javaDistribution -eq "Java")
            {
                $javaDistribution = "Oracle Java"
            }
            $validatedVersions += "${javaDistribution} ${javaVersion}"
        }
    }

    ${local:choosenJavaVersion} = Select-From-List $validatedPaths "Java Version" $validatedVersions

    [Environment]::SetEnvironmentVariable("JAVA_HOME", ${choosenJavaVersion}, "Machine")
    $env:JAVA_HOME = ${choosenJavaVersion}

    ${local:javaBinPath} = Join-Path ${choosenJavaVersion} "bin"
    $env:PATH = "${javaBinPath};${env:PATH}"
}


function java-disable
{
    if ($Env:JAVA_HOME)
    {
        ${local:javaBinPath} = Join-Path $Env:JAVA_HOME "bin"
        $Env:PATH = $Env:PATH -replace [regex]::Escape("${javaBinPath};"), ''
        Remove-Item Env:JAVA_HOME
    }
}

function java-enable
{
    java-disable
    ${local:coffee_cups} = java-list-paths
    ${local:validatedPaths} = @()
    ${local:validatedVersions} = @()

    foreach ($cup in $coffee_cups)
    {
        $javaBin = (Join-Path $cup "bin/java.exe")

        if (Test-Path $javaBin)
        {
            $validatedPaths += $cup
            $javaVersion = $($(& "${javaBin}"-version 2>&1 | Select-Object -First 1) -replace '\D+(\d+.\d+.\d+)\D.*', '$1')
            $javaDistribution = Split-Path (Split-Path $cup -Parent) -Leaf
            if ($javaDistribution -eq "Java")
            {
                $javaDistribution = "Oracle Java"
            }
            $validatedVersions += "${javaDistribution} ${javaVersion}"
        }
    }

    ${local:choosenJavaVersion} = Select-From-List $validatedPaths "Java Version" $validatedVersions

    $env:JAVA_HOME = ${choosenJavaVersion}
    ${local:javaBinPath} = Join-Path ${choosenJavaVersion} "bin"
    $env:PATH = "${javaBinPath};${env:PATH}"
}
