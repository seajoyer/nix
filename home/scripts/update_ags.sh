#!/usr/bin/env sh

AGS=${HOME}'/.config/ags'
AGS_BKP=${HOME}'/.config/ags_tmp'

YELLOW='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

mkdir -p ${AGS}

to_copy='js/bar/buttons/DateButton.js js/services/theme/theme.js js/services/asusctl.js js/options.js'

function backup {
    cd "${AGS}" || { echo "Couldn't cd to ags directory"; exit 1; }
    for file in $to_copy
    do
        if cp --parents "${file}" "${AGS_BKP}"
        then
            printf "${GREEN}✔${NC} %s ${GREEN}copied${NC}:\n" "${file}"
            if [[ ${file} == *"DateButton.js"* ]]
            then
                printf "\tChange the date format\n"
            elif [[ ${file} == *"theme.js"* ]]
            then
                printf "\tChange the logo path\n"
            elif [[ ${file} == *"asusctl.js"* ]]
            then
                printf "\tJust copy the file, we don't use asus\n"
            elif [[ ${file} == *"themes.js"* ]]
            then
                printf "\tChange wallpapers, bar type, border color, etc...\n"
            elif [[ ${file} == *"options.js"* ]]
            then
                printf "\tCustomize pinned apps and focused client's look\n"
            else
                printf "${RED}There is no instructions for \"%s\"\n" "${file}"
            fi
        else
            printf "${RED}✘${NC} %s ${RED}couldn't copy ${NC}\n"  "${file}"
        fi
    done
}

read -r -p "Push changes to GitHub [y/N] " response
response=${response,,}    # tolower
if [[ "${response}" =~ ^(yes|y)$ ]]
then
    git add ~/.config/ags
    git commit -m "Another commit"
    git push -u -f origin master
else
    printf " Continue, no pushing...\n\n"
fi

if [ -s "~/.config/ags" ]
then
    read -r -p "Make a backup? [y/N] " response
    response=${response,,}    # tolower
    if [[ "${response}" =~ ^(yes|y)$ ]]
    then
        backup
    else
        printf "  Continue, no backup...\n\n"
    fi
fi

cd "${HOME}" || { echo "Couldn't cd .."; exit 1; }

read -r -p "Clone new version? [y/N] " response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]
then
    if [ -s "~/dotfiles" ]
    then
        printf "${YELLOW}File \"dotfiles\" exists and it's not empty\n\n"
        ls -A ~/dotfiles
        printf "${NC}"
        read -r -p "rm -rf ~/dotfiles? [y/N] " response
        response=${response,,}    # tolower
        if [[ "${response}" =~ ^(yes|y)$ ]]
        then
            rm -rf ~/dotfiles
        else
            printf "Aborted.\n"
        fi
    fi
    rm -rf ~/.config/ags
    git clone https://github.com/Aylur/dotfiles.git
    cp -r dotfiles/ags ${AGS}
    rm -rf dotfiles
    printf "${GREEN}Finished!${NC}\n"
    read -r -p "Update ags? [y/N] " response
    response=${response,,}    # tolower
    if [[ "${response}" =~ ^(yes|y)$ ]]
    then
        yay -S aylurs-gtk-shell-git
    else
        printf "Aborted.\n"
    fi
else
    printf "Aborted.\n"
fi
