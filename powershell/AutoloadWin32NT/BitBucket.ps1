<#
.SYNOPSIS
Bitbucket scripts.

.DESCRIPTION
Bitbucket scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}

${function:git-ssh-bb} = { (Get-Content .gitmodules).replace('https://bitbucket.org/', 'git@bitbucket.org:') | Set-Content .gitmodules }
${function:git-ssh-bbr} = { (Get-Content .gitmodules).replace('git@bitbucket.org:', 'https://bitbucket.org/') | Set-Content .gitmodules }

function Set-BitbucketOAuthCreds
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Client_id,
        [Parameter(Mandatory = $true)]
        [string]$Secret
    )
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bitbucket.secrets')
    Set-Content $SecretFile "$Client_id"
    Add-Content $SecretFile "$Secret"
}

function Get-BitbucketOAuthToken
{
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bitbucket.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host `
            "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BitbucketOAuthCreds' for initialization. Exiting..." `
            -ForegroundColor Red
        return
    }

    # $UriAuth    = 'https://bitbucket.org/site/oauth2/authorize'
    $UriToken = 'https://bitbucket.org/site/oauth2/access_token'
    $Client_id = $(Get-Content $SecretFile -First 1)
    $Secret = $(Get-Content $SecretFile -First 2)[-1]

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Client_id, $Secret)))
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $OAuthToken = Invoke-RestMethod -Headers @{Authorization = ("Basic {0}" -f $base64AuthInfo) } -Uri $UriToken -Method Post -Body @{grant_type = 'client_credentials' }
    return $OAuthToken
}

function Get-BitbucketOAuthTokenCurl
{
    [string] $SecretFile = (Join-Path $env:USERPROFILE '.bitbucket.secrets')

    if (-Not (Test-Path -Path $SecretFile))
    {
        Write-Host "ERROR: Secretfile $SecretFile wasn't found. Run 'Set-BitbucketOAuthCreds' for initialization. Exiting..." -ForegroundColor Red
        return
    }

    # $UriAuth    = 'https://bitbucket.org/site/oauth2/authorize'
    $UriToken = 'https://bitbucket.org/site/oauth2/access_token'
    $Client_id = $(Get-Content $SecretFile -First 1)
    $Secret = $(Get-Content $SecretFile -First 2)[-1]

    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $Client_id, $Secret)))
    $Response = (curl -k -X POST -H "Authorization: Basic ${base64AuthInfo})" $UriToken -d "grant_type=client_credentials" -s) | ConvertFrom-Json
    return $Response.access_token
}

function Invoke-BitbucketAPIUri
{
    [CmdletBinding()]
    param
    (
        [string] $Uri,
        [string] $Method = 'GET',
        [switch] $ShowRequestUri
    )

    $Token = Get-BitbucketOAuthToken
    $Headers = @{
        'Authorization' = ("Bearer {0}" -f $Token.access_token)
        'Content-Type'  = ('application/json')

    };

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: $Uri" -ForegroundColor Yellow
    }

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Headers $Headers -Uri $Uri -Method $Method
    return $Response
}

function Invoke-BitbucketAPIUri-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $Uri,
        [string] $Method = 'GET',
        [string[]] $CurlArgs = @('-s'),
        [switch] $VerboseOutput,
        [switch] $ShowRequestUri
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $Token = Get-BitbucketOAuthTokenCurl
    $Headers = "Authorization: Bearer ${Token}; Content-Type: application/json"

    if ($ShowRequestUri)
    {
        Write-Host "Request URI: $Uri" -ForegroundColor Yellow
    }

    $Response = (curl -k -X ${Method} -H ${Headers} ${Uri} ${CurlArgs})
    return $Response
}

function Invoke-BitbucketAPI-Simple
{
    [CmdletBinding()]
    param
    (
        [string] $Request,
        [string] $APIVersion = '2.0',
        [string] $Method = 'GET'
    )

    $Token = Get-BitbucketOAuthToken
    $Headers = @{
        'Authorization' = ("Bearer {0}" -f $Token.access_token)
        'Content-Type'  = ('application/json')

    };

    $Uri = "https://api.bitbucket.org/$APIVersion/$Request"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-BitbucketAPIUri -Uri $Uri -Method $Method -ShowRequestUri
    return $Response
}

function Invoke-BitbucketAPI-Simple-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $Request,
        [string] $APIVersion = '2.0',
        [string] $Method = 'GET',
        [string[]] $CurlArgs = @('-s'),
        [switch] $VerboseOutput
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $Uri = "https://api.bitbucket.org/$APIVersion/$Request"
    $Response = Invoke-BitbucketAPIUri-Curl -Uri $Uri -Method $Method -CurlArgs $CurlArgs -ShowRequestUri
    return $Response
}

