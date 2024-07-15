#!/bin/bash

# Audio/Video Downloader - by ALHAM
# This shell script provides a convenient way to download audio and video files from various websites using the yt-dlp command-line tool.
# It allows you to easily specify the desired format and provides a user-friendly interface for a seamless downloading experience.

# ANSI color codes for colored terminal output
reset='\033[0m'
red='\033[31m'
green='\033[32m'
yellow='\033[33m'
blue='\033[34m'
cyan='\033[36m'
white='\033[37m'
bold='\033[1m'
underlined='\033[4m'
italic='\033[3m'

# Set the path where you want to save downloaded files
download_path="${HOME}/Downloads/Audio-Video-downloader"
if ! [[ -d "${download_path}" ]]; then
    exit_code=$?
    log "download_path does not exist, creating ${download_path}"
    mkdir -p "${download_path}"
fi

# download_path="/tmp/audio-video-downloader-by-alham/"
log_file="/var/log/Audio-Video-Downloader-by-ALHAM.log"
temp_log_file='/tmp/audio-video-downloader-by-alham.log'

error() {
  case $1 in
    0) echo "Success";;
    1) echo "General error";;
    2) echo "Misuse of shell builtins";;
    126) echo "Command invoked cannot execute";;
    127) echo "Command not found";;
    128) echo "Invalid argument to exit";;
    130) echo "Script terminated by Control-C";;
    255) echo "Exit status out of range";;
    *) echo "Unknown error code";;
  esac
}

termination() {
    log "Terminating the script..."
    echo -e "\n${red}Terminating the script...${reset}"
    exit_code=$?
    log "done...\n"
    exit 0
}

log() {
    # Logging the argument as a string with timestamps
    error_meaning=$(error ${exit_code})
    echo -e "$(date '+%I:%M:%S%p | %d/%b/%y') ${error_meaning}: ${1}" >> "${log_file}"
}

