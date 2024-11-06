<#
.SYNOPSIS
Git scripts.

.DESCRIPTION
Git scripts.
#>

# Check invocation
if ($MyInvocation.InvocationName -ne '.')
{
    Write-Host `
        "Error: Bad invocation. $($MyInvocation.MyCommand) supposed to be sourced. Exiting..." `
        -ForegroundColor Red
    Exit
}


# Main
${function:g} = { git @args }
${function:gg} = { git -c core.pager='delta --features=code-review-chameleon' @args }
${function:gunsec} = { git -c http.sslVerify=false @args }
${function:gb} = { git branch @args }

# Logs
${function:gll} = { git log --pretty=format:"%h - %an, %ar : %s" @args }
${function:glL} = { git log --pretty=format:"%H - %an, %ar : %s" @args }

# Clone
${function:gcr} = { git clone --recurse-submodules @args }
${function:gcb} = { git clone --single-branch --branch @args }
${function:gcrb} = { git clone --recurse-submodules --single-branch --branch @args }

# Look for satus or changes
${function:gs} = { git status @args }
${function:gss} = { git status @args }

${function:gw} = { git show @args }
${function:gw^} = { git show HEAD^ @args }
${function:gww} = { git show HEAD^ @args }
${function:gw^^} = { git show HEAD^^ @args }
${function:gwww} = { git show HEAD^^ @args }
${function:gw^^^} = { git show HEAD^^^ @args }
${function:gwwww} = { git show HEAD^^^ @args }
${function:gw^^^^} = { git show HEAD^^^^ @args }
${function:gwwwww} = { git show HEAD^^^^ @args }
${function:gw^^^^^} = { git show HEAD^^^^^ @args }
${function:gwwwwww} = { git show HEAD^^^^^ @args }
${function:gw^^^^^^} = { git show HEAD^^^^^^ @args }
${function:gwwwwwww} = { git show HEAD^^^^^^ @args }
${function:gw^^^^^^^} = { git show HEAD^^^^^^^ @args }
${function:gwwwwwwww} = { git show HEAD^^^^^^^ @args }
${function:gw^^^^^^^^} = { git show HEAD^^^^^^^^ @args }
${function:gwwwwwwwww} = { git show HEAD^^^^^^^^ @args }

${function:ggw} = { git -c core.pager='delta --features=code-review-chameleon' show @args }
${function:ggw^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^ @args }
${function:ggww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^ @args }
${function:ggw^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^ @args }
${function:ggwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^ @args }
${function:ggw^^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^ @args }
${function:ggwwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^ @args }
${function:ggw^^^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^ @args }
${function:ggwwwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^ @args }
${function:ggw^^^^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^ @args }
${function:ggwwwwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^ @args }
${function:ggw^^^^^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^ @args }
${function:ggwwwwwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^ @args }
${function:ggw^^^^^^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^ @args }
${function:ggwwwwwwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^ @args }
${function:ggw^^^^^^^^} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^^ @args }
${function:ggwwwwwwwww} = { git -c core.pager='delta --features=code-review-chameleon' show HEAD^^^^^^^^ @args }

${function:gd} = { git diff HEAD @args }
${function:ggd} = { git -c core.pager='delta --features=code-review-chameleon' diff HEAD @args }
${function:gdo} = { git diff --cached @args }

# Add and Commit
${function:gco} = { if ($args) { git commit -m @args } else { git commit -v } } # "git commit only"
${function:ga} = { git add @args }
${function:gca} = { git add --all; gco @args } # "git commit all"
${function:gcm} = { git commit -m "${args}" } # "git commit message"
${function:gcn} = { git commit -m "$(Split-Path -Path $(Get-Location) -Leaf): ${args}" }
${function:gcnd} = { git commit -m "$(Split-Path -Path $(Get-Location) -Leaf): $(now) ${args}" }
${function:gcv} = { git commit -v @args }
${function:gcof} = { git commit --no-verify -m @args }
${function:gcaf} = { (git add --all) -and (gcof @args) }
${function:gam} = { git commit --amend @args }
${function:gamne} = { git commit --amend --no-edit @args }
${function:gamm} = { git add --all; git commit --amend -C HEAD @args }
${function:gammf} = { gamm --no-verify @args }

