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

# Local Environment
# ==================================================================================================
${function:kdocker}             = { kubectl  --context      docker-desktop @args }
${function:hdocker}             = { helm     --kube-context docker-desktop @args }
${function:kdocker_proxy}       = { kdocker  proxy --port=10001 }
${function:kdocker_port_fwd}    = { kdocker  port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdocker_consul}      = { kdocker  port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdocker_rabbit}      = { kdocker  port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kdocker_exec}        = { kdocker  exec -it @args "--" sh -c "(bash || ash || sh)" }

# Dev Environment
# ==================================================================================================
# ${function:kdev}        = { kubectl --context dev   @args }
# ${function:kdevcn}      = { kubectl --context devcn @args }
# ${function:kdeveu}      = { kubectl --context deveu @args }
# ${function:kdevus}      = { kubectl --context devus @args }

# ${function:hdev}        = { helm --kube-context dev   @args }
# ${function:hdevcn}      = { helm --kube-context devcn @args }
# ${function:hdeveu}      = { helm --kube-context deveu @args }
# ${function:hdevus}      = { helm --kube-context devus @args }

${function:kdev_proxy}          = { kdev   proxy --port=10001 }
${function:kdevcn_proxy}        = { kdevcn proxy --port=10001 }
${function:kdeveu_proxy}        = { kdeveu proxy --port=10001 }
${function:kdevus_proxy}        = { kdevus proxy --port=10001 }

${function:kdev_port_fwd}       = { kdev   port-forward --v=6 --address 0.0.0.0 service/$args }
${function:kdevcn_port_fwd}     = { kdevcn port-forward --v=6 --address 0.0.0.0 service/$args }
${function:kdeveu_port_fwd}     = { kdeveu port-forward --v=6 --address 0.0.0.0 service/$args }
${function:kdevus_port_fwd}     = { kdevus port-forward --v=6 --address 0.0.0.0 service/$args }

${function:kdev_consul}         = { kdev   -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }
${function:kdevcn_consul}       = { kdevcn -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }
${function:kdeveu_consul}       = { kdeveu -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }
${function:kdevus_consul}       = { kdevus -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }

${function:kdev_rabbit}         = { kdev   -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }
${function:kdevcn_rabbit}       = { kdevcn -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }
${function:kdeveu_rabbit}       = { kdeveu -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }
${function:kdevus_rabbit}       = { kdevus -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }

${function:kdev_exec}           = { kdev   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevcn_exec}         = { kdevcn exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdeveu_exec}         = { kdeveu exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevus_exec}         = { kdevus exec -it @args "--" sh -c "(bash || ash || sh)" }

# DevOps Environment
# ==================================================================================================
# ${function:kdevops}     = { kubectl --context devops   @args }
# ${function:kdevopscn}   = { kubectl --context devopscn @args }
# ${function:kdevopseu}   = { kubectl --context devopseu @args }
# ${function:kdevopsus}   = { kubectl --context devopsus @args }

# ${function:hdevops}     = { helm --kube-context devops   @args }
# ${function:hdevopscn}   = { helm --kube-context devopscn @args }
# ${function:hdevopseu}   = { helm --kube-context devopseu @args }
# ${function:hdevopsus}   = { helm --kube-context devopsus @args }

${function:kdevops_proxy}       = { kdevops   proxy --port=10001 }
${function:kdevopscn_proxy}     = { kdevopscn proxy --port=10001 }
${function:kdevopseu_proxy}     = { kdevopseu proxy --port=10001 }
${function:kdevopsus_proxy}     = { kdevopsus proxy --port=10001 }

${function:kdevops_port_fwd}    = { kdevops     port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdevopscn_port_fwd}  = { kdevopscn   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdevopseu_port_fwd}  = { kdevopseu   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kdevopsus_port_fwd}  = { kdevopsus   port-forward --v=6 --address 0.0.0.0 service/@args }

${function:kdevops_consul}      = { kdevops  port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdevopscn_consul}   = { kdevopscn port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdevopseu_consul}   = { kdevopseu port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kdevopsus_consul}   = { kdevopsus port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }

${function:kdevops_rabbit}      = { kdevops   port-forward --v=6 --address 0.0.0.0 service/rabbitmq 4369 5672 15672 15692 }
${function:kdevopscn_rabbit}    = { kdevopscn port-forward --v=6 --address 0.0.0.0 service/rabbitmq 4369 5672 15672 15692 }
${function:kdevopseu_rabbit}    = { kdevopseu port-forward --v=6 --address 0.0.0.0 service/rabbitmq 4369 5672 15672 15692 }
${function:kdevopsus_rabbit}    = { kdevopsus port-forward --v=6 --address 0.0.0.0 service/rabbitmq 4369 5672 15672 15692 }

${function:kdevops_exec}        = { kdevops   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevopscn_exec}      = { kdevopscn exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevopseu_exec}      = { kdevopseu exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kdevopsus_exec}      = { kdevopsus exec -it @args "--" sh -c "(bash || ash || sh)" }

