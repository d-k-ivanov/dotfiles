#!/usr/bin/env bash

# Set PATHs
platform=`uname`
case $platform in
    Linux )
        export PATH=.
        # Local
        [[ -d $HOME/.bin ]]                         && export PATH=$PATH:$HOME/.bin
        [[ -d $HOME/.bin/linux ]]                   && export PATH=$PATH:$HOME/.bin/linux
        [[ -d $HOME/.local/bin ]]                   && export PATH=$PATH:$HOME/.local/bin
        # Android
        [[ -d "$HOME/Android/Sdk/platform-tools" ]] && export PATH=$PATH:$HOME/Android/Sdk/platform-tools
        # CLion
        [[ -d $HOME/CLion/bin ]]                    && export PATH=$PATH:$HOME/CLion/bin
        # CUDA
        [[ -d /usr/local/cuda-12.3/bin ]]           && export PATH=$PATH:/usr/local/cuda-12.3/bin
        [[ -d /usr/local/cuda-12.2/bin ]]           && export PATH=$PATH:/usr/local/cuda-12.2/bin
        [[ -d /usr/local/cuda-11.0/bin ]]           && export PATH=$PATH:/usr/local/cuda-12.0/bin
        # LLVM
        [[ -d /usr/lib/llvm/6/bin ]]                && export PATH=$PATH:/usr/lib/llvm/6/bin
        # Qt
        [[ -d $HOME/Qt/Tools/QtCreator/bin ]]       && export PATH=$PATH:$HOME/Qt/Tools/QtCreator/bin
        [[ -d /opt/Qt/Tools/QtCreator/bin ]]        && export PATH=$PATH:/opt/Qt/Tools/QtCreator/bin
        # Python (autovenv)
        # [[ -f $HOME/.bash/venv.sh ]]                && source ~/.bash/venv.sh
        # Ruby
        [[ -s "$HOME/.rvm/scripts/rvm" ]]           && source "$HOME/.rvm/scripts/rvm"
        [[ -d "$HOME/.rvm/bin" ]]                   && export PATH=$PATH:$HOME/.rvm/bin
        # [[ -d "$HOME/.rvm/rubies/ruby-2.6.1" ]]     && rvm use 2.6.1
        # Rust
        [[ -d "$HOME/.cargo/bin" ]]                 && export PATH=$PATH:$HOME/.cargo/bin
        # Ubuntu games
        [[ -d /usr/games ]]                         && export PATH=$PATH:/usr/games
        [[ -d /usr/local/games ]]                   && export PATH=$PATH:/usr/local/games
        # Snap
        [[ -d /snap/bin ]]                          && export PATH=$PATH:/snap/bin
        [[ -d /var/lib/snapd/snap/bin ]]            && export PATH=$PATH:/var/lib/snapd/snap/bin
        # VCPKG
        [[ -f $VCPKG_ROOT/vcpkg ]]                  && export PATH=$PATH:$VCPKG_ROOT
        # Yarn
        [[ -d "$HOME/.yarn/bin" ]]                  && export PATH=$PATH:$HOME/.yarn/bin

        # General paths
        ## Opt
        [[ -d /opt/bin ]]                           && export PATH=$PATH:/opt/bin
        [[ -d /opt/local/bin ]]                     && export PATH=$PATH:/opt/local/bin
        [[ -d /opt/local/sbin ]]                    && export PATH=$PATH:/opt/local/sbin
        ## User's
        [[ -d /bin ]]                               && export PATH=$PATH:/bin
        [[ -d /usr/bin ]]                           && export PATH=$PATH:/usr/bin
        [[ -d /usr/local/bin ]]                     && export PATH=$PATH:/usr/local/bin
        ## Root binaries
        [[ -d /sbin ]]                              && export PATH=$PATH:/sbin
        [[ -d /usr/sbin ]]                          && export PATH=$PATH:/usr/sbin
        [[ -d /usr/local/sbin ]]                    && export PATH=$PATH:/usr/local/sbin

        ## Perl binaries
        [[ -d /usr/bin/site_perl ]]                 && export PATH=$PATH:/usr/bin/site_perl
        [[ -d /usr/bin/vendor_perl ]]               && export PATH=$PATH:/usr/bin/vendor
        [[ -d /usr/bin/core_perl ]]                 && export PATH=$PATH:/usr/bin/core_perl
        ;;
    Darwin )
        export PATH=.
        # Local
        [[ -d $HOME/.bin ]]                         && export PATH=$PATH:$HOME/.bin
        [[ -d $HOME/.bin/mac ]]                     && export PATH=$PATH:$HOME/.bin/mac
        [[ -d $HOME/.local/bin ]]                   && export PATH=$PATH:$HOME/.local/bin
        # Python (autovenv)
        # [[ -f $HOME/.bash/venv.sh ]]                && source ~/.bash/venv.sh
        # Ruby
        [[ -s "$HOME/.rvm/scripts/rvm" ]]           && source "$HOME/.rvm/scripts/rvm"
        # VS Code
        [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]] && export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
        # [[ -f "/usr/libexec/java_home" ]]           && export JAVA_HOME="$(/usr/libexec/java_home -v 1.8)" ### ????
        # Work
        [[ -d $HOME/thirdparty ]]                   && export THIRDPARTY_LOCATION=$HOME/thirdparty
        [[ -d $HOME/testdata ]]                     && export TESTDATA_LOCATION=$HOME/testdata

        # General paths
        ## Opt
        [[ -d /opt/bin ]]                           && export PATH=$PATH:/opt/bin
        [[ -d /opt/local/bin ]]                     && export PATH=$PATH:/opt/local/bin
        [[ -d /opt/local/sbin ]]                    && export PATH=$PATH:/opt/local/sbin
        ## User's
        [[ -d /usr/bin ]]                           && export PATH=$PATH:/usr/bin
        [[ -d /usr/local/bin ]]                     && export PATH=$PATH:/usr/local/bin
        [[ -d /usr/local/sbin ]]                    && export PATH=$PATH:/usr/local/sbin
        ## Root binaries
        [[ -d /bin ]]                               && export PATH=$PATH:/bin
        [[ -d /sbin ]]                              && export PATH=$PATH:/sbin
        [[ -d /usr/sbin ]]                          && export PATH=$PATH:/usr/sbin
        ;;
    MSYS_NT-10.0 )
        [[ -d $HOME/.bin ]]                         && export PATH=$HOME/.bin:$HOME/.bin/win:$PATH
        ;;
esac

list-paths()
{
    for path in $(echo $PATH | tr ":" "\n"); do
        echo $path
    done
}
