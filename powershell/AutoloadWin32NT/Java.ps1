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
    ${local:javaBases} = @(
        'C:\Program Files\Amazon Corretto'
        'C:\Program Files\Eclipse Adoptium\'
        'C:\Program Files\Java\'
        'C:\Program Files\Microsoft\'
        'C:\Program Files\OpenJDK\'
        'C:\Program Files (x86)\Java\'
        'C:\Program Files (x86)\OpenJDK\'
    )

    ${local:javaBasesScoop} = @(
        # Corretto
        "${Env:USERPROFILE}\scoop\apps\corretto-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto-lts-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto15-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto18-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto19-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto20-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto21-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto22-jdk\"
        "${Env:USERPROFILE}\scoop\apps\corretto23-jdk\"

        # Dragonwell
        "${Env:USERPROFILE}\scoop\apps\dragonwell8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\dragonwell8-jdk-extended\"
        "${Env:USERPROFILE}\scoop\apps\dragonwell11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\dragonwell11-jdk-extended\"
        "${Env:USERPROFILE}\scoop\apps\dragonwell17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\dragonwell21-jdk\"

        # GraalVM
        "${Env:USERPROFILE}\scoop\apps\graalvm\"
        "${Env:USERPROFILE}\scoop\apps\graalvm-jdk11\"
        "${Env:USERPROFILE}\scoop\apps\graalvm-jdk17\"
        "${Env:USERPROFILE}\scoop\apps\graalvm-oracle-jdk\"
        "${Env:USERPROFILE}\scoop\apps\graalvm-oracle-17jdk\"
        "${Env:USERPROFILE}\scoop\apps\graalvm-oracle-21jdk\"
        "${Env:USERPROFILE}\scoop\apps\graalvm19\"
        "${Env:USERPROFILE}\scoop\apps\graalvm19-jdk11\"
        "${Env:USERPROFILE}\scoop\apps\graalvm19-jdk8\"
        "${Env:USERPROFILE}\scoop\apps\graalvm20\"
        "${Env:USERPROFILE}\scoop\apps\graalvm20-jdk11\"
        "${Env:USERPROFILE}\scoop\apps\graalvm20-jdk8\"
        "${Env:USERPROFILE}\scoop\apps\graalvm21\"
        "${Env:USERPROFILE}\scoop\apps\graalvm21-jdk11\"
        "${Env:USERPROFILE}\scoop\apps\graalvm21-jdk17\"
        "${Env:USERPROFILE}\scoop\apps\graalvm21-jdk21\"
        "${Env:USERPROFILE}\scoop\apps\graalvm22\"
        "${Env:USERPROFILE}\scoop\apps\graalvm22-jdk11\"
        "${Env:USERPROFILE}\scoop\apps\graalvm22-jdk17\"

        # IntelliJ
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr11\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr11-jcef\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr11-sdk-jcef\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr11-sdk\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr17\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr17-jcef\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr17-sdk-jcef\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr17-sdk\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr21\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr21-jcef\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr21-sdk-jcef\"
        "${Env:USERPROFILE}\scoop\apps\intellij-jbr21-sdk\"

        # Liberica
        "${Env:USERPROFILE}\scoop\apps\liberica-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica-lite-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica-lts-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica-full-lts-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica-lite-lts-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica8-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica11-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica11-lite-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica12-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica12-lite-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica13-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica13-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica13-lite-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica14-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica14-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica14-lite-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica15-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica15-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica15-lite-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica16-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica16-lite-jdkl\"
        "${Env:USERPROFILE}\scoop\apps\liberica17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica17-full-jdk\"
        "${Env:USERPROFILE}\scoop\apps\liberica17-lite-jdk\"

        # Microsoft
        "${Env:USERPROFILE}\scoop\apps\microsoft-jdk\"
        "${Env:USERPROFILE}\scoop\apps\microsoft-lts-jdk\"
        "${Env:USERPROFILE}\scoop\apps\microsoft11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\microsoft16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\microsoft17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\microsoft21-jdk\"

        # OpenJDK
        "${Env:USERPROFILE}\scoop\apps\openjdk\"
        "${Env:USERPROFILE}\scoop\apps\openjdk7-unofficial\"
        "${Env:USERPROFILE}\scoop\apps\openjdk8-redhat\"
        "${Env:USERPROFILE}\scoop\apps\openjdk9\"
        "${Env:USERPROFILE}\scoop\apps\openjdk10\"
        "${Env:USERPROFILE}\scoop\apps\openjdk11\"
        "${Env:USERPROFILE}\scoop\apps\openjdk12\"
        "${Env:USERPROFILE}\scoop\apps\openjdk13\"
        "${Env:USERPROFILE}\scoop\apps\openjdk14\"
        "${Env:USERPROFILE}\scoop\apps\openjdk15\"
        "${Env:USERPROFILE}\scoop\apps\openjdk16\"
        "${Env:USERPROFILE}\scoop\apps\openjdk17\"
        "${Env:USERPROFILE}\scoop\apps\openjdk18\"
        "${Env:USERPROFILE}\scoop\apps\openjdk19\"
        "${Env:USERPROFILE}\scoop\apps\openjdk20\"
        "${Env:USERPROFILE}\scoop\apps\openjdk21\"
        "${Env:USERPROFILE}\scoop\apps\openjdk22\"
        "${Env:USERPROFILE}\scoop\apps\openjdk23\"
        "${Env:USERPROFILE}\scoop\apps\openjdk24\"

        # Oracle JDK
        "${Env:USERPROFILE}\scoop\apps\oraclejdk\"
        "${Env:USERPROFILE}\scoop\apps\oraclejdk-lts\"

        # SAP
        "${Env:USERPROFILE}\scoop\apps\sapmachine-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine-lts-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine12-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine13-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine14-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine15-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\sapmachine18-jdk\"

        # Semeru
        "${Env:USERPROFILE}\scoop\apps\semeru-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru18-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru19-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru20-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru21-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru22-jdk\"
        "${Env:USERPROFILE}\scoop\apps\semeru23-jdk\"

        # Temurin
        "${Env:USERPROFILE}\scoop\apps\temurin-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin18-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin19-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin20-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin21-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin22-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin23-jdk\"
        "${Env:USERPROFILE}\scoop\apps\temurin24-jdk\"

        # Zulu
        "${Env:USERPROFILE}\scoop\apps\zulu-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu7-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu9-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu10-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu12-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu13-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu14-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu15-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu21-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulu22-jdk\"

        # Zulu FX
        "${Env:USERPROFILE}\scoop\apps\zulufx-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx8-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx11-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx13-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx14-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx15-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx16-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx17-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx21-jdk\"
        "${Env:USERPROFILE}\scoop\apps\zulufx22-jdk\"
    )

    $javas = @()
    foreach ($javaBase in $javaBases)
    {
        if (Test-Path $javaBase)
        {
            $((Get-ChildItem $javaBase -Filter "*jdk*" -Directory).FullName | ForEach-Object { $javas += $_ })
        }
    }

    foreach ($javaBase in $javaBasesScoop)
    {
        if (Test-Path $javaBase)
        {
            $((Get-ChildItem $javaBase -Directory | Where-Object { $_.Name -ne "current" }).FullName | ForEach-Object { $javas += $_ })
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
    ${local:javaInfoList} = @()

    foreach ($cup in $coffee_cups)
    {
        $javaBin = (Join-Path $cup "bin/java.exe")

        if (Test-Path $javaBin)
        {
            $javaVersion = $($(& "${javaBin}"-version 2>&1 | Select-Object -First 1) -replace '\D+(\d+.\d+.\d+)\D.*', '$1')
            $javaInfoList += [PSCustomObject]@{
                Version = [System.Version]$javaVersion
                Path    = $cup
            }
        }
    }

    # ${local:sortedJavaList} = $javaInfoList | Sort-Object Version

    Write-Host "List of Java Kits on this PC:"
    foreach ($javaInfo in $javaInfoList)
    {
        Write-Host "- [$($javaInfo.Version)]`t-> $($javaInfo.Path)"
    }
}

function java-select-from-list
{
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

            if ($cup -like "*\scoop\apps\*")
            {
                $scoopAppName = Split-Path $cup -Parent | Split-Path -Leaf
                switch -Regex ($scoopAppName)
                {
                    '^corretto.*jdk$' { $javaDistribution = "Corretto" }
                    '^dragonwell.*jdk.*$' { $javaDistribution = "Dragonwell" }
                    '^graalvm.*$' { $javaDistribution = "GraalVM" }
                    '^intellij-jbr.*$' { $javaDistribution = "IntelliJ JBR" }
                    '^liberica.*jdk$' { $javaDistribution = "Liberica" }
                    '^microsoft.*jdk$' { $javaDistribution = "Microsoft" }
                    '^openjdk.*$' { $javaDistribution = "OpenJDK" }
                    '^oraclejdk.*$' { $javaDistribution = "Oracle" }
                    '^sapmachine.*jdk$' { $javaDistribution = "SAPMachine" }
                    '^semeru.*jdk$' { $javaDistribution = "Semeru" }
                    '^temurin.*jdk$' { $javaDistribution = "Temurin" }
                    '^zulu.*jdk$' { $javaDistribution = "Zulu" }
                    '^zulufx.*jdk$' { $javaDistribution = "Zulu FX" }
                    default { $javaDistribution = $scoopAppName }
                }
            }
            elseif ($cup -like "*Program Files*")
            {
                $parentPath = Split-Path $cup -Parent
                switch ($parentPath)
                {
                    { $_ -like "*Amazon Corretto*" } { $javaDistribution = "Corretto" }
                    { $_ -like "*Eclipse Adoptium*" } { $javaDistribution = "Temurin" }
                    { $_ -like "*Java*" } { $javaDistribution = "Oracle" }
                    { $_ -like "*Microsoft*" } { $javaDistribution = "Microsoft" }
                    { $_ -like "*OpenJDK*" } { $javaDistribution = "OpenJDK" }
                    default { $javaDistribution = Split-Path $parentPath -Leaf }
                }
            }

            $validatedVersions += "${javaDistribution} ${javaVersion}"
        }
    }

    return Select-From-List $validatedPaths "Java Version" $validatedVersions
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
    ${local:choosenJavaVersion} = java-select-from-list

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
    ${local:choosenJavaVersion} = java-select-from-list

    $env:JAVA_HOME = ${choosenJavaVersion}
    ${local:javaBinPath} = Join-Path ${choosenJavaVersion} "bin"
    $env:PATH = "${javaBinPath};${env:PATH}"
}