# Cleanup
${function:gcoc} = { gco Cleanup. @args }
${function:gcac} = { gca Cleanup. @args }
${function:gcow} = { gco Whitespace. @args }
${function:gcaw} = { gca Whitespace. @args }
${function:gfr} = { git fetch --all; git reset --hard @args }
${function:gfrmn} = { git fetch --all; git reset --hard origin/main @args }
${function:gfrms} = { git fetch --all; git reset --hard origin/master @args }
${function:gfrmn} = { git fetch --all; git reset --hard github/main @args }
${function:gfrms} = { git fetch --all; git reset --hard github/master @args }
${function:gclean} = { while ((git diff-index HEAD --)) { git reset --hard HEAD }; git clean -d -x -f @args }
${function:gclean2} = { while ((git diff-index HEAD --)) { git reset --hard HEAD }; git clean -d -X -f @args }
${function:gclean3} = { while ((git diff-index HEAD --)) { git reset --hard HEAD }; git clean -d -f @args }

# Pull
${function:gpl} = { git pull origin $(git rev-parse --abbrev-ref HEAD) }
${function:gplmn} = { git pull origin main }
${function:gplms} = { git pull origin master }
${function:gpl_gh} = { git pull github $(git rev-parse --abbrev-ref HEAD) }
${function:gplmn_gh} = { git pull github main }
${function:gplms_gh} = { git pull github master }
${function:gpls} = { git stash; git pull @args; git stash pop }
${function:gplm} = { git pull; git submodule update }
${function:gplp} = { git pull --rebase; git push @args } # Can't pull because you forgot to track? Run this.

# Push
# ${function:gp}        = { git push @args }  # Comment if you use Get-Property and use gpp insted
${function:gpp} = { git push @args }
${function:gppa} = { git add .; gcnd; gpp }
${function:gppf} = { git push --force @args }
${function:gppg} = { git push github @args }
${function:gppt} = { git push --tags @args }
${function:gppu} = { git push -u @args }

# Checkout
${function:gck} = { git checkout @args }
${function:gckb} = { git checkout -b @args }
${function:gckt} = { git checkout - @args }
${function:gckmn} = { git checkout main @args }
${function:gckms} = { git checkout master @args }

# Remove Branches
${function:gbr} = { git branch -d @args }
${function:gbr_filter} = { git branch | grep @args | %{ gbr $_.trim() } }
${function:gbrf} = { git branch -D @args }
${function:gbrf_filter} = { git branch | grep @args | %{ gbrf -D $_.trim() } }
${function:gbrr} = { git push origin --delete @args }
${function:gbrrm} = { git branch -D @args; git push origin --delete @args }
${function:gbrr_gh} = { git push github --delete @args }
${function:gbrrm_gh} = { git branch -D @args; git push github --delete @args }
${function:g-to-main} = { git branch -m master main; git fetch origin; git branch -u origin/main main; git remote set-head origin -a }

# Rebase
${function:gcp} = { git cherry-pick @args }
${function:grb} = { git rebase -i origin/@args }
${function:grbmn} = { git rebase -i origin/main @args }
${function:grbms} = { git rebase -i origin/master @args }
${function:gba} = { git rebase --abort @args }
${function:gbc} = { git add -A; git rebase --continue @args }
${function:gbmn} = { git fetch origin main; git rebase origin/main @args }
${function:gbms} = { git fetch origin master; git rebase origin/master @args }
${function:gCH} = { git rebase -i --root @args }

# Code-Review
${function:git-review} = { if ($args[0] -and -Not $args[1]) { git push origin HEAD:refs/for/@args[0] } else { Write-Host "Wrong command!`nUsage: git-review <branch_name>" } }
${function:grw} = { git-review }

# Tags
${function:grmt} = { git tag --delete @args }
${function:grmto} = { git push --delete origin @args }
${function:grmto_gh} = { git push --delete github @args }

# Submodules
${function:gsu} = { git submodule update --recursive --remote @args }
${function:gsumn} = { git submodule foreach git pull origin main @args }
${function:gsums} = { git submodule foreach git pull origin master @args }
${function:gsumn_gh} = { git submodule foreach git pull github main @args }
${function:gsums_gh} = { git submodule foreach git pull github master @args }

