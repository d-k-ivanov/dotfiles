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
    exit
}

if (Get-Command aws -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:aws-list-s3} = { aws s3 ls @args }
    ${function:aws-get-win19-images} = { aws ec2 describe-images  --owners amazon --filters "Name=name,Values=Windows_Server-2019-English-Full-ECS_Optimized*" --query "Images[*].{ID:ImageId,Name:Name}" --output table }
    ${function:aws-get-win22-images} = { aws ec2 describe-images  --owners amazon --filters "Name=name,Values=Windows_Server-2022-English-Full-ECS_Optimized*" --query "Images[*].{ID:ImageId,Name:Name}" --output table }
    ${function:aws-get-win25-images} = { aws ec2 describe-images  --owners amazon --filters "Name=name,Values=Windows_Server-2025-English-Full-ECS_Optimized*" --query "Images[*].{ID:ImageId,Name:Name}" --output table }

    function aws-mv-s3-to-subfolder
    {
        param (
            [string] $S3URL,
            [string] $Subfolder
        )

        $S3URL = $S3URL.TrimEnd('/') + '/'
        $objects = aws s3 ls $S3URL | Where-Object { $_ -match '\s+\d+\s+' }
        foreach ($line in $objects)
        {
            $parts = $line -split '\s+', 4
            $key = $parts[3]
            $fileName = Split-Path -Leaf $key

            $S3URL = $S3URL.TrimEnd('/')
            $bucketName = ($S3URL -split '/')[2]
            $newS3URL = $S3URL -replace "s3://$bucketName", "s3://$bucketName/$Subfolder"

            aws s3 mv $S3URL/$fileName $newS3URL/$fileName
        }

    }
}
