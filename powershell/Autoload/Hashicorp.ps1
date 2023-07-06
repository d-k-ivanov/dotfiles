<#
.SYNOPSIS
Terraform scripts.

.DESCRIPTION
Terraform scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command terraform -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:terrafrom}   = { terraform @args }
    ${function:t}           = { terraform @args }
    ${function:ta}          = { terraform apply terraform.plan @args }
    ${function:ti}          = { terraform init @args }
    ${function:tp}          = { terraform plan -out terraform.plan @args}
    ${function:tpd}         = { terraform plan -destroy -out terraform.plan @args}
    ${function:tpdm}        = { terraform plan -destroy -target module.${args} -out terraform.plan }
    # ${function:tp}          = { if ($args[0] -And -Not $args[1]) {terraform plan -out terraform.plan --var-file=$args.tfvars} else {terraform plan -out terraform.plan @args}}
    # ${function:tpd}         = { if ($args[0] -And -Not $args[1]) {terraform plan -destroy -out terraform.plan --var-file=$args.tfvars} else {terraform plan -destroy -out terraform.plan @args}}
    ${function:tw}          = { terraform workspace @args }
    ${function:twd}         = { terraform workspace delete @args }
    ${function:twn}         = { terraform workspace new @args }
    ${function:twl}         = { terraform workspace list @args }
    ${function:tws}         = { terraform workspace select @args }
}

${function:packer_verbose_logs_on}  = { $Env:PACKER_LOG=1 }
${function:packer_verbose_logs_off} = { $Env:PACKER_LOG=0 }
