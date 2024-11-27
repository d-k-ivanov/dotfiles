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
    Exit
}

function Get-JavaList
{
    $javaBases = @(
        'C:\Program Files\Android\jdk\jdk-8.0.302.8-hotspot\'
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
            $((Get-ChildItem $javaBase -filter "*j*" -Directory).FullName | ForEach-Object { $javas += $_ })
        }
    }

    $javasValidated = @()
    foreach ($java in $javas)
    {
        if (Test-Path $java)
        {
            $javasValidated  += $java
        }
    }

    return $javasValidated
}

function Find-Java
{
    $coffee_cups = Get-JavaList

    Write-Host "List of Java Kits on this PC:"
    foreach ($cup in $coffee_cups)
    {
        $javaBin = (Join-Path $cup "bin/java.exe")

        if (Test-Path $javaBin)
        {
            $javaVersion = $($(& "${javaBin}"-version 2>&1 | Select-Object -first 1) -replace '\D+(\d+.\d+.\d+)\D.*','$1')
            Write-Host "- [${javaVersion}]`t-> $cup"
        }
    }
}


function Set-Java
{
    $ChoosenJavaVersion = Select-From-List $(Get-JavaList) "Java path"
    [Environment]::SetEnvironmentVariable("JAVA_HOME", ${ChoosenJavaVersion}, "Machine")
    $env:JAVA_HOME = ${ChoosenJavaVersion}
    $env:PATH = "${env:JAVA_HOME}\bin;${env:PATH}"
}

function Use-Java
{
    $ChoosenJavaVersion = Select-From-List $(Get-JavaList) "Java path"
    $env:JAVA_HOME = ${ChoosenJavaVersion}
    $env:PATH = "${env:JAVA_HOME}\bin;${env:PATH}"
}
