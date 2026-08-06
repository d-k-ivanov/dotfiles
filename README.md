# My dotfiles to all of my systems

* Windows
* Linux
* MacOS

## Git Posh Options

To disable something in git-posh-bash:

```bash
cd my-git-repo/
git config bash.enableGitStatus false
git config bash.enableFileStatus false
git config bash.showStatusWhenZero false
git config bash.enableStashStatus false
git config bash.enableStatusSymbol false
```

To restore the default behavior:

```bash
cd my-git-repo/
git config --unset bash.enableGitStatus
git config --unset bash.enableFileStatus
git config --unset bash.showStatusWhenZero
git config --unset bash.enableStashStatus
git config --unset bash.enableStatusSymbol
```
