#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
        echo "ERROR: Not running as root"
        exit 1
fi

readonly parentDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

function setLocalBinTools() {
    while read line; do
        local scriptBaseName=$(basename "${line}")
        local linkBaseName="${scriptBaseName:0:-3}"
        local linkPath="/usr/local/bin/${linkBaseName}"

        if [[ -L "${linkPath}" ]]; then 
            
            # Checking whether the link target fits
            local actualLinkTarget="$(readlink ${linkPath})"
            if [[ "${actualLinkTarget}" != "${line}" ]]; then
                printf "wrong link target from '${linkPath}' to '${actualLinkTarget}'\t\t"
                rm "${linkPath}"
                ln -s "${line}" "${linkPath}"
                printf "fixed"
            else
                printf "${linkPath}\tok"
            fi

        else
            printf "creating missing link to '${line}'"
            ln -s "${line}" "${linkPath}"
        fi
        echo ""
    done <<< "$(find ${parentDir}/bin-scripts -type f -name \*.sh)"
}

function main() {
    setLocalBinTools
}

main
