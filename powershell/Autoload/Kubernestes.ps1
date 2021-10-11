<#
.SYNOPSIS
Kubernetes scripts.

.DESCRIPTION
Kubernetes scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

#foreach ($kube_config in Get-ChildItem $Env:USERPROFILE\\.kube -Filter '*.yaml')
#{
#    $Env:KUBECONFIG += $kube_config.FullName -join ";"
#}

${function:kdev}        = { kubectl --context dev               @args }
${function:kstage}      = { kubectl --context stage             @args }
${function:kprod}       = { kubectl --context prod              @args }
${function:kdevcn}      = { kubectl --context devcn             @args }
${function:kstagecn}    = { kubectl --context stagecn           @args }
${function:kprodcn}     = { kubectl --context prodcn            @args }
${function:kdocker}     = { kubectl --context docker-desktop    @args }

${function:hdev}        = { helm --kube-context dev             @args }
${function:hstage}      = { helm --kube-context stage           @args }
${function:hprod}       = { helm --kube-context prod            @args }
${function:hdevcn}      = { helm --kube-context devcn           @args }
${function:hstagecn}    = { helm --kube-context stagecn         @args }
${function:hprodcn}     = { helm --kube-context prodcn          @args }
${function:hdocker}     = { helm --kube-context docker-desktop  @args }

${function:kdev_proxy}          = { kdev     proxy --port=10001 }
${function:kstage_proxy}        = { kstage   proxy --port=10001 }
${function:kprod_proxy}         = { kprod    proxy --port=10001 }
${function:kdevcn_proxy}        = { kdevcn   proxy --port=10001 }
${function:kstagecn_proxy}      = { kstagecn proxy --port=10001 }
${function:kprodcn_proxy}       = { kprodcn  proxy --port=10001 }
${function:kdocker_proxy}       = { kdocker  proxy --port=10001 }

${function:kdev_port_fwd}       = { kdev     port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kstage_port_fwd}     = { kstage   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprod_port_fwd}      = { kprod    port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdevcn_port_fwd}     = { kdevcn   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kstagecn_port_fwd}   = { kstagecn port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprodcn_port_fwd}    = { kprodcn  port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdocker_port_fwd}    = { kdocker  port-forward --v=6 --address 0.0.0.0 service/@args }

${function:kdev_consul}         = { kdev     port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kstage_consul}       = { kstage   port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprod_consul}        = { kprod    port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdevcn_consul}       = { kdevcn   port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kstagecn_consul}     = { kstagecn port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprodcn_consul}      = { kprodcn  port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdocker_consul}      = { kdocker  port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }

${function:kdev_rabbit}         = { kdev     port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kstage_rabbit}       = { kstage   port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprod_rabbit}        = { kprod    port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kdevcn_rabbit}       = { kdevcn   port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kstagecn_rabbit}     = { kstagecn port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprodcn_rabbit}      = { kprodcn  port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kdocker_rabbit}      = { kdocker  port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }

${function:kdev_exec}           = { kdev     exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstage_exec}         = { kstage   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprod_exec}          = { kprod    exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevcn_exec}         = { kdevcn   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstagecn_exec}       = { kstagecn exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprodcn_exec}        = { kprodcn  exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdocker_exec}        = { kdocker  exec -it @args "--" sh -c "(bash || ash || sh)" }

