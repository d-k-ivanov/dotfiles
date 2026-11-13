#!/usr/bin/env bash

remove-kmail-settings()
{
    local remove_local_mail=false

    # Parse function arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --remove-local-mail)
                remove_local_mail=true
                shift
                ;;
            *)
                shift
                ;;
        esac
    done

    akonadictl stop

    sleep 2

    rm -rf $HOME/.config/akonadi*
    rm -rf $HOME/.config/emaildefaults
    rm -rf $HOME/.config/emailidentities
    rm -rf $HOME/.config/foldermailarchiverc
    rm -rf $HOME/.config/kmail2rc
    rm -rf $HOME/.config/kmailsearchindexingrc
    rm -rf $HOME/.config/mailtransports
    rm -rf $HOME/.config/specialmailcollectionsrc

    rm -rf $HOME/.local/share/akonadi*
    rm -rf $HOME/.local/share/kmail2

    if [ "$remove_local_mail" = true ]; then
        rm -rf $HOME/.local/share/local-mail
    fi

    rm -rf $HOME/.cache/akonadi*
    rm -rf $HOME/.cache/kmail2
}
