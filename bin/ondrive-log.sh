#!/usr/bin/env bash
black=$(tput setaf 0)
red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)
cyan=$(tput setaf 6)
white=$(tput setaf 7)

normal=$(tput sgr0)
journalctl -o cat --user-unit ${1:-onedrive} -f |
    ag -v 'Remaining free space' | # removing unwanted lines from log
    sed -u "s/Uploading/$(printf "${blue}Uploading${normal}")/;
          s/Successfully created/$(printf "${blue}Successfully created${normal}")/;
          s/Downloading/$(printf "${magenta}Downloading${normal}")/;
          s/Moving/$(printf "${magenta}Moving${normal}")/;
          s/Deleting/$(printf "${yellow}Deleting${normal}")/;
          s/deleted/$(printf "${yellow}deleted${normal}")/gI;
          " |                # changing colors of words
    ccze -A -c default=white # |                        # nice program to colorize log
#>> /tmp/tmp1.txt
# ag --passthru "↗ |Stopping|Stopped|Uploading|Downloading|Error|Deleting"
# s/error/$(printf "${red}❎ERROR${normal}")/gI;
# s/done./$(printf "${green}✔${normal}")/