# Stage Environment
# ==================================================================================================
# ${function:kstage}      = { kubectl --context stage   @args }
# ${function:kstagecn}    = { kubectl --context stagecn @args }
# ${function:kstageeu}    = { kubectl --context stageeu @args }
# ${function:kstageus}    = { kubectl --context stageus @args }

# ${function:hstage}      = { helm --kube-context stage   @args }
# ${function:hstagecn}    = { helm --kube-context stagecn @args }
# ${function:hstageeu}    = { helm --kube-context stageeu @args }
# ${function:hstageus}    = { helm --kube-context stageus @args }

${function:kstage_proxy}        = { kstage    proxy --port=10001 }
${function:kstagecn_proxy}      = { kstagecn  proxy --port=10001 }
${function:kstageeu_proxy}      = { kstageeu  proxy --port=10001 }
${function:kstageus_proxy}      = { kstageus  proxy --port=10001 }

${function:kstage_port_fwd}     = { kstage   port-forward --v=6 --address 0.0.0.0 service/$args }
${function:kstagecn_port_fwd}   = { kstagecn port-forward --v=6 --address 0.0.0.0 service/$args }
${function:kstageeu_port_fwd}   = { kstageeu port-forward --v=6 --address 0.0.0.0 service/$args }
${function:kstageus_port_fwd}   = { kstageus port-forward --v=6 --address 0.0.0.0 service/$args }

${function:kstage_consul}       = { kstage   -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }
${function:kstagecn_consul}     = { kstagecn -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }
${function:kstageeu_consul}     = { kstageeu -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }
${function:kstageus_consul}     = { kstageus -n $args port-forward --v=6 --address 0.0.0.0 service/$args-consul 8300 8301 8302 8500 8600 }

${function:kstage_rabbit}       = { kstage   -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }
${function:kstagecn_rabbit}     = { kstagecn -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }
${function:kstageeu_rabbit}     = { kstageeu -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }
${function:kstageus_rabbit}     = { kstageus -n $args port-forward --v=6 --address 0.0.0.0 service/$args-rabbitmq 4369 5672 15672 15692 }

${function:kstage_exec}         = { kstage   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstagecn_exec}       = { kstagecn exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstageeu_exec}       = { kstageeu exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kstageus_exec}       = { kstageus exec -it @args "--" sh -c "(bash || ash || sh)" }

# Prod Environment
# ==================================================================================================
# ${function:kprod}       = { kubectl --context prod   @args }
# ${function:kprodcn}     = { kubectl --context prodcn @args }
# ${function:kprodeu}     = { kubectl --context prodeu @args }
# ${function:kprodus}     = { kubectl --context produs @args }

# ${function:hprod}       = { helm --kube-context prod   @args }
# ${function:hprodcn}     = { helm --kube-context prodcn @args }
# ${function:hprodeu}     = { helm --kube-context prodeu @args }
# ${function:hprodus}     = { helm --kube-context produs @args }

${function:kprod_proxy}         = { kprod   proxy --port=10001 }
${function:kprodcn_proxy}       = { kprodcn proxy --port=10001 }
${function:kprodeu_proxy}       = { kprodeu proxy --port=10001 }
${function:kprodus_proxy}       = { kprodus proxy --port=10001 }

${function:kprod_port_fwd}      = { kprod   port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprodcn_port_fwd}    = { kprodcn port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprodeu_port_fwd}    = { kprodeu port-forward --v=6 --address 0.0.0.0 service/@args }
${function:kprodus_port_fwd}    = { kprodus port-forward --v=6 --address 0.0.0.0 service/@args }

${function:kprod_consul}        = { kprod   port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprodcn_consul}      = { kprodcn port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprodeu_consul}      = { kprodeu port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }
${function:kprodus_consul}      = { kprodus port-forward --v=6 --address 0.0.0.0 service/consul 8300 8301 8302 8500 8600 }

${function:kprod_rabbit}        = { kprod   port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprodcn_rabbit}      = { kprodcn port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprodeu_rabbit}      = { kprodeu port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }
${function:kprodus_rabbit}      = { kprodus port-forward --v=6 --address 0.0.0.0 service/rabbitmq-ha 4369 5672 15672 15692 }

${function:kprod_exec}          = { kprod   exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprodcn_exec}        = { kprodcn exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprodeu_exec}        = { kprodeu exec -it @args "--" sh -c "(bash || ash || sh)" }
${function:kprodus_exec}        = { kprodus exec -it @args "--" sh -c "(bash || ash || sh)" }

# Misc Functions
# ==================================================================================================
function kget_admin_token()
{
    [CmdletBinding()]
    param
    (
        [string] $Environment = "prod",
        [string] $User = "default"
        # [string] $User = "admin-user"
    )

    $secrets_name = $((Invoke-Expression "k${Environment} -o yaml -n kube-system get serviceaccounts ${User} | ConvertFrom-Yaml").secrets.name)

    $cmd = "k${Environment} -n kube-system get secret ${secrets_name} -o jsonpath='{.data.token}' | ConvertFrom-Base64"
    Invoke-Expression $cmd
}

function kimages_slow()
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
