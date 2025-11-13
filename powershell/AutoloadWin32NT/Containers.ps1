<#
.SYNOPSIS
Container shortcuts

.DESCRIPTION
Container shortcuts
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function Get-ContainerEngineList
{
    $ContainerEngines = @(
        'C:\PROGRA~1\Docker\Docker\resources\bin'
        'C:\PROGRA~1\Rancher Desktop\resources\resources\win32\bin'
        'C:\PROGRA~1\RedHat\Podman\'
        'C:\tools\docker'
    )
    return $ContainerEngines
}

function List-ContainerEngines
{
    $ContainerEngines = Get-ContainerEngineList

    Write-Host "List of Container Engines on this PC:"
    foreach ($engine in $ContainerEngines)
    {
        if (Test-Path $engine)
        {
            Write-Host " -> $engine"
        }
    }
}

function Set-ContainerEngine
{
    $ContainerEngines = Get-ContainerEngineList
    $ValidatedEngines = @()
    foreach ($engine in $ContainerEngines)
    {
        if (Test-Path $engine)
        {
            $ValidatedEngines += $engine
        }
    }
    $ChoosenVersion = Select-From-List $ValidatedEngines "Container Engines"
    [Environment]::SetEnvironmentVariable("CONTAINER_ENGINE_PATH", $ChoosenVersion, "Machine")
    Set-Item -Path Env:CONTAINER_ENGINE_PATH -Value "$ChoosenVersion"
}

function Unset-ContainerEngine
{
    [Environment]::SetEnvironmentVariable("CONTAINER_ENGINE_PATH", $null, "Machine")
    Remove-Item -Path Env:CONTAINER_ENGINE_PATH -ErrorAction SilentlyContinue
}

# Docker
if (Get-Command docker.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:di}    = { docker images }
    ${function:dc}    = { docker ps -a }
    ${function:dcle}  = { docker rm $(docker ps -aqf status=exited) }
    ${function:dclc}  = { docker rm $(docker ps -aqf status=created) }
    ${function:dcli}  = { docker rmi $(docker images -q) }
    ${function:dclif} = { docker rmi -f $(docker images -q) }
    ${function:dcla}  = {
        docker rm $(docker ps -aqf status=exited)
        docker rmi $(docker images -qf dangling=true)
        docker volume rm $(docker volume ls -qf dangling=true)
    }

    ${function:dsprune}  = { docker system prune }

    # Run docker container in interactive mode
    ${function:dri}         = { docker run --rm -it @args }
    ${function:dri_entry}   = { docker run --rm -it --entrypoint /bin/sh @args }
    ${function:dri_pwd}     = { docker run --rm -it -v ${PWD}:/project @args }
    ${function:dri_pwd_ray} = { docker run --rm -it -v ${PWD}:/project -p 6379:6379 -p 8000:8000 -p 8076:8076 -p 8265:8265 -p 10001:10001 @args }

    # Rewrite entry point to shell
    ${function:desh}        = { docker run --rm -it --entrypoint /bin/sh @args }

    # inspect docker images
    ${function:dc_trace_cmd} = {
        ${parent}= $(docker inspect -f '{{ .Parent }}' $args[0])
        [int]${level}=$args[1]
        Write-Host ${level}: $(docker inspect -f '{{ .ContainerConfig.Cmd }}' $args[0])
        ${level}=${level}+1
        if (${parent})
        {
            Write-Host ${level}: ${parent}
            dc_trace_cmd ${parent} ${level}
        }
    }
}

if (Get-Command $Env:ProgramFiles\Docker\Docker\DockerCli.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:dokkaSD}              = { & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon }
    ${function:docker_switch_daemon} = { & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon }
    ${function:docker_switch_engine} = { & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon }
}

# Podman
if (Get-Command podman.exe -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:pi}    = { podman images }
    ${function:pc}    = { podman ps -a }
    ${function:pcle}  = { podman rm $(podman ps -aqf status=exited) }
    ${function:pclc}  = { podman rm $(podman ps -aqf status=created) }
    ${function:pcli}  = { podman rmi $(podman images -q) }
    ${function:pclif} = { podman rmi -f $(podman images -q) }
    ${function:pcla}  = {
        podman rm $(podman ps -aqf status=exited)
        podman rmi $(podman images -qf dangling=true)
        podman volume rm $(podman volume ls -qf dangling=true)
    }

    ${function:psprune}  = { podman system prune }

    # Run podman container in interactive mode
    ${function:pri}         = { podman run --rm -it @args }
    ${function:pri_entry}   = { podman run --rm -it --entrypoint /bin/sh @args }
    ${function:pri_pwd}     = { podman run --rm -it -v ${PWD}:/project @args }
    ${function:pri_pwd_ray} = { podman run --rm -it -v ${PWD}:/project -p 6379:6379 -p 8000:8000 -p 8076:8076 -p 8265:8265 -p 10001:10001 @args }

    # Rewrite entry point to shell
    ${function:pesh}        = { podman run --rm -it --entrypoint /bin/sh @args }

    # inspect podman images
    ${function:pc_trace_cmd} = {
        ${parent}= $(podman inspect -f '{{ .Parent }}' $args[0])
        [int]${level}=$args[1]
        Write-Host ${level}: $(podman inspect -f '{{ .ContainerConfig.Cmd }}' $args[0])
        ${level}=${level}+1
        if (${parent})
        {
            Write-Host ${level}: ${parent}
            pc_trace_cmd ${parent} ${level}
        }
    }
}