# Misc
${function:gex} = { GitExtensions.exe browse @args }
${function:gitinfo} = { ssh gitolite@git info @args }   # Gitolite list repos
${function:gittest-gh} = { ssh -T git@github.com }
${function:gittest-gl} = { ssh -T git@gitlab.com }
${function:gittest-bb} = { ssh -T git@bitbucket.org }

# Accounts
${function:git-home} = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'd.k.ivanov@live.com' }

# Straumann
${function:git-cc}  = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'dmitry.ivanov@straumann.com' }
${function:git-cca} = { git config --local user.name 'Clinical Apps Automation'; git config --local user.email 'dmitry.ivanov@clearcorrect.com' }

# IRQ
${function:git-irq} = { git config --local user.name 'Dmitry Ivanov'; git config --local user.email 'divanov@irq.ru' }

function gprune
{
    [CmdletBinding()]
    param
    (
        [string]$branch = "main"
    )

    $CurrentBranch = $(cmd /c "git rev-parse --abbrev-ref HEAD")
    # Stash changes
    cmd /c "git stash"
    # Checkout primary branch:
    cmd /c "git checkout $branch"
    cmd /c "git fetch"
    # Run garbage collector
    cmd /c "git gc --prune=now"
    # Prune obsolete refs in 3 turns
    cmd /c "git remote prune origin"
    cmd /c "git fetch --prune"
    cmd /c "git remote prune origin"
    cmd /c "git fetch --prune"
    cmd /c "git remote prune origin"
    cmd /c "git fetch --prune"
    # Return to working branch
    cmd /c "git checkout $CurrentBranch"
    # Unstash work:
    cmd /c "git stash pop"
}

function ugr
{
    param
    (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string] $Options = ""
    )

    $dir = Get-Location
    Get-ChildItem $dir -Directory | ForEach-Object {
        Write-Host $_.FullName
        Set-Location $_.FullName
        If ($Options -match '\S')
        {
            git pull $Options

        }
        else
        {
            git pull origin $(git symbolic-ref --short HEAD)
        }
    }

    Set-Location $dir
}

function ugrf
{
    param
    (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string]$Options = ""
    )

    $dir = Get-Location
    Get-ChildItem $dir -Directory | ForEach-Object {
        Write-Host $_.FullName
        Set-Location $_.FullName
        If ($Options -match '\S')
        {
            git fetch $Options

        }
        else
        {
            git fetch origin $(git symbolic-ref --short HEAD)
        }
    }

    Set-Location $dir
}

function ugrs
{
    param
    (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string]$Options = ""
    )
    $dir = Get-Location
    Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugr $Options }
    Set-Location $dir
}

function ugrfs
{
    param
    (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string]$Options = ""
    )
    $dir = Get-Location
    Get-ChildItem @args -Directory | ForEach-Object { Set-Location $_.FullName; ugrf $Options }
    Set-Location $dir
}

function get_repo_with_target
{
    if (-Not $args[0])
    {
        Write-Host "You should enter repo URI."
        Write-Host ( "Usage: {0} <repo_url>" -f $MyInvocation.MyCommand )
        Write-Host
    }
    else
    {
        $scheme = python -c "from urllib.parse import urlparse; uri='$($args[0])'; result = urlparse(uri); print(result.scheme)"
        if ($scheme -eq "https")
        {
            $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
        }
        else
        {
            $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]) + '-' + os.path.dirname(path[0]))"
        }
        git clone --recurse-submodules "$($args[0])" "$target"
    }
}
${function:grt} = { get_repo_with_target @args }

function git_archive_repo
{
    if (-Not $args[0])
    {
        Write-Host "You should enter repo URI."
        Write-Host ( "Usage: {0} <repo_url>" -f $MyInvocation.MyCommand )
        Write-Host
    }
    else
    {
        $scheme = python -c "from urllib.parse import urlparse; uri='$($args[0])'; result = urlparse(uri); print(result.scheme)"
        if ($scheme -eq "https")
        {
            $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.strip('/')); print(os.path.basename(path[0]))"
        }
        else
        {
            $target = python -c "from urllib.parse import urlparse; import os.path; uri='$($args[0])'; result = urlparse(uri); path = os.path.splitext(result.path.split(':', 1)[-1]); print(os.path.basename(path[0]))"
        }
        Write-Host $target
        git clone --mirror "$($args[0])" "$target"
        tar -cjf "${target}.tar.bz2" "${target}"
    }
}

