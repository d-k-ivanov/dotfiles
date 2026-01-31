# Bash Aliases Reference

This document lists all shell aliases defined in [bash/autoload/](bash/autoload/).

## Table of Contents

- [AI / ML](#ai--ml)
- [Ansible](#ansible)
- [AWS](#aws)
- [Bash](#bash)
- [Chef](#chef)
- [CMake](#cmake)
- [Containers (Docker/Podman)](#containers-dockerpodman)
- [C++ Development](#c-development)
- [Development Tools](#development-tools)
- [Display](#display)
- [Filesystem & Navigation](#filesystem--navigation)
- [Git](#git)
- [Grep & Text Processing](#grep--text-processing)
- [IDE & Editors](#ide--editors)
- [Kubernetes](#kubernetes)
- [KVM / Virtualization](#kvm--virtualization)
- [Make](#make)
- [Miscellaneous](#miscellaneous)
- [Monitoring](#monitoring)
- [Network](#network)
- [Node.js / npm](#nodejs--npm)
- [Python](#python)
- [Ruby](#ruby)
- [Security & GPG](#security--gpg)
- [Software](#software)
- [System](#system)
- [Terraform](#terraform)
- [Tmux](#tmux)
- [UGR (SSH Shortcuts)](#ugr-ssh-shortcuts)
- [vcpkg](#vcpkg)
- [WASM](#wasm)
- [Wayland](#wayland)
- [Web & Weather](#web--weather)

---

## AI / ML

Source: [ai.sh](bash/autoload/ai.sh)

| Alias | Purpose                                                 |
| ----- | ------------------------------------------------------- |
| `ai`  | Activate AI virtual environment for ML/AI development   |
| `aid` | Deactivate AI virtual environment                       |
| `air` | Remove AI virtual environment directory completely      |
| `aii` | Initialize new AI virtual environment with dependencies |
| `aiu` | Update packages in AI virtual environment               |

---

## Ansible

Source: [ansible.sh](bash/autoload/ansible.sh)

| Alias | Purpose                                   |
| ----- | ----------------------------------------- |
| `ap`  | Run Ansible playbook (`ansible-playbook`) |

---

## AWS

Source: [aws.sh](bash/autoload/aws.sh)

| Alias          | Purpose                                               |
| -------------- | ----------------------------------------------------- |
| `aws-profiles` | List all configured AWS CLI profiles from credentials |

---

## Bash

Source: [bash.sh](bash/autoload/bash.sh)

| Alias    | Purpose                                                |
| -------- | ------------------------------------------------------ |
| `reload` | Reload bash profile and all autoload scripts           |
| `bash`   | Start new bash login shell (re-initialize environment) |

---

## Chef

Source: [chef.sh](bash/autoload/chef.sh)

| Alias | Purpose                                             |
| ----- | --------------------------------------------------- |
| `kl`  | List Test Kitchen instances (`kitchen list`)        |
| `klo` | Login to Test Kitchen instance (`kitchen login`)    |
| `kd`  | Destroy Test Kitchen instance (`kitchen destroy`)   |
| `kc`  | Converge Test Kitchen instance (`kitchen converge`) |
| `kt`  | Run Test Kitchen tests (`kitchen test`)             |
| `kn`  | Knife node command prefix                           |
| `kns` | Show node details (`knife node show`)               |
| `knl` | List all Chef nodes (`knife node list`)             |
| `kne` | Edit node configuration (`knife node edit`)         |
| `kbu` | Switch between knife configuration files            |
| `kbl` | List available knife configurations                 |

---

## CMake

Source: [cmake.sh](bash/autoload/cmake.sh)

| Alias         | Purpose                                                            |
| ------------- | ------------------------------------------------------------------ |
| `cgen`        | Generate build files with Ninja generator (RelWithDebInfo)         |
| `cbuild`      | Build project in RelWithDebInfo configuration                      |
| `cgenbuld-db` | Generate + Build in Debug mode (build/x64-Debug)                   |
| `cgenbuld-rl` | Generate + Build in Release mode (build/x64-Release)               |
| `cgenbuld-rd` | Generate + Build in RelWithDebInfo mode (build/x64-RelWithDebInfo) |
| `cgenbuld`    | Alias for `cgenbuld-rd` (default build type)                       |
| `cgb`         | Short alias for `cgenbuld-rd`                                      |

---

## Containers (Docker/Podman)

Source: [containers.sh](bash/autoload/containers.sh)

### Docker

| Alias         | Purpose                                                               |
| ------------- | --------------------------------------------------------------------- |
| `di`          | List all Docker images (`docker images`)                              |
| `dc`          | List all containers including stopped (`docker ps -a`)                |
| `dcle`        | Remove all containers with "exited" status                            |
| `dclc`        | Remove all containers with "created" status                           |
| `dcla`        | Remove exited containers + dangling images + dangling volumes         |
| `dcli`        | Remove all Docker images                                              |
| `dclif`       | Force remove all Docker images (ignores dependencies)                 |
| `dri`         | Run container interactively with auto-remove (`--rm -it`)             |
| `dri_entry`   | Run container with `/bin/sh` entrypoint override                      |
| `dri_pwd`     | Run container with current directory mounted at `/project`            |
| `dri_pwd_ray` | Run container with `/project` mount + Ray ports (6379,8000,8076,etc.) |
| `desh`        | Start shell session in existing container                             |
| `dfimage`     | Reverse-engineer Dockerfile from image using alpine/dfimage           |
| `dive`        | Analyze image layers interactively using wagoodman/dive               |

### Podman

| Alias         | Purpose                                                               |
| ------------- | --------------------------------------------------------------------- |
| `pi`          | List all Podman images (`podman images`)                              |
| `pc`          | List all containers including stopped (`podman ps -a`)                |
| `pcle`        | Remove all containers with "exited" status                            |
| `pclc`        | Remove all containers with "created" status                           |
| `pcla`        | Remove exited containers + dangling images + dangling volumes         |
| `pcli`        | Remove all Podman images                                              |
| `pclif`       | Force remove all Podman images (ignores dependencies)                 |
| `pri`         | Run container interactively with auto-remove (`--rm -it`)             |
| `pri_entry`   | Run container with `/bin/sh` entrypoint override                      |
| `pri_pwd`     | Run container with current directory mounted at `/project`            |
| `pri_pwd_ray` | Run container with `/project` mount + Ray ports (6379,8000,8076,etc.) |
| `pesh`        | Start shell session in existing container                             |
| `pfimage`     | Reverse-engineer Dockerfile from image using alpine/dfimage           |
| `pive`        | Analyze image layers interactively using wagoodman/dive               |

---

## C++ Development

Source: [cpp.sh](bash/autoload/cpp.sh)

| Alias     | Purpose                                               |
| --------- | ----------------------------------------------------- |
| `cppck`   | Run cppcheck static analyzer on current directory     |
| `cppcki`  | Run cppcheck with inline suppression comments enabled |
| `cppckif` | Run cppcheck using external suppressions file         |

---

## Development Tools

Source: [dev.sh](bash/autoload/dev.sh)

| Alias              | Purpose                                     |
| ------------------ | ------------------------------------------- |
| `show_opscodes_b`  | List opcodes/symbols in /bin/* binaries     |
| `show_opscodes_ub` | List opcodes/symbols in /usr/bin/* binaries |
| `show_opscodes_sb` | List opcodes/symbols in /sbin/* binaries    |
| `gdb_py`           | Run Python interpreter under GDB debugger   |

---

## Display

Source: [display.sh](bash/autoload/display.sh)

| Alias        | Purpose                                                   |
| ------------ | --------------------------------------------------------- |
| `c`          | Clear terminal screen                                     |
| `disp`       | Source display export script for X11 forwarding           |
| `disp_local` | Set DISPLAY=:0 for local X11 sessions                     |
| `disp_xserv` | Set DISPLAY to default gateway IP (for WSL/remote X)      |
| `gldirect`   | Enable direct OpenGL rendering (LIBGL_ALWAYS_INDIRECT=1)  |
| `glindirect` | Disable direct OpenGL rendering (LIBGL_ALWAYS_INDIRECT=0) |

---

## Filesystem & Navigation

Source: [filesystem.sh](bash/autoload/filesystem.sh)

### Directory Navigation

| Alias      | Purpose          |
| ---------- | ---------------- |
| `..`       | Up 1 level       |
| `...`      | Up 2 levels      |
| `....`     | Up 3 levels      |
| `.....`    | Up 4 levels      |
| `......`   | Up 5 levels      |
| `.......`  | Up 6 levels      |
| `........` | Up 7 levels      |
| `cdd`      | Back to last dir |

### Quick Directory Access

| Alias    | Purpose           |
| -------- | ----------------- |
| `drop`   | Dropbox folder    |
| `desk`   | Desktop           |
| `docs`   | Documents         |
| `down`   | Downloads         |
| `ws`     | Workspace root    |
| `wsm`    | My workspace      |
| `wsdf`   | Dotfiles          |
| `wsdfb`  | Dotfiles bin      |
| `wsdfp`  | Private dotfiles  |
| `wsws`   | Workspace file    |
| `wsmisc` | Misc workspace    |
| `wsaw`   | Awesome WM config |
| `wst`    | Temp workspace    |
| `wsv`    | vcpkg folder      |

### Listing

| Alias | Purpose                                                                |
| ----- | ---------------------------------------------------------------------- |
| `l`   | Compact listing with dirs first (`ls -CFhH --group-directories-first`) |
| `la`  | All files including hidden, human-readable sizes                       |
| `ll`  | Long format listing with all details and hidden files                  |

### File Operations

| Alias           | Purpose                                                 |
| --------------- | ------------------------------------------------------- |
| `crlf_fix`      | Convert CRLF to LF for all files recursively (dos2unix) |
| `fix_dir_755`   | Set all directories to 755 (rwxr-xr-x) recursively      |
| `fix_dir_750`   | Set all directories to 750 (rwxr-x---) recursively      |
| `fix_dir_700`   | Set all directories to 700 (rwx------) recursively      |
| `fix_files_644` | Set all files to 644 (rw-r--r--) recursively            |
| `fix_files_640` | Set all files to 640 (rw-r-----) recursively            |
| `fix_files_600` | Set all files to 600 (rw-------) recursively            |
| `fix_022`       | Standard permissions: dirs 755 + files 644 (umask 022)  |
| `fix_027`       | Group-restricted: dirs 750 + files 640 (umask 027)      |
| `fix_077`       | Private permissions: dirs 700 + files 600 (umask 077)   |
| `rmf`           | Force remove file (`rm -f`)                             |
| `rmrf`          | Recursive force remove (`rm -rf`)                       |

### Disk Usage

| Alias | Purpose                                               |
| ----- | ----------------------------------------------------- |
| `fs`  | Show file size in bytes using stat                    |
| `df`  | Disk free space in huma-readable format (`df -h`)     |
| `duc` | Calculate disk usage for folder with total (`du -hc`) |
| `mls` | List all mounts in formatted columns                  |

---

## Git

Source: [git.sh](bash/autoload/git.sh)

### Functions

| Function                         | Description                                                                                              |
| -------------------------------- | -------------------------------------------------------------------------------------------------------- |
| `gco [msg]`                      | **Git commit only** - commits staged changes. With arg: uses as message. Without: opens editor with diff |
| `gca [msg]`                      | **Git commit all** - stages everything (`git add --all`) then commits                                    |
| `gget <url>`                     | Clones repo and `cd`s into it                                                                            |
| `gcrt`                           | Clones repo into `org-reponame` folder format                                                            |
| `get_repo_with_target`           | Clones repo into `org-reponame` folder format                                                            |
| `gitreview <branch>`             | Pushes to Gerrit-style `refs/for/<branch>`                                                               |
| `gprune [branch]`                | Garbage collects and prunes obsolete refs (defaults to `main`)                                           |
| `git-fetch-all-branches`         | Tracks all remote branches locally                                                                       |
| `git-verbose On/Off [category]`  | Toggles git debug environment variables                                                                  |
| `git-commits-by-author <author>` | Shows commits filtered by author                                                                         |
| `git-insertions [from] [to]`     | Counts total insertions in date range                                                                    |

### Basic Aliases

| Alias    | Purpose               |
| -------- | --------------------- |
| `g`      | Short git             |
| `gunsec` | Skip SSL verification |
| `gb`     | List branches         |
| `gs`     | Show status           |
| `gss`    | Show status           |

### Log Aliases

| Alias | Purpose                         |
| ----- | ------------------------------- |
| `gll` | Short hash log with author/date |
| `glL` | Full hash log with author/date  |

### Clone Aliases

| Alias  | Purpose                             |
| ------ | ----------------------------------- |
| `gcr`  | Clone with submodules               |
| `gcb`  | Clone single branch                 |
| `gcrb` | Clone single branch with submodules |

### Show Commits (`gw*`)

| Alias         | Shows                              |
| ------------- | ---------------------------------- |
| `gw`          | Current commit (HEAD)              |
| `gw^`         | HEAD^ (1 back)                     |
| `gww`         | HEAD^ (1 back)                     |
| `gw^^`        | HEAD^^ (2 back)                    |
| `gwww`        | HEAD^^ (2 back)                    |
| `gw^^^`       | HEAD^^^ (3 back)                   |
| `gwwww`       | HEAD^^^ (3 back)                   |
| `gw^^^^`      | HEAD^^^^ (4 back)                  |
| `gwwwww`      | HEAD^^^^ (4 back)                  |
| `gw^^^^^`     | HEAD^^^^^ (5 back)                 |
| `gwwwwww`     | HEAD^^^^^ (5 back)                 |
| `gw^^^^^^`    | HEAD^^^^^^ (6 back)                |
| `gwwwwwww`    | HEAD^^^^^^ (6 back)                |
| `gw^^^^^^^`   | HEAD^^^^^^^ (7 back)               |
| `gwwwwwwww`   | HEAD^^^^^^^ (7 back)               |
| `gw^^^^^^^^`  | HEAD^^^^^^^^ (8 back)              |
| `gwwwwwwwww`  | HEAD^^^^^^^^ (8 back)              |
| `ggw`         | Current commit (delta pager)       |
| `ggw^`        | HEAD^ (1 back, delta pager)        |
| `ggww`        | HEAD^ (1 back, delta pager)        |
| `ggw^^`       | HEAD^^ (2 back, delta pager)       |
| `ggwww`       | HEAD^^ (2 back, delta pager)       |
| `ggw^^^`      | HEAD^^^ (3 back, delta pager)      |
| `ggwwww`      | HEAD^^^ (3 back, delta pager)      |
| `ggw^^^^`     | HEAD^^^^ (4 back, delta pager)     |
| `ggwwwww`     | HEAD^^^^ (4 back, delta pager)     |
| `ggw^^^^^`    | HEAD^^^^^ (5 back, delta pager)    |
| `ggwwwwww`    | HEAD^^^^^ (5 back, delta pager)    |
| `ggw^^^^^^`   | HEAD^^^^^^ (6 back, delta pager)   |
| `ggwwwwwww`   | HEAD^^^^^^ (6 back, delta pager)   |
| `ggw^^^^^^^`  | HEAD^^^^^^^ (7 back, delta pager)  |
| `ggwwwwwwww`  | HEAD^^^^^^^ (7 back, delta pager)  |
| `ggw^^^^^^^^` | HEAD^^^^^^^^ (8 back, delta pager) |
| `ggwwwwwwwww` | HEAD^^^^^^^^ (8 back, delta pager) |

### Diff Aliases

| Alias | Purpose                                                  |
| ----- | -------------------------------------------------------- |
| `gd`  | Show diff between working directory and HEAD             |
| `ggd` | Show diff with delta pager (code-review-chameleon theme) |
| `gdo` | Show diff of staged/cached changes only (`--cached`)     |

### Add & Commit

| Alias   | Purpose                                 |
| ------- | --------------------------------------- |
| `ga`    | `git add`                               |
| `gc`    | `git commit -v` (verbose)               |
| `gcn`   | Commit with dirname as message          |
| `gcnd`  | Commit with dirname + timestamp         |
| `gcns`  | Commit with dirname, GPG-signed         |
| `gcnds` | Commit with dirname + timestamp, signed |
| `gcof`  | Commit with `--no-verify`               |
| `gcaf`  | Add + commit with `--no-verify`         |
| `gam`   | Amend commit                            |
| `gamne` | Amend without editing message           |
| `gamm`  | Add all + amend reusing message         |

### Cleanup

| Alias     | Purpose                                                                 |
| --------- | ----------------------------------------------------------------------- |
| `gcac`    | Stage all + commit with message "Cleanup."                              |
| `gcoc`    | Commit staged changes with message "Cleanup."                           |
| `gcaw`    | Stage all + commit with message "Whitespace."                           |
| `gcow`    | Commit staged changes with message "Whitespace."                        |
| `gfr`     | Fetch all remotes + hard reset to current upstream                      |
| `gfrmn`   | Fetch all + hard reset to origin/main                                   |
| `gfrms`   | Fetch all + hard reset to origin/master                                 |
| `gclean`  | Hard reset + remove untracked files/dirs including ignored (`-d -x -f`) |
| `gclean2` | Hard reset + remove only ignored files (`-d -X -f`)                     |
| `gclean3` | Hard reset + remove untracked but keep ignored (`-d -f`)                |

### Pull

| Alias    | Purpose                                          |
| -------- | ------------------------------------------------ |
| `gpl`    | Pull current branch from origin remote           |
| `gpl_gh` | Pull current branch from github remote           |
| `gplm`   | Pull + recursively update all submodules         |
| `gplmn`  | Pull main branch from origin                     |
| `gplms`  | Pull master branch from origin                   |
| `gpln`   | Pull without rebase (merge strategy)             |
| `gplp`   | Pull with rebase then push (sync workflow)       |
| `gpls`   | Stash changes → pull → restore stash (safe pull) |

### Push

| Alias   | Purpose                                                  |
| ------- | -------------------------------------------------------- |
| `gpp`   | Push to remote (`git push`)                              |
| `gppa`  | Stage all + commit with dirname+date message + push      |
| `gppas` | Stage all + commit with dirname+date (GPG signed) + push |
| `gppg`  | Push to github remote                                    |
| `gppt`  | Push all tags to remote (`git push --tags`)              |
| `gppu`  | Push and set upstream tracking (`-u` flag)               |
| `gps`   | Stash changes → push → restore stash (safe push)         |

### Checkout

| Alias   | Purpose                                                |
| ------- | ------------------------------------------------------ |
| `gck`   | Checkout branch or file (`git checkout`)               |
| `gckb`  | Create and checkout new branch (`-b` flag)             |
| `gckt`  | Toggle to previous branch (`git checkout -`)           |
| `gckmn` | Checkout main branch                                   |
| `gckms` | Checkout master branch                                 |
| `gabr`  | Create local tracking branches for all remote branches |

### Branch Management

| Alias       | Purpose                                                |
| ----------- | ------------------------------------------------------ |
| `gbr`       | Delete local branch safely (`-d`, must be merged)      |
| `gbrf`      | Force delete local branch (`-D`, even if unmerged)     |
| `gbrr`      | Delete remote branch (`git push origin --delete`)      |
| `g-to-main` | Rename master→main + update remote tracking + set HEAD |

### Rebase

| Alias                    | Purpose                                        |
| ------------------------ | ---------------------------------------------- |
| `gcp`                    | Cherry-pick                                    |
| `gfrbd`                  | Fetch + rebase onto Development                |
| `gfrbmn`                 | Fetch + rebase onto main                       |
| `gfrbms`                 | Fetch + rebase onto master                     |
| `grb`                    | Interactive rebase on origin/                  |
| `grba`                   | Abort rebase                                   |
| `grbc`                   | Add all + continue rebase                      |
| `grbd`                   | Interactive rebase on origin/Development       |
| `grbmn`                  | Interactive rebase on origin/main              |
| `grbms`                  | Interactive rebase on origin/master            |
| `gCH`                    | Interactive rebase from root (rewrite history) |
| `git-rebase-Development` | Fetch + rebase onto Development                |
| `git-rebase-main`        | Fetch + rebase onto main                       |
| `git-rebase-master`      | Fetch + rebase onto master                     |

### Tags

| Alias   | Purpose                                        |
| ------- | ---------------------------------------------- |
| `grmt`  | Delete local tag (`git tag --delete`)          |
| `grmto` | Delete remote tag (`git push --delete origin`) |

### Submodules & Bulk Operations

| Alias  | Purpose                                                   |
| ------ | --------------------------------------------------------- |
| `gsu`  | Update all submodules recursively to latest remote refs   |
| `ugr`  | Pull all git repos in current directory (bulk update)     |
| `ugrs` | Pull all git repos in all subdirectories (recursive bulk) |

### Misc

| Alias   | Purpose                                    |
| ------- | ------------------------------------------ |
| `gex`   | Open GitExtensions GUI (Windows/Mono)      |
| `ginfo` | List accessible repos from Gitolite server |

---

## Grep & Text Processing

Source: [grep.sh](bash/autoload/grep.sh)

| Alias  | Purpose                                          |
| ------ | ------------------------------------------------ |
| `gerp` | Typo correction alias for grep                   |
| `gHS`  | Grep for "status" or "health" keywords in output |
| `tf`   | Follow file changes with tail (`tail -F -n200`)  |

---

## IDE & Editors

Source: [ide.sh](bash/autoload/ide.sh)

| Alias   | Purpose                                                  |
| ------- | -------------------------------------------------------- |
| `icode` | Open file/folder in configured editor (via `e` function) |
| `ee`    | Open current directory in default editor                 |
| `ww`    | Open workspace configuration file                        |
| `vssp`  | Copy CMakePresets template + open project in VS Code     |

---

## Kubernetes

Source: [kubernetes.sh](bash/autoload/kubernetes.sh)

### Docker Desktop Context

| Alias              | Purpose                                            |
| ------------------ | -------------------------------------------------- |
| `kdocker`          | kubectl using docker-desktop context               |
| `hdocker`          | helm using docker-desktop context                  |
| `kdocker_proxy`    | Start kubectl proxy on port 10001 for API access   |
| `kdocker_port_fwd` | Port forward local port to Kubernetes service      |
| `kdocker_consul`   | Port forward to Consul service (service discovery) |
| `kdocker_rabbit`   | Port forward to RabbitMQ service (message queue)   |

### Environment Shortcuts (Dev/DevOps/Stage/Prod × CN/EU/US)

Pattern: `k<env>[region]_<action>` where:
- `env`: `dev`, `devops`, `stage`, `prod`
- `region`: `cn`, `eu`, `us` (or none for default)
- `action`: `proxy`, `port_fwd`, `consul`, `rabbit`

---

## KVM / Virtualization

Source: [kvm.sh](bash/autoload/kvm.sh)

| Alias         | Purpose                                       |
| ------------- | --------------------------------------------- |
| `check_iommu` | Verify IOMMU/VT-d support for GPU passthrough |

---

## Make

Source: [make.sh](bash/autoload/make.sh)

| Alias            | Purpose                                                  |
| ---------------- | -------------------------------------------------------- |
| `make_uninstall` | Uninstall CMake-installed project using install manifest |

---

## Miscellaneous

Source: [misc.sh](bash/autoload/misc.sh)

| Alias   | Purpose                                                             |
| ------- | ------------------------------------------------------------------- |
| `map`   | Map function over stdin lines (`xargs -n1`) - e.g., `find .         | map dirname` |
| `alert` | Desktop notification when command finishes (use: `sleep 10; alert`) |

---

## Monitoring

Source: [monitoring.sh](bash/autoload/monitoring.sh)

| Alias | Purpose                                    |
| ----- | ------------------------------------------ |
| `pg`  | Search processes by name (`ps aux          | grep -i`) |
| `top` | Run top sorted by CPU usage (`top -o%CPU`) |

---

## Network

Source: [network.sh](bash/autoload/network.sh)

| Alias      | Purpose                                                      |
| ---------- | ------------------------------------------------------------ |
| `localip`  | Display all local IP addresses from network interfaces       |
| `sniffe`   | Sniff HTTP GET/POST on Ethernet (enp0s31f6) port 80          |
| `sniffw`   | Sniff HTTP GET/POST on WiFi (wlp2s0) port 80                 |
| `httpdump` | Dump HTTP traffic with tcpdump showing Host and GET requests |
| `fw_list`  | List all iptables firewall rules with counters (`-nvL`)      |

---

## Node.js / npm

Source: [nodejs.sh](bash/autoload/nodejs.sh)

| Alias                      | Purpose                                            |
| -------------------------- | -------------------------------------------------- |
| `npm-update`               | Update npm itself to latest version globally       |
| `npm-list-local`           | List locally installed packages in current project |
| `npm-list-global`          | List globally installed npm packages               |
| `npm-list-local-outdated`  | Check for outdated packages in current project     |
| `npm-list-global-outdated` | Check for outdated global packages                 |
| `npm-update-local`         | Update all local packages to latest versions       |
| `npm-update-global`        | Update all global packages to latest versions      |

---

## Python

Source: [python.sh](bash/autoload/python.sh)

### Virtual Environments (venv/)

| Alias | Purpose                                                      |
| ----- | ------------------------------------------------------------ |
| `vc`  | Create virtual environment in `./venv/` using default Python |
| `vc2` | Create virtual environment using Python 2                    |
| `vc3` | Create virtual environment using Python 3                    |
| `va`  | Activate virtual environment from `./venv/bin/activate`      |
| `vr`  | Remove `./venv/` directory completely                        |

### Virtual Environments (.venv/)

| Alias  | Purpose                                                       |
| ------ | ------------------------------------------------------------- |
| `vcd`  | Create virtual environment in `./.venv/` using default Python |
| `vc2d` | Create `.venv/` using Python 2                                |
| `vc3d` | Create `.venv/` using Python 3                                |
| `vad`  | Activate virtual environment from `./.venv/bin/activate`      |
| `vrd`  | Remove `./.venv/` directory completely                        |

### Package Management

| Alias        | Purpose                                               |
| ------------ | ----------------------------------------------------- |
| `vd`         | Deactivate current virtual environment                |
| `vpi`        | Install package with pip (`python -m pip install`)    |
| `vpip`       | Upgrade pip to latest version                         |
| `vgen`       | Generate requirements.txt from installed packages     |
| `vinsr`      | Install packages from requirements.txt if exists      |
| `vinsd`      | Install packages from requirements-dev.txt if exists  |
| `vinsm`      | Install packages from requirements-misc.txt if exists |
| `pip-update` | Upgrade pip to latest version                         |
| `pip_update` | Update pip via py_venv function                       |

### Utilities

| Alias             | Purpose                                             |
| ----------------- | --------------------------------------------------- |
| `ipython-install` | Install IPython in current environment              |
| `srv`             | Start Python HTTP server on port 8000 for local dev |

---

## Ruby

Source: [ruby.sh](bash/autoload/ruby.sh)

| Alias | Purpose                                           |
| ----- | ------------------------------------------------- |
| `rre` | Execute Ruby script (`ruby exec`)                 |
| `rgi` | Install Ruby gem (`gem install`)                  |
| `rbi` | Install bundle dependencies (`bundle install`)    |
| `rbu` | Update bundle dependencies (`bundle update`)      |
| `rbe` | Execute command in bundle context (`bundle exec`) |

---

## Security & GPG

Source: [security.sh](bash/autoload/security.sh)

| Alias               | Purpose                                                            |
| ------------------- | ------------------------------------------------------------------ |
| `sudo`              | Sudo preserving environment variables (`sudo -E`)                  |
| `rot13`             | ROT13 cipher encode/decode using tr                                |
| `sha`               | Calculate SHA256 hash of file (`shasum -a 256`)                    |
| `genpass`           | Generate random password using OpenSSL base64                      |
| `ssl_check_client`  | Test SSL/TLS connection to server (`openssl s_client -connect`)    |
| `decodecert`        | Decode and display X.509 certificate details from stdin            |
| `gpg_show_keys`     | List GPG secret keys with long key IDs                             |
| `ggg`               | Verbose dry-run GPG import test (shows key details without import) |
| `gpg_show_key_info` | Show GPG key info and fingerprint without importing                |
| `gpg_search_ubuntu` | Search for GPG keys on Ubuntu keyserver                            |
| `gpg_search_sks`    | Search for GPG keys on SKS keyserver pool                          |
| `gpg_search_mit`    | Search for GPG keys on MIT keyserver                               |

---

## Software

Source: [software.sh](bash/autoload/software.sh)

| Alias        | Purpose                                          |
| ------------ | ------------------------------------------------ |
| `chromekill` | Kill all Chrome renderer processes (free memory) |

---

## System

Source: [system.sh](bash/autoload/system.sh)

| Alias                  | Purpose                                                        |
| ---------------------- | -------------------------------------------------------------- |
| `clear_mem_1`          | Drop pagecache (`echo 1 > /proc/sys/vm/drop_caches`)           |
| `clear_mem_2`          | Drop dentries and inodes (`echo 2 > /proc/sys/vm/drop_caches`) |
| `clear_mem_3`          | Drop all caches: pagecache + dentries + inodes                 |
| `get_all_capabilities` | Decode and display all Linux capabilities from CapBnd          |

---

## Terraform

Source: [terraform.sh](bash/autoload/terraform.sh)

| Alias       | Purpose                                                      |
| ----------- | ------------------------------------------------------------ |
| `terrafrom` | Typo correction alias for terraform                          |
| `t`         | Short alias for terraform command                            |
| `ti`        | Initialize Terraform working directory (`terraform init`)    |
| `ta`        | Apply saved plan (`terraform apply terraform.plan`)          |
| `tp`        | Create execution plan (`terraform plan -out terraform.plan`) |
| `tpd`       | Create destroy plan (`terraform plan -destroy`)              |
| `tw`        | Terraform workspace management command                       |
| `twd`       | Delete workspace (`terraform workspace delete`)              |
| `twn`       | Create new workspace (`terraform workspace new`)             |
| `twl`       | List all workspaces (`terraform workspace list`)             |
| `tws`       | Select/switch workspace (`terraform workspace select`)       |

---

## Tmux

Source: [tmux.sh](bash/autoload/tmux.sh)

| Alias   | Purpose                                                |
| ------- | ------------------------------------------------------ |
| `tmux`  | Start tmux with 256 colors and UTF-8 support (`-2 -u`) |
| `tm`    | Short alias for tmux                                   |
| `tma`   | Attach to most recent tmux session                     |
| `tmat`  | Attach to specific named session (`tmux attach -t`)    |
| `tmns`  | Create new named session (`tmux new-session -s`)       |
| `tmls`  | List all active tmux sessions                          |
| `tcopy` | Copy tmux buffer to system clipboard (macOS pbcopy)    |

---

## UGR (SSH Shortcuts)

Source: [ugr.sh](bash/autoload/ugr.sh)

| Alias      | Purpose         |
| ---------- | --------------- |
| `compute1` | SSH to compute1 |
| `compute2` | SSH to compute2 |
| `compute3` | SSH to compute3 |
| `compute4` | SSH to compute4 |
| `compute5` | SSH to compute5 |

---

## vcpkg

Source: [vcpkg.sh](bash/autoload/vcpkg.sh)

### Linux

| Alias             | Purpose                                         |
| ----------------- | ----------------------------------------------- |
| `vcpkg-remove`    | Remove package for x64-linux triplet            |
| `vcpkg-install`   | Install package for x64-linux triplet           |
| `vcpkg-remove-r`  | Remove package with dependencies (`--recurse`)  |
| `vcpkg-install-r` | Install package with dependencies (`--recurse`) |

### macOS

| Alias                 | Purpose                                         |
| --------------------- | ----------------------------------------------- |
| `vcpkg-remove-osx`    | Remove package for x64-osx triplet              |
| `vcpkg-install-osx`   | Install package for x64-osx triplet             |
| `vcpkg-remove-osx-r`  | Remove package with dependencies (`--recurse`)  |
| `vcpkg-install-osx-r` | Install package with dependencies (`--recurse`) |

---

## WASM

Source: [wasm.sh](bash/autoload/wasm.sh)

| Alias        | Purpose                                    |
| ------------ | ------------------------------------------ |
| `wasm_build` | Build WebAssembly project using Emscripten |

---

## Wayland

Source: [wayland.sh](bash/autoload/wayland.sh)

| Alias                 | Purpose                                           |
| --------------------- | ------------------------------------------------- |
| `wayland_enable_root` | Allow root user to access Wayland display (xhost) |

---

## Web & Weather

Source: [web.sh](bash/autoload/web.sh)

| Alias        | Purpose                                              |
| ------------ | ---------------------------------------------------- |
| `urlencode`  | URL encode a string for safe use in URLs             |
| `weather`    | Show weather forecast for current location (wttr.in) |
| `w-mad`      | Weather forecast for Madrid                          |
| `w-mal`      | Weather forecast for Malaga                          |
| `w-mos`      | Weather forecast for Moscow                          |
| `weather_v2` | Weather in alternative format (wttr.in v2)           |
| `w-mad-v2`   | Weather v2 format for Madrid                         |
| `w-mal-v2`   | Weather v2 format for Malaga                         |
| `w-mos-v2`   | Weather v2 format for Moscow                         |
