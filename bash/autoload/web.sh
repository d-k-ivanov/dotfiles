#!/usr/bin/env bash

alias wget-cc="wget --user '${CC_NEXUS_USER}' --password '${CC_NEXUS_PASSWORD}' "
alias curl-cc="curl -L -u '${CC_NEXUS_USER}:${CC_NEXUS_PASSWORD}' "

# URL-encode strings
alias urlencode='python -c "import sys, urllib.parse; print(urllib.parse.quote(str(sys.argv[1])));"'

# One of janmoesen's ProTips. Preinstall: cpan install lwp-request
for method in GET HEAD POST PUT DELETE TRACE OPTIONS
do
    alias "$method"="lwp-request -m '$method'"
done

# Weather
alias weather="curl http://wttr.in/"
alias w-mad="curl http://wttr.in/Madrid"
alias w-mal="curl http://wttr.in/Malaga"
alias w-mos="curl http://wttr.in/Moscow"

alias weather_v2="curl http://v2.wttr.in/"
alias w-mad-v2="curl http://v2.wttr.in/Madrid"
alias w-mal-v2="curl http://v2.wttr.in/Malaga"
alias w-mos-v2="curl http://v2.wttr.in/Moscow"