function Invoke-BitbucketAPI
{
    [CmdletBinding()]
    param
    (
        [string]$RequestPath,
        [string]$Type = '',
        [string]$UriSuffix = 'repositories',
        [string]$APIVersion = '2.0',
        [string]$Method = 'GET'
    )

    $Uri = "https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath"

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-BitbucketAPIUri -Uri $Uri -Method $Method -ShowRequestUri
    return $Response
}

function Invoke-BitbucketAPI-Curl
{
    [CmdletBinding()]
    param
    (
        [string] $RequestPath,
        [string] $Type = '',
        [string] $UriSuffix = 'repositories',
        [string] $APIVersion = '2.0',
        [string] $Method = 'GET',
        [string[]] $CurlArgs = @('-s'),
        [switch] $VerboseOutput
    )

    if ($VerboseOutput)
    {
        $CurlArgs += '-v'
    }

    $Uri = "https://api.bitbucket.org/$APIVersion/$UriSuffix$Type$RequestPath"

    $Response = Invoke-BitbucketAPIUri-Curl -Uri $Uri -Method $Method -CurlArgs $CurlArgs -ShowRequestUri
    return $Response
}

function Get-BitbucketPR
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI -RequestPath "/$PR"
    return $Response
}

function Get-BitbucketPR-Curl
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI-Curl -RequestPath "/$PR"
    return $Response
}

function Get-BitbucketPRComments
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    $Response = Invoke-BitbucketAPI -RequestPath "/$PR/comments"
    return $Response
}

function Get-BitbucketPRParticipants
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Workspace,
        [Parameter(Mandatory = $false)]
        [string]$Repository,
        [Parameter(Mandatory = $false)]
        [int]$PrID
    )
    $Participants = (Invoke-BitbucketAPI -RequestPath "/${Workspace}/${Repository}/pullrequests/${PrID}").participants
    return $Participants
}

# Response examples:
# type            : participant
# user            : @{display_name=FirstName1 LastName1; links=; type=user; uuid={11111111-1111-1111-1111-111111111111}; account_id=11111111-1111-1111-1111-111111111111; nickname=FirstName1 LastName1}
# role            : REVIEWER
# approved        : True
# state           : approved
# participated_on : 01/01/1970 00:00:00
#
# type            : participant
# user            : @{display_name=FirstName2 LastName2; links=; type=user; uuid={22222222-2222-2222-2222-222222222222}; account_id=22222222-2222-2222-2222-222222222222; nickname=FirstName2 LastName2}
# role            : REVIEWER
# approved        : False
# state           :
# participated_on :
#
# Collect display_name and approved state of each participant.s
function Get-BitbucketPRParticipantsApprovers
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Workspace,
        [Parameter(Mandatory = $false)]
        [string]$Repository,
        [Parameter(Mandatory = $false)]
        [int]$PrStartID,
        [Parameter(Mandatory = $false)]
        [int]$PrEndID

    )

    # {
    #     "uuid": {
    #         "display_name": "Display Name",
    #         "apprved_prs": 1
    #     }
    #     "11111111-1111-1111-1111-111111111111": {
    #         "display_name": "FirstName1 LastName1",
    #         "apprved_prs": 1
    #     },
    #     "22222222-2222-2222-2222-222222222222": {
    #         "display_name": "FirstName2 LastName2",
    #         "apprved_prs": 0
    #     }
    # }
    $developers = @{}

    for ($PrID = $PrStartID; $PrID -le $PrEndID; $PrID++)
    {
        $participants = Get-BitbucketPRParticipants -Workspace $Workspace -Repository $Repository -PrID $PrID
        foreach ($participant in $participants)
        {
            # Write-Host $participant.user.display_name -ForegroundColor Cyan
            # Write-Host $participant.user.uuid -ForegroundColor Cyan
            # Write-Host $participant.role -ForegroundColor Yellow
            # Write-Host $participant.approved -ForegrosundColor Green
            if ($participant.role -eq 'REVIEWER')
            {
                if (-not $developers.ContainsKey($participant.user.uuid))
                {
                    $developers[$participant.user.uuid] = @{
                        display_name = $participant.user.display_name
                        approved_prs = 0
                    }
                }

                if ($participant.approved)
                {
                    $developers[$participant.user.uuid].approved_prs++
                }
            }
        }
    }

    $developers.GetEnumerator() | ForEach-Object {
        [PSCustomObject]@{
            display_name = $_.Value.display_name
            approved_prs = $_.Value.approved_prs
        }
    } | Sort-Object -Property approved_prs -Descending | Format-Table -AutoSize
}