function git_unarchive_repo
{
    #TBD
    mkdir git_unarchive_repo
    mv archive_repo git_unarchive_repo/.git
    cd git_unarchive_repo
    git config --local --bool core.bare false
    git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
    git checkout master
}

function Move-GitRepo
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$From,
        [Parameter(Mandatory = $true)]
        [string]$To
    )
    [string] $SessionID = [System.Guid]::NewGuid()

    Invoke-Expression "git clone --mirror $From $SessionID"
    $RepoDir = (Join-Path $env:Temp $SessionID)
    Set-Location $RepoDir
    Invoke-Expression "git push --mirror $To"
    Set-Location $env:Temp
    Remove-Item -Force -ErrorAction SilentlyContinue "$TempDir"
}

# TMP Get Chef cookbook
# ${function:get_cbk} = { if (Test-Path "${Env:WORKSPACE}/Chef/cookbooks"){ Set-Location "${Env:WORKSPACE}/Chef/cookbooks"; git clone "gitolite@git.domain.com:chef/cookbooks/$($args[0].ToString()).git"; Set-Location "$($args[0].ToString())" } }

function Set-GitVerbosity
{
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Button,
        [string]$Category = 'all'
    )
    switch ($Button)
    {
        ({ $PSItem -eq 'On' -Or $PSItem -eq 'on' })
        {
            if (($Category -eq 'curl') -Or ($Category -eq 'all'))
            {
                Set-Item -Path Env:GIT_CURL_VERBOSE -Value 1
                Set-Item -Path Env:GIT_TRACE_CURL   -Value 1
            }
            if (($Category -eq 'trace') -Or ($Category -eq 'all'))
            {
                Set-Item -Path Env:GIT_TRACE -Value 1
            }
            if (($Category -eq 'pack') -Or ($Category -eq 'all'))
            {
                Set-Item -Path Env:GIT_TRACE_PACK_ACCESS -Value 1
            }
            if (($Category -eq 'packet') -Or ($Category -eq 'all'))
            {
                Set-Item -Path Env:GIT_TRACE_PACKET -Value 1
            }
            if (($Category -eq 'perf') -Or ($Category -eq 'all'))
            {
                Set-Item -Path Env:GIT_TRACE_PERFORMANCE -Value 1
            }
            if (($Category -eq 'setup') -Or ($Category -eq 'all'))
            {
                Set-Item -Path Env:GIT_TRACE_SETUP -Value 1
            }
            break
        }
        ({ $PSItem -eq 'Off' -Or $PSItem -eq 'off' })
        {
            Set-Item -Path Env:GIT_CURL_VERBOSE       -Value 0
            Set-Item -Path Env:GIT_TRACE_CURL         -Value 0
            Set-Item -Path Env:GIT_TRACE              -Value 0
            Set-Item -Path Env:GIT_TRACE_PACK_ACCESS  -Value 0
            Set-Item -Path Env:GIT_TRACE_PACKET       -Value 0
            Set-Item -Path Env:GIT_TRACE_PERFORMANCE  -Value 0
            Set-Item -Path Env:GIT_TRACE_SETUP        -Value 0
            break
        }
        default
        {
            Write-Host "ERROR: Wrong operation..." -ForegroundColor Red
            Write-Host "Usage: Git-Verbose <On|Off> [Category]" -ForegroundColor Red
            Write-Host "  Categories: curl, trace, pack, packet, perf" -ForegroundColor Red
        }
    }
}

function Show-Diff_Of_Git_Branches
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$Branch1,
        [Parameter(Mandatory = $true)]
        [string]$Branch2
    )

    git checkout $Branch1
    git checkout $Branch2

    git diff ${Branch1}..${Branch2}
}

# Git analisys:
function Get-GitCommitsByAuthor
{
    [CmdletBinding()]
    param
    (
        [string]$Author = "d-k-ivanov",
        [switch]$AllBranches
    )
    $cmd = "git log "
    $cmd += "--pretty=format:'%Cred%h%Creset %C(bold blue)%an%C(reset) - %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' "
    $cmd += "--abbrev-commit --date=iso8601 "

    if ($AllBranches)
    {
        $cmd += "--all "
    }

    $cmd += "--author $Author"
    Invoke-Expression $cmd
}