function kdev_admin_token()
{
    kdev -n kube-system get secret `
    $((kdev -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kstage_admin_token()
{
    kstage -n kube-system get secret `
    $((kstage -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kprod_admin_token()
{
    kprod -n kube-system get secret `
    $((kprod -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kdevcn_admin_token()
{
    kdevch -n kube-system get secret `
    $((kdevch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kstagecn_admin_token()
{
    kstagech -n kube-system get secret `
    $((kstagech -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kprodcn_admin_token()
{
    kprodcn -n kube-system get secret `
    $((kprodcn -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kdocker_admin_token()
{
    kprodcn -n kube-system get secret `
    $((kprodcn -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kimages()
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [string] $Environment = "prod",
        [string] $Namespace = "default"
    )
    Write-Host "Images in ${Environment}/${Namespace}:"
    $cmd = "k${Environment} -n ${Namespace} get deployments -o json"
    # $Deployments = $(& "k${Environment} -n ${Namespace} get deployments -o json | jq -r '[.items[].metadata.name]'" | ConvertFrom-Json)
    # (kprod -n default get deployments -o json | ConvertFrom-Json).items | %{ $_.metadata.name}
    $Deployments = @()
    (Invoke-Expression $cmd | ConvertFrom-Json ).items | %{ $Deployments += $_.metadata.name}
    $Header = @("Name","Image","Tag")
    $ServicesTable = @()
    foreach ($deployment in $Deployments)
    {
        $cmd = "k${Environment} -n ${Namespace} get deployments/${deployment} -o jsonpath=`"{.spec.template.spec.containers[*].image}`""
        # $cmd = "k${Environment} -n ${Namespace} get deployments/clinicapp-service -o jsonpath=`"{.spec.template.spec.containers[*].image}`""
        $images = (Invoke-Expression $cmd).Split(" ")
        foreach ($image in $images)
        {
            $image = $image.Split(":")
            # "{0} {1,90}{2,50}" -f "${deployment}", $image[0], $image[1]
            # Write-Host "${deployment} "             -ForegroundColor Yellow -NoNewline
            # Write-Host "$('{0,90} ' -f $image[0])"  -ForegroundColor Green  -NoNewline
            # Write-Host "$('{0} ' -f $image[0])"  -ForegroundColor Green  -NoNewline
            # Write-Host "$('{0,50}'  -f $image[1])"  -ForegroundColor Red

            $Row = New-Object -TypeName PSObject
            $Row | Add-Member -Type NoteProperty -Name $Header[0] -Value $deployment
            $Row | Add-Member -Type NoteProperty -Name $Header[1] -Value $image[0]
            $Row | Add-Member -Type NoteProperty -Name $Header[2] -Value $image[1]
            $ServicesTable += $Row
        }
    }
    return $ServicesTable
}

function kimages_fast()
{
    [CmdletBinding()]
    [OutputType([System.Object[]])]
    param
    (
        [string] $Environment = "prod",
        [string] $Namespace = "default"
    )
    Write-Host "Images in ${Environment}/${Namespace}:"
    $Header = @("Name","Image","Tag")
    $ServicesTable = @()

    $cmd = "k${Environment} -n ${Namespace} get deployments -o=jsonpath='{range .items[*]}{.metadata.name}:{range .spec.template.spec.containers[*]}{.image} {end}{end}'"
    # $cmd = "k${Environment} -n ${Namespace} -o=jsonpath=`"{range .items[*]}{'\n'}{.metadata.name}{':\t'}{range .spec.template.spec.containers[*]}{.image}{', '}{end}{end}`""
    $images = (Invoke-Expression $cmd).Split(" ")
    $PreviousDeployment = ""
    foreach ($image in $images)
    {
        $image  = $image.Split(":")
        $Row    = New-Object -TypeName PSObject
        if ($image.Count -eq 1)
        {
            continue
        }
        elseif ($image.Count -eq 2)
        {
            $Row | Add-Member -Type NoteProperty -Name $Header[0] -Value $PreviousDeployment
            $Row | Add-Member -Type NoteProperty -Name $Header[1] -Value $image[0]
            $Row | Add-Member -Type NoteProperty -Name $Header[2] -Value $image[1]
        }
        else
        {
            $PreviousDeployment = $image[0]
            $Row | Add-Member -Type NoteProperty -Name $Header[0] -Value $image[0]
            $Row | Add-Member -Type NoteProperty -Name $Header[1] -Value $image[1]
            $Row | Add-Member -Type NoteProperty -Name $Header[2] -Value $image[2]
        }
        # Write-Host $image -ForegroundColor Red
        # Write-Host $image.Count -ForegroundColor Green
        $ServicesTable += $Row
    }
    return $ServicesTable
}
