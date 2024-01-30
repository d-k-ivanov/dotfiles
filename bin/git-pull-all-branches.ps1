git branch -r | %{ git branch --track $_.Replace('  origin/', '') }
git fetch --all
git pull --all
