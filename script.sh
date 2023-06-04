#!/bin/bash

reset='\033[0m'
green='\033[32m'
yellow='\033[33m'
blue='\033[34m'
cyan='\033[36m'
white='\033[37m'
bold='\033[1m'
underlined='\033[4m'
italic='\033[3m'

download_path="/home/$(whoami)/Downloads"


download_audio() {
    cd "$download_path" || exit 1

    echo -e "\n$bold$blue${italic}Download Audio$reset$green"
    echo -e "$green$bold[_]Enter the URL$reset$green (press Enter to copy from clipboard):"
    read -rp "[ ]" url

    if [ -z "$url" ]; then
        url=$(xclip -selection clipboard -o)
    fi

    title=$(yt-dlp --get-title "$url")

    echo -e "$blue$bold\nTitle: $title$reset$green"
    echo -e "$bold\nDownloading$white.$yellow.$cyan.$reset$green"

    yt-dlp -i --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail "$url" --no-progress --newline > /dev/null

    echo -e "${bold}Done_\U0000270C $reset$green"
}


download_video() {
    cd "$download_path" || exit 1

    echo -e "\n$bold$blue${italic}Download Video$reset$green"
    echo -e "$green$bold[_]Enter the URL$reset$green$italic (press Enter to copy from clipboard)$reset$green:"
    read -rp "[ ] " url

    if [ -z "$url" ]; then
        url=$(xclip -selection clipboard -o)
    fi

    title=$(yt-dlp --get-title "$url")

    echo -e "$blue$bold\nTitle: $title$reset$green"
    echo -e "\n$bold$green[_]Select desired format:$reset$green"

    l="${reset}${bold}${white}|${reset}$bold${blue}"
    h="$bold$white ---  ----- ----------- ----------$reset$cyan"

    echo -e "${reset}${white}${bold}$h\n${l}ID  ${l}EXT  ${l}FILESIZE   ${l}RESOLUTION $l$bold$white\n$h${reset}$cyan"

    l="${reset}${bold}${white}|${reset}${cyan}"

    yt-dlp --list-formats "$url" | awk -v pipe="$l" -v blue="$blue" -v bold="$bold" '
        NR>8 && !/^(---|\[info\]|\[youtube\])/ && !/images|audio only/ && !/video only/ {
            if ($7 == "~") {
                $7 = $8;
                $16 = $17;
            }
            printf "%s%-4s%s%-4s%s%-5s%s%-11s%s%-11s\n \033[37;1m---  ----- ----------- ----------\033[0;36m\n",
                pipe, blue, bold, $1, pipe, $2, pipe, $7, pipe, $16
        }'

    echo -e "$green$bold[_]Enter the ID of the video you want to download: $reset$green"
    read -rp "[ ] " format_id

    echo -e "$bold\nDownloading$white.$yellow.$cyan.$reset$green"

    yt-dlp --format "$format_id" "$url" > /dev/null

    echo -e "${bold}Done_\U0000270C $reset$green"
}


welcome() {
    text="Audio/Video Downloader by ALHAM"
    columns=$(tput cols)
    padding=$(( (columns - ${#text}) / 2 ))

    echo -en "$bold$yellow$underlined"
    printf "%*s%s%*s\n" "$padding" "" "$text" "$padding" ""

    echo -e "\n$reset$green$bold[_]Video or Audio$reset$green$italic (default is '2')$reset$green:
[1] Download video
[2] Download audio$reset$green"
    
    read -rp "[ ] " decision

    if [ -z "$decision" ]; then   # download audio
        download_audio
    elif [ "$decision" -eq 1 ]; then    # download video
        download_video
    elif [ "$decision" -eq 2 ]; then    # download audio
        download_audio
    else
        echo 'Command not recognized'
    fi
}

welcome
