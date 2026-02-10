<#
.SYNOPSIS
AWS Scripts.

.DESCRIPTION
AWS Scripts.
#>

# Check invocation
if ( $MyInvocation.InvocationName -ne '.' )
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

if (Get-Command aws -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:aws-list-s3}             = { aws s3 ls @args }
    ${function:aws-get-win19-images}    = { aws ec2 describe-images  --owners amazon --filters "Name=name,Values=Windows_Server-2019-English-Full-ECS_Optimized*" --query "Images[*].{ID:ImageId,Name:Name}" --output table }
    ${function:aws-get-win22-images}    = { aws ec2 describe-images  --owners amazon --filters "Name=name,Values=Windows_Server-2022-English-Full-ECS_Optimized*" --query "Images[*].{ID:ImageId,Name:Name}" --output table }
    ${function:aws-get-win25-images}    = { aws ec2 describe-images  --owners amazon --filters "Name=name,Values=Windows_Server-2025-English-Full-ECS_Optimized*" --query "Images[*].{ID:ImageId,Name:Name}" --output table }

}
