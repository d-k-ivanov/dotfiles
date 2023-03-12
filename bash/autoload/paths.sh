#!/usr/bin/env bash

# Set PATHs
platform=`uname`
case $platform in
    Linux )
        # Local
        [[ -d $HOME/.bin ]]                         && export PATH=$HOME/.bin
        [[ -d $HOME/.local/bin ]]                   && export PATH=$PATH:$HOME/.local/bin
        # Qt
        [[ -d $HOME/Qt/Tools/QtCreator/bin ]]       && export PATH=$PATH:$HOME/Qt/Tools/QtCreator/bin
        [[ -d /opt/Qt/Tools/QtCreator/bin ]]        && export PATH=$PATH:/opt/Qt/Tools/QtCreator/bin
        # CLion
        [[ -d $HOME/CLion/bin ]]                    && export PATH=$PATH:$HOME/CLion/bin
        # LLVM
        [[ -d /usr/lib/llvm/6/bin ]]                && export PATH=$PATH:/usr/lib/llvm/6/bin
        # Ruby
        [[ -s "$HOME/.rvm/scripts/rvm" ]]           && source "$HOME/.rvm/scripts/rvm"
        [[ -d "$HOME/.rvm/bin" ]]                   && export PATH=$PATH:$HOME/.rvm/bin
        # [[ -d "$HOME/.rvm/rubies/ruby-2.6.1" ]]     && rvm use 2.6.1
        # Rust
        [[ -d "$HOME/.cargo/bin" ]]                 && export PATH=$PATH:$HOME/.cargo/bin
        # Yarn
        [[ -d "$HOME/.yarn/bin" ]]                  && export PATH=$PATH:$HOME/.yarn/bin
        # Android
        [[ -d "$HOME/Android/Sdk/platform-tools" ]] && export PATH=$PATH:$HOME/Android/Sdk/platform-tools
        # Python
        [[ -d $PYENV_ROOT ]]                        && export PATH="$PYENV_ROOT/bin:$PATH"
        # [[ -f $HOME/.bash/venv.sh ]]                && source ~/.bash/venv.sh
        # Opt
        [[ -d /opt/bin ]]                           && export PATH=$PATH:/opt/bin
        # User's
        [[ -d /bin ]]                               && export PATH=$PATH:/bin
        [[ -d /usr/bin ]]                           && export PATH=$PATH:/usr/bin
        [[ -d /usr/local/bin ]]                     && export PATH=$PATH:/usr/local/bin
        [[ -d /opt/local/bin ]]                     && export PATH=$PATH:/opt/local/bin
        [[ -d /opt/bin ]]                           && export PATH=$PATH:/opt/bin
        # Snap
        [[ -d /snap/bin ]]                          && export PATH=$PATH:/snap/bin
        [[ -d /var/lib/snapd/snap/bin ]]            && export PATH=$PATH:/var/lib/snapd/snap/bin
        # Ubuntu games
        [[ -d /usr/games ]]                         && export PATH=$PATH:/usr/games
        [[ -d /usr/local/games ]]                   && export PATH=$PATH:/usr/local/games
        # Root binaries
        [[ -d /sbin ]]                              && export PATH=$PATH:/sbin
        [[ -d /usr/sbin ]]                          && export PATH=$PATH:/usr/sbin
        [[ -d /usr/local/sbin ]]                    && export PATH=$PATH:/usr/local/sbin
        [[ -d /opt/local/sbin ]]                    && export PATH=$PATH:/opt/local/sbin
        ;;
    Darwin )
        [[ -d /usr/local/bin ]]                     && export PATH=/usr/local/bin
        [[ -d /usr/local/sbin ]]                    && export PATH=$PATH:/usr/local/sbin
        [[ -d /usr/local/opt/python3/bin ]]         && export PATH=$PATH:/usr/local/opt/python3/bin
        [[ -d $HOME/Library/Python/3.6/bin ]]       && export PATH=$PATH:Library/Python/3.6/bin
        [[ -d $HOME/Library/Python/3.7/bin ]]       && export PATH=$PATH:Library/Python/3.6/bin
        [[ -d $HOME/Library/Python/3.8/bin ]]       && export PATH=$PATH:Library/Python/3.6/bin
        [[ -d $HOME/Library/Python/3.9/bin ]]       && export PATH=$PATH:Library/Python/3.6/bin
        [[ -d /usr/local/opt/python2/bin ]]         && export PATH=$PATH:/usr/local/opt/python2/bin
        [[ -d $HOME/Library/Python/2.7/bin ]]       && export PATH=$PATH:Library/Python/2.7/bin
        [[ -d /usr/bin ]]                           && export PATH=$PATH:/usr/bin
        [[ -d /bin ]]                               && export PATH=$PATH:/bin
        [[ -d /usr/sbin ]]                          && export PATH=$PATH:/usr/sbin
        [[ -d /sbin ]]                              && export PATH=$PATH:/sbin
        [[ -d $HOME/.bin ]]                         && export PATH=$PATH:$HOME/.bin
        [[ -d $HOME/.local/bin ]]                   && export PATH=$PATH:$HOME/.local/bin
        # Ruby
        [[ -s "$HOME/.rvm/scripts/rvm" ]]           && source "$HOME/.rvm/scripts/rvm"
        # VS Code
        [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && \
            export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        [[ -f "/usr/libexec/java_home" ]]           && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)"

        # Work
        [[ -d $HOME/thirdparty ]]                   && export THIRDPARTY_LOCATION=$HOME/thirdparty
        [[ -d $HOME/testdata ]]                     && export TESTDATA_LOCATION=$HOME/testdata

        ;;
    MSYS_NT-10.0 )
        [[ -d $HOME/.bin ]]                         && export PATH=$HOME/.bin:$PATH
        echo
        ;;
esac

list-paths()
{
    for path in $(echo $PATH | tr ":" "\n"); do
        echo $path
    done
}