function Get-BitbucketPRDiff
{
    [CmdletBinding()]
    param
    (
        [string]$PR
    )
    # $DiffLink = (Invoke-BitbucketAPI -RequestPath "/$PR").links.diff.href
    # $Response = Invoke-BitbucketURI $DiffLink
    # try
    # {
    #     $Response = Invoke-BitbucketAPI -RequestPath "/$PR/diff"
    # }
    # catch
    # {
    #     # Dig into the exception to get the Response details.
    #     # Note that value__ is not a typo.
    #     # Write-Host "StatusCode:" $_.Exception.Response.StatusCode.value__
    #     # Write-Host "StatusDescription:" $_.Exception.Response.StatusDescription
    #     $_.Exception.Response | FL
    # }

    try
    {
        $Response = Invoke-BitbucketAPI -RequestPath "/$PR/diff"
    }
    catch
    {
        $_.Exception.Response.Headers | Format-List
        if (($_.Exception.GetType() -match "HttpResponseException") -and ($_.Exception -match "302"))
        {
            $Response = Invoke-BitbucketAPIUri $_.Exception.Response.Headers.Location.AbsoluteUri
        }
        else
        {
            throw $_
        }
    }
    return $Response
}

function Get-BitbucketUser
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$AccountID
    )
    $Response = Invoke-BitbucketAPI -Type "/$AccountID" -UriSuffix 'users'
    return $Response
}

function Get-BitbucketUser-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$AccountID
    )
    $Response = Invoke-BitbucketAPI-Curl -Type "/$AccountID" -UriSuffix 'users'
    return $Response
}

function Get-BitbucketTeamMembers
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :


    $Response = Invoke-BitbucketAPI -Type "/${Team}/members?pagelen=100" -UriSuffix 'teams'
    return $Response
}

function Get-BitbucketTeamMembers-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :


    $Response = Invoke-BitbucketAPI-Curl -Type "/${Team}/members?pagelen=100" -UriSuffix 'teams'
    return $Response
}

function Show-BitbucketTeamMembers
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :


    $Response = Get-BitbucketTeamMembers "${Team}"
    return $Response.values | Format-Table -Property display_name, has_2fa_enabled, nickname, account_id, account_status, uuid -AutoSize
}

function Show-BitbucketTeamMembers-Curl
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Team
    )

    # display_name    :
    # has_2fa_enabled :
    # links           :
    # nickname        :
    # account_id      :
    # created_on      :
    # is_staff        :
    # account_status  :
    # type            :
    # properties      :
    # uuid            :

    $Response = Get-BitbucketTeamMembers-Curl "${Team}"
    # $Response = Get-BitbucketTeamMembers-Curl "${Team}" -VerboseOutput | ConvertFrom-Json
    # return $Response.values | Format-Table -Property display_name,has_2fa_enabled,nickname,account_id,account_status,uuid -AutoSize
}

function Get-BitbucketWikiPage
{
    # DEPRECATED API
    [CmdletBinding()]
    param
    (
        [string]$WikiPage = 'Code Reviewers'
    )
    # https://bitbucket.org/XXX/XXX/wiki/Protected_branches
    $Response = Invoke-BitbucketAPI -RequestPath "/$WikiPage" -Type '/wiki' -APIVersion '1.0'
    return $Response
}

if (Get-Command git -ErrorAction SilentlyContinue | Test-Path)
{
    ${function:list_bb_user_repos} = {
        Write-Host "Listing all Bitbucket repos of $($args[0])" -ForegroundColor Magenta
        $repoList = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        $count = 0
        do
        {
            foreach ($repo in $repoList.values)
            {
                $count += 1
                Write-Host "$count.`t" -NoNewline
                Write-Host "$($repo.full_name)" -ForegroundColor Cyan
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketAPIUri "$($repoList.next)"))
    }

    ${function:get_bb_user_repos_https} = {
        Write-Host "Get all Bitbucket repos of $($args[0]) via HTTPS"
        $repoList = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        do
        {
            foreach ($repo in $repoList.values)
            {
                $response = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($repo.full_name)"
                git clone --recurse-submodules $(($response.links.clone | Where-Object { $_.name -eq 'https' }).href)
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketAPIUri "$($repoList.next)"))
    }

    ${function:get_bb_user_repos_ssh} = {
        Write-Host "Get all Bitbucket repos of $($args[0]) via SSH"
        $repoList = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($args[0])?pagelen=100"
        do
        {
            foreach ($repo in $repoList.values)
            {
                $response = Invoke-BitbucketAPIUri "https://api.bitbucket.org/2.0/repositories/$($repo.full_name)"
                git clone --recurse-submodules $(($response.links.clone | Where-Object { $_.name -eq 'ssh' }).href)
            }
        } while ($repoList.next -And ($repoList = Invoke-BitbucketAPIUri "$($repoList.next)"))
    }
}