function git_rename_author
{
    git filter-branch -f --env-filter "export GIT_COMMITTER_NAME='Dmitry Ivanov';export GIT_COMMITTER_EMAIL='d.k.ivanov@live.com';export GIT_AUTHOR_NAME='Dmitry Ivanov';export GIT_AUTHOR_EMAIL='d.k.ivanov@live.com'" --tag-name-filter cat -- --branches --tags
}

function git_change_email_in_my_commits
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string]$OldMail,
        [string]$NewMail = 'd.k.ivanov@live.com',
        [string]$GitName = 'Dmitry Ivanov'

    )

    git filter-branch --env-filter "                            `
        OLD_EMAIL='${OldMail}';                                 `
        GIT_NAME='${GitName}';                                  `
        NEW_EMAIL='${NewMail}';                                 `
        if [ '$GIT_COMMITTER_EMAIL' = '$OLD_EMAIL' ]; then;     `
            export GIT_COMMITTER_NAME="$GIT_NAME";              `
            export GIT_COMMITTER_EMAIL="$NEW_EMAIL";            `
        fi;                                                     `
        if [ '$GIT_AUTHOR_EMAIL' = '$OLD_EMAIL' ]; then;        `
            export GIT_AUTHOR_NAME='$GIT_NAME';                 `
            export GIT_AUTHOR_EMAIL='$NEW_EMAIL';               `
        fi;                                                     `
    " --tag-name-filter cat -- --branches --tags
}

function git_push_force
{
    git push --force --tags origin 'refs/heads/*'
}

function git_remove_file_from_history
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string] $File
    )
    git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $File" --prune-empty --tag-name-filter cat -- --all
}

function git_dangling_show
{
    git fsck --full
}

function git_dangling_fix
{
    git reflog expire --expire=now --all
    git gc --prune=now
}

function git_upstream
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $Upstream
    )
    git branch --set-upstream-to=origin/${Upstream} ${Upstream}
}

function git_upstream_gh
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $Upstream
    )
    git branch --set-upstream-to=github/${Upstream} ${Upstream}
}

#TODO: Add implementation
function Remove-GitSubmodule
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $SubmoduleName
    )

    if (-Not (Test-Path '.\\.gitmodules'))
    {
        Write-Host `
            "Error: Wrong directory. You should be in the root of git repo to use this function. Exiting..." `
            -ForegroundColor Red
        return
    }

    $gm_file = Get-Content '.\\.gitmodules'
    foreach ($line in $gm_file)
    {
        Write-Host $line
    }

    # 1. Delete the relevant section from the *.gitmodules* file.
    # [submodule "vendor"]
    # path = vendor
    # url = git://github.com/some-user/some-repo.git
    # 2. Stage the *.gitmodules* changes with following command:
    # git add .gitmodules
    # 3.Delete the relevant section from *.git/config*:
    # [submodule "vendor"]
    # url = git://github.com/some-user/some-repo.git
    # 4. Remove submodule folders from repo:
    # git rm --cached path/to/submodule
    # rm -rf .git/modules/submodule_name
    # 6. Commit changes
    # 7. Delete files
    # rm -rf path/to/submodule
}

function show_git_remote_recursively
{
    param
    (
        [string] $Path = ".",
        [string] $Depth = "0"
    )

    Get-ChildItem -Path $Path -Depth $Depth -Directory | ForEach-Object {
        if (Test-Path -Path $(Join-Path $_.FullName ".git"))
        {
            Write-Output "# $($_.FullName)"
            # Get-Item $_.FullName/.. | Split-Path -Leaf | Write-Output
            Write-Output $(git -C $_.FullName remote -v | Select-Object -First 1).Split()[1]
        }
    }
}

if (Get-Command git -ErrorAction SilentlyContinue | Test-Path)
{
    function grcpr
    {
        git fetch origin main
        git checkout DEV/Copyright
        git rebase main
    }

    function grcpr_push
    {
        git push --force origin DEV/Copyright
    }
}

function git_filter_folder
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [string] $Folder
    )
    # Clone single branch:
    # git clone --single-branch --branch <branch> <repo> <dst_folder>
    # Remove remote
    # git remote rm origin
    # Add new remote:
    # git remote add origin <new_repo>
    git filter-branch --subdirectory-filter $Folder -- -- all
}
