<#
.SYNOPSIS
AWS scripts.

.DESCRIPTION
AWS scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

function aws_set_env_vars()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $AccessKey,
        [Parameter(Mandatory = $true)]
        [string] $SecretKey,
        [string] $Region = 'us-east-1'

    )
    Set-Item -Path Env:AWS_ACCESS_KEY_ID      -Value "$AccessKey"
    Set-Item -Path Env:AWS_SECRET_ACCESS_KEY  -Value "$SecretKey"
    Set-Item -Path Env:AWS_DEFAULT_REGION     -Value "$Region"
}

function aws_unset_env_vars()
{
    if ($env:AWS_ACCESS_KEY_ID)
    {
        Remove-Item Env:AWS_ACCESS_KEY_ID
    }
    if ($env:AWS_DEFAULT_REGION)
    {
        Remove-Item Env:AWS_DEFAULT_REGION
    }
    if ($env:AWS_SECRET_ACCESS_KEY)
    {
        Remove-Item Env:AWS_SECRET_ACCESS_KEY
    }
    if ($env:AWS_REGION)
    {
        Remove-Item Env:AWS_REGION
    }
    if ($env:AWS_SESSION_TOKEN)
    {
        Remove-Item Env:AWS_SESSION_TOKEN
    }
}

# Get all instances state
function aws_print_all_instances()
{
    $REGIONS = $(aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        Write-Host "Instances in '$REGION'.." -ForegroundColor Green
        # aws ec2 describe-instances --region $REGION | jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.State.Name)"'
        $region_info = $(aws ec2 describe-instances --region $REGION | ConvertFrom-Json)
        foreach ($instance in $region_info.Reservations.Instances)
        {
            Write-Host "$($instance.InstanceId)`t$($instance.State.Name)`t$($instance.InstanceType)" -ForegroundColor Yellow
        }
    }
}

function awless_print_all_instances()
{
    $REGIONS = $(aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        awless list instances -r $REGION
    }
}

# Get all instances public and private IPs
function aws_print_all_ip()
{
    $REGIONS = $(aws ec2 describe-regions --region eu-central-1 --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        Write-Host "Instances in '$REGION'.." -ForegroundColor Green
        # aws ec2 describe-instances --region $REGION | jq '.Reservations[].Instances[] | "EC2: \(.InstanceId): \(.State.Name)"'
        $region_info = $(aws ec2 describe-instances --region $REGION | ConvertFrom-Json)
        foreach ($instance in $region_info.Reservations.Instances)
        {
            Write-Host "$($instance.InstanceId)`t$($instance.PrivateIpAddress)" -ForegroundColor Yellow -NoNewline
            Write-Host "`t$($instance.PublicIpAddress)" -ForegroundColor Red
        }
    }
}

function aws_print_intance_type_availability()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $InstanceType
    )
    $REGIONS = $(aws ec2 describe-regions --output text --query Regions[*].[RegionName])
    foreach ($REGION in $REGIONS)
    {
        Write-Host "Availabitly of '${InstanceType}' instances in '$REGION'.." -ForegroundColor Green
        $region_info = $(aws ec2 describe-instance-type-offerings --region $REGION --location-type "availability-zone" --filters "Name=instance-type,Values=${InstanceType}" | ConvertFrom-Json)
        foreach ($instanceOffering in $region_info.InstanceTypeOfferings)
        {
            Write-Host "`t$($instanceOffering.Location)" -ForegroundColor Yellow -NoNewline
        }
        Write-Host ""
    }
}

function aws_set_mfa_session()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $MFADevice,
        [Parameter(Mandatory = $true)]
        [string] $MFAToken,
        [string] $Duration = 3600,
        [string] $Region = 'eu-west-1'
    )
    $creds = (
        (
            aws sts get-session-token --serial-number $MFADevice --token-code $MFAToken --duration-seconds $Duration --output json
        ) | ConvertFrom-Json).Credentials

    Set-Item -Path Env:AWS_ACCESS_KEY_ID -Value $creds.AccessKeyId
    Set-Item -Path Env:AWS_SECRET_ACCESS_KEY -Value $creds.SecretAccessKey
    Set-Item -Path Env:AWS_SESSION_TOKEN -Value $creds.SessionToken
    Set-Item -Path Env:AWS_REGION -Value $Region
}

function aws_assume_role()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $RoleARN,
        [Parameter(Mandatory = $true)]
        [string] $SessionName,
        [string] $Region = 'eu-west-1'
    )
    $creds = ((aws sts assume-role --role-arn ${RoleARN} --role-session-name=${SessionName}) | ConvertFrom-Json).Credentials

    Set-Item -Path Env:AWS_ACCESS_KEY_ID -Value $creds.AccessKeyId
    Set-Item -Path Env:AWS_SECRET_ACCESS_KEY -Value $creds.SecretAccessKey
    Set-Item -Path Env:AWS_SESSION_TOKEN -Value $creds.SessionToken
    Set-Item -Path Env:AWS_REGION -Value $Region
}

function aws_set_mfa_session_for_profile()
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $MFADevice,
        [Parameter(Mandatory = $true)]
        [string] $MFAToken,
        [Parameter(Mandatory = $true)]
        [string] $Profile,
        [string] $Duration = 3600,
        [string] $Region = 'eu-west-1'
    )
    $creds = (
        (
            aws sts get-session-token           `
                --duration-seconds $Duration    `
                --output json                   `
                --profile $Profile              `
                --serial-number $MFADevice      `
                --token-code $MFAToken
        ) | ConvertFrom-Json).Credentials

    Set-Item -Path Env:AWS_ACCESS_KEY_ID -Value $creds.AccessKeyId
    Set-Item -Path Env:AWS_SECRET_ACCESS_KEY -Value $creds.SecretAccessKey
    Set-Item -Path Env:AWS_SESSION_TOKEN -Value $creds.SessionToken
    Set-Item -Path Env:AWS_REGION -Value $Region
}

${function:aws-profiles} = { aws configure list-profiles @args }

${function:cdk} = { npx aws-cdk@1.x @args }
${function:cdk2} = { npx aws-cdk@2.x @args }
