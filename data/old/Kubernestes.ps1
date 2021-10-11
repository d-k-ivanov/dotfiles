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

${function:kdev}            = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev     @args }
${function:kstage}          = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage   @args }
${function:kprod}           = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod    @args }
${function:kdevcn}          = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devcn   @args }
${function:kstagecn}        = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagecn @args }
${function:kprodcn}         = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  @args }
${function:kws}             = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\ws      @args }

${function:hdev}            = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\dev     @args }
${function:hstage}          = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\stage   @args }
${function:hprod}           = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\prod    @args }
${function:hdevcn}          = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\devcn   @args }
${function:hstagecn}        = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\stagecn @args }
${function:hprodcn}         = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  @args }
${function:hws}             = { helm    --kubeconfig ${Env:USERPROFILE}\.kube\ws      @args }

${function:kdev_proxy}      = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev     proxy --port=10001 }
${function:kstage_proxy}    = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage   proxy --port=10001 }
${function:kprod_proxy}     = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod    proxy --port=10001 }
${function:kdevcn_proxy}    = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devcn   proxy --port=10001 }
${function:kstagecn_proxy}  = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagecn proxy --port=10001 }
${function:kprodcn_proxy}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  proxy --port=10001 }
${function:kws_proxy}       = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\ws      proxy --port=10001 }

${function:kdev_port_fwd}     = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev     port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kstage_port_fwd}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprod_port_fwd}    = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod    port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdevcn_port_fwd}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devcn   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kstagecn_port_fwd} = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagecn port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprodcn_port_fwd}  = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kws_port_fwd}      = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\ws      port-forward --v=6 --address 0.0.0.0 service/@args }

${function:kdev_consul}     = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev     port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kstage_consul}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage   port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprod_consul}    = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod    port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdevcn_consul}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devcn   port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kstagecn_consul} = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagecn port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprodcn_consul}  = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kws_consul}      = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\ws      port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }

${function:kdev_rabbit}     = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev     port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kstage_rabbit}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage   port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprod_rabbit}    = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod    port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kdevcn_rabbit}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devcn   port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kstagecn_rabbit} = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagecn port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprodcn_rabbit}  = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kws_rabbit}      = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\ws      port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }

${function:kdev_exec}       = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev     exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstage_exec}     = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprod_exec}      = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod    exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevcn_exec}     = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devcn   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstagecn_exec}   = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagecn exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprodcn_exec}    = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn  exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kws_exec}        = { kubectl --kubeconfig ${Env:USERPROFILE}\.kube\ws      exec -it @args "--" sh -c "(bash || ash || sh)" }

function kdev_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\dev -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kstage_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stage -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kprod_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prod -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kdevcn_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devch -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\devch -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kstagecn_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagech -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\stagech -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kprodcn_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn -o yaml -n kube-system get serviceaccounts admin-user `
    | ConvertFrom-Yaml).secrets.name) -o jsonpath="{.data.token}" `
    | ConvertFrom-Base64
}

function kws_admin_token()
{
    kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn -n kube-system get secret `
    $((kubectl --kubeconfig ${Env:USERPROFILE}\.kube\prodcn -o yaml -n kube-system get serviceaccounts admin-user `
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