validate_url() {
    if [[ $url =~ ^(https?|ftp)://.+ ]]; then
        log "URL is valid: ${url}"
        return 0
    else
        log "URL is not valid: ${url}"
        for ((i=0; i<3; i++)); do
            echo -e "\n${red}${bold}[_]Enter a valid URL${reset}${green}${italic} (press Enter to copy from clipboard)${reset}${green}:"
            read -rp "[ ] " url
            log "Got the URL manually: ${url}"

            if [[ -z "$url" ]]; then
                if ! command -v xclip 2> ${temp_log_file} >/dev/null; then
                    log "Error: $(cat ${temp_log_file}) : xclip command"
                    echo -e "${red}Error: xclip is not installed or not in PATH.${reset}"
                    echo -e "${green}${bold}[_]Enter the URL${reset}${green}:"
                    read -rp "[ ] " url
                    log "Got the URL manually: ${url}"
                else
                    url=$(xclip -selection clipboard -o)
                    exit_code=$?
                    log "URL copied from clipboard: ${url}"
                fi
            fi
            if [[ $url =~ ^(https?|ftp)://.+ ]]; then
                exit_code=$?
                log "URL is valid: ${url}"
                return 0
            else
                log "URL is not valid: ${url}"
            fi
        done
        echo -e "${red}${bold}Error: Invalid URL provided.${reset}"
        exit 1
    fi
}

url() {
    if [[ -z $url ]]; then
        echo -e "${green}${bold}[_]Enter the URL${reset}${green}${italic} (press Enter to copy from clipboard)${reset}${green}:"
        read -rp "[ ] " url
        log "Got the URL manually: ${url}"

        if [[ -z "$url" ]]; then
            if ! command -v xclip  2> ${temp_log_file} >/dev/null; then
                log "Error: $(cat ${temp_log_file}) : xclip command"
                echo -e "${red}Error: xclip is not installed or not in PATH.${reset}"
                echo -e "${red}${bold}[_]Enter the URL${reset}${green}:"
                read -rp "[ ] " url
                log "Got the URL manually: ${url}"
            else
                url=$(xclip -selection clipboard -o)
                exit_code=$?
                log "URL copied from clipboard: ${url}"
            fi
        fi
        validate_url
    else
        validate_url
    fi
}

default() {
    echo -e "\n$reset$green$bold[_]Video or Audio$reset$green$italic (default is '2')$reset$green:"
    echo -e "[1] Download video"
    echo -e "[2] Download audio"
    echo -e "[3] Help${reset}${green}"
    read -rp "[ ] " decision

    if [ -z "$decision" ]; then   # download audio
        download_audio
    elif [ "$decision" == 1 ]; then    # download video
        download_video
    elif [ "$decision" == 2 ]; then    # download audio
        download_audio
    elif [[ "$decision" == 3 ]]; then  # display help
        text="Audio-Video downloader help menu"
        padding=$(( (columns - ${#text}) / 2 ))

        echo -e "\n${bold}${green}${underlined}"
        printf "%*s%s%*s" "${padding}" "" "${text}" "${padding}"
        echo -e ""
        help
    else
        exit_code=$?
        log "response not recognized: '${decision}'"
        echo -e "\n${red}response:'${decision}' not recognized try again!${reset}${green}"
        log "done...\n"
        exit 1
    fi
}

help() {
    log "showing help"

    echo -e "\n${reset}${green}${bold}SYNOPSIS${reset}${green}"
    echo -e "\t./script.sh ${white}[OPTION]${reset}${green}\n"

    echo -e "${bold}DESCRIPTION${reset}${green}"
    echo -e "\tby default when you only run ${white}'./script.sh'${reset}${green} without argument it will ask for needed information interactively"
    echo -e "\n\t${bold}${white}-h, --help${reset}${green}"
    echo -e "\t\tdisplay this help and exit"
    echo -e "\n\t${bold}${white}-u, --url${reset}${green}"
    echo -e "\t\tparse the URL which you need to download audio or video."
    echo -e "\n\t${bold}${white}-A, --audio${reset}${green}"
    echo -e "\t\tdownload audio using the given URL"
    echo -e "\n\t${bold}${white}-V, --video${reset}${green}"
    echo -e "\t\tdownload video using the given URL"
    echo -e "\n\t${bold}${white}-Vb, --video-best${reset}${green}"
    echo -e "\t\tdownload video with the best format using the given URL"

    echo -e "\n${bold}USAGE${reset}${white}${bold}"
    echo -e "\t./script.sh --url <url>"
    echo -e "\t./script.sh -u <url>${reset}${green}"
    echo -e "\t\tparse the URL and the script will ask for other information interactively\n"

    echo -e "\t${white}${bold}./script.sh --audio"
    echo -e "\t./script.sh -A ${reset}${green}"
    echo -e "\t\tdownload audio and the script will ask for other information interactively\n"

    echo -e "\t${white}${bold}./script.sh --video"
    echo -e "\t./script.sh -V ${reset}${green}"
    echo -e "\t\tdownload video and the script will ask for other information interactively\n"

    echo -e "\t${white}${bold}./script.sh --audio --url <url>"
    echo -e "\t./script.sh -u <url> -A${reset}${green}"
    echo -e "\t\tdownload audio using the provided URL\n"

    echo -e "\t${white}${bold}./script.sh --video --url <url>"
    echo -e "\t./script.sh -u <url> -V${reset}${green}"
    echo -e "\t\tdownload video using the provided URL and the script will ask which format you want to download interactively\n"

    echo -e "\t${white}${bold}./script.sh --video-best --url <url>"
    echo -e "\t./script.sh -u <url> -V${reset}${green}"
    echo -e "\t\tdownload the best video format of provided URL"

    echo -e "\n${reset}${green}${bold}NOTE${reset}${green}"
    echo -e "\tTo successfully use this script, you have to have '${white}yt-dlp${green}' and '${white}xclip${green}'(to copy the URL from the clipboard) installed."

    echo -e "\n${bold}AUTHOR${reset}${green}"
    echo -e "\tWritten by: ${white}ALHAM${reset}${green}"
    echo -e "\tTwitter: ${white}https://www.twitter.com/@alham__aa${reset}${green}"
    echo -e "\tEmail: ${white}alham@duck.com\n${reset}"

    log "done...\n"
    exit 0
}

title() {
    title=$(yt-dlp --get-title "${url}" 2> ${temp_log_file})
    exit_code=$?
    log "fetching title ,$(cat ${temp_log_file} >/dev/null)"

    if ! [[ ${exit_code} -eq 0 ]]; then
        log "Error: $? Could not get the title"
        echo -e "${red}Couldn't fetch the title"
    else
        echo -e "${blue}${bold}\nTitle: ${title}${reset}${green}"
        log "title : ${title}"
    fi
}

notification(){
    local title="Download Complete...!"
    local message="$1" # message of notification (in here the tittle of the song)
    local app_name="ALHAM"
    local icon_path="/opt/alham_scripts/bash_scripts/Audio-Video-Downloader-by-ALHAM/done.svg"

    # Display the notification
    notify-send "$title" "<i>$message</i>" \
        --app-name "$app_name" \
        --icon $icon_path \
        --urgency low \
        -t 3000
}

download_audio() {
    # Logging the output
    log "Downloading audio"

    # Change to the directory where you want to download the file
    # If the download path is incorrect, the script will download in the current working directory
    cd "${download_path}" 2> ${temp_log_file} && log "cd $download_path" || {
        error=$(sed -n 's/^.*: \(.*\)$/\1/p' ${temp_log_file})
        exit_code=$?
        log "cd:${download_path}: ${error}"
        log "Downloading in current working directory: $(pwd)"
    }
    exit_code=$?
    echo -e "\n${bold}${blue}${italic}Download Audio${reset}${green}"

    # Check the URL
    url

    # Fetch the title of the given URL
    title

    # Get the file size
    file_size=$(yt-dlp -i --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail --get-filename --output '%(filesize)s' "$url" --no-progress --newline 2> $temp_log_file)
    exit_code=$?
    file_size=$(bc <<< "scale=2; $file_size/(1024*1024)")

    echo -e "${blue}${italic}${file_size}MB${reset}${green}"

    log "Fetching file size: $(cat ${temp_log_file})"
    log "File size: ${file_size}MB"

    echo -e "${bold}\nDownloading${white}.${yellow}.${cyan}.${reset}${green}"

    # Download the audio at the best quality
    # --audio-quality 0 means the best quality
    log "Downloading audio in progress..."
    yt-dlp -i --extract-audio --audio-format mp3 --audio-quality 0 --embed-thumbnail "${url}" --console-title --no-mtime 2> "${temp_log_file}" > /dev/null
    exit_code=$?

    if ! [[ $? -eq 0 ]]; then
        exit_code=$?
        log "Error: $(cat ${temp_log_file}) An error occurred while downloading audio"
        echo -e "${red}An error occurred while downloading the audio. Please try again.${reset}${green}"
        log "done...\n"
        echo -e "${bold}Terminating...!${reset}${green}"
        exit 1
    fi
    notification "$title"

    echo -e "${bold}Done_\U0000270C ${reset}${green}"

    exit_code=$?
    log "$(cat ${temp_log_file})"
    log "Done...\n"

    # Exit from the script
    exit 0
}

download_video_best_quality(){
    log "Downloading Video using best quality"

    echo -e "\n${green}${bold}Downloading the video using available best format...${reset}"

    yt-dlp --format "best" "$url" --console-title --no-mtime 2> ${temp_log_file} >/dev/null
    exit_code=$?
}

download_video() {
    # Logging the output
    log "Downloading video"

    # Change to the directory where you want to download the file
    # If the download path is incorrect, the script will download in the current working directory
    cd "$download_path" 2> ${temp_log_file} && log "cd ${download_path}" || {
        error=$(sed -n 's/^.*: \(.*\)$/\1/p' ${temp_log_file})
        exit_code=$?
        log "cd:${download_path}: $error"
        log "Downloading in current working directory: "$(pwd)""
    }
    exit_code=$?

    echo -e "\n${bold}${blue}${italic}Download Video${reset}${green}"

    # Check the URL
    url

    # Fetch the title of the given URL's video
    title

    # Check whether need to download using best quality. else user can choose the video fomat
    if [ "$video_best_flag" == true ]; then
        download_video_best_quality
    else

    echo -e "\n${bold}${green}[_]Select desired format:${reset}${green}"
    l="${reset}${bold}${white}|${reset}${bold}${blue}"
    h="${bold}${white} ---  ----- ----------- ----------${reset}${cyan}"

    echo -e "${reset}${white}${bold}$h\n${l}ID  ${l}EXT  ${l}FILESIZE   ${l}RESOLUTION ${l}${bold}${white}\n${h}${reset}${cyan}"

    l="${reset}${bold}${white}|${reset}${cyan}"

    # Fetch available formats for the video and show them on the terminal
    yt-dlp --list-formats "${url}" | awk -v pipe="${l}" -v blue="${blue}" -v bold="${bold}" '
        NR>8 && !/^(---|\[info\]|\[youtube\])/ && !/images|audio only/ && !/video only/ {
            if ($7 == "~") {
                $7 = $8;
                $16 = $17;
            }
            printf "%s%-4s%s%-4s%s%-5s%s%-11s%s%-11s\n \033[37;1m---  ----- ----------- ----------\033[0;36m\n",
                pipe, blue, bold, $1, pipe, $2, pipe, $7, pipe, $16}' 2> ${temp_log_file}
    exit_code=$?

    if [[ $? -ne 0 ]]; then
        log "Error: $(cat ${temp_log_file}) An error occurred while getting video formats"
        echo -e "${red}An error occurred while getting video formats. Please try again.${reset}${green}"
        # log "done...\n"
        # echo -e "${bold}Terminating...!${reset}${green}"
        # exit 1
    fi

        log "Fetching formats: $(cat ${temp_log_file})"

        echo -e "${green}${bold}[_]Enter the ID of the video you want to download: ${reset}${green}"
        echo -e "${green}${bold}[_]${reset}${italic}${yellow}\"best\"${reset}${green}${bold} to download using best available quality:${reset}${green}"
        read -rp "[ ] " format_id

        if [ "${format_id}" == "best" ]; then
            log "Selected format ID: ${format_id}"
            download_video_best_quality
        fi

        echo -e "${bold}\nDownloading${white}.${yellow}.${cyan}.${reset}${green}"

        log "Selected format ID: ${format_id}"

        # Download the video using the given format
        log "Downloading video..."
        yt-dlp --format "$format_id" "$url" --console-title --no-mtime 2> ${temp_log_file} >/dev/null
        exit_code=$?

        if [[ $? -ne 0 ]]; then
            log "Error: $(cat ${temp_log_file}) An error occurred while downloading video"
            echo -e "${red}An error occurred while downloading the video. Please try again.${reset}${green}"
            log "$(cat ${temp_log_file})"
            log "done...\n"
            echo -e "${bold}Terminating...!${reset}${green}"
            exit 1
        fi
    fi

    notification "$title"
    exit_code=$?
    log "done...\n"

    echo -e "${bold}Done_\U0000270C ${reset}${green}"

    exit 0
}

welcome() {
    exit_code=$?
    trap termination SIGINT SIGTERM SIGKILL SIGSEGV SIGHUP

    exit_code=$?
    log "Starting..."

    # Check whether the command 'yt-dlp' is available
    if ! command -v yt-dlp &> /dev/null; then
        exit_code=$?
        log "Error: yt-dlp is not installed or not in PATH."
        echo "Error: yt-dlp is not installed or not in PATH."
        log "done...\n"
        exit 1
    fi

    text="Audio/Video Downloader by ALHAM"
    columns=$(tput cols)
    padding=$(( (columns - ${#text}) / 2 ))

    echo -en "${bold}${yellow}${underlined}"
    printf "%*s%s%*s\n" "${padding}" "" "${text}" "${padding}" ""

    # Checking if there are any arguments
    if [ $# -gt 0 ]; then
        # If an argument has a URL, get the URL from the arguments
        url_flag=false

        for arg in "$@"; do
            if [ ${url_flag} == true ]; then
                url=${arg}
                url_flag=false
                break
            fi

            if [[ ${arg} == "--url" ]] || [[ ${arg} == "-u" ]]; then
                log "script.sh ${arg}"
                url_flag=true
            fi
        done

        # Check if arguments are specified
        for arg in "$@"; do
            video_best_flag=false
            if [ "${arg}" = "--log" ]; then
                exit_code=$?
                log "script.sh --log"
                cat "${log_file}"
                log "done...\n"

            elif [ "${arg}" = "--video-best" ] || [ ${arg} = "-Vb" ]; then
                log "script.sh ${arg}"
                video_best_flag=true
                download_video

            elif [ "${arg}" = "--video" ] || [ "${arg}" = "-V" ]; then
                exit_code=$?
                log "script.sh ${arg}"
                download_video

            elif [ "${arg}" = "--audio" ] || [ "${arg}" = "-A" ]; then
                exit_code=$?
                log "script.sh ${arg}"
                download_audio

            elif [ "${arg}" == "--help" ] || [ "${arg}" == "-h" ]; then
                exit_code=$?
                log "script.sh ${arg}"
                help

            else
                exit_code=$?
                log "Maybe an invalid argument, accessing default"
                default
            fi
        done
    else
        default
    fi
}

welcome "$@"
