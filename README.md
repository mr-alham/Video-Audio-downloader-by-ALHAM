# Audio/Video Downloader by ALHAM

This shell script provides a convenient way to download audio and video files from various websites using the `yt-dlp` command-line tool. It allows you to easily specify the desired format and provides a user-friendly interface for a seamless downloading experience.

## Requirements

- ### `yt-dlp`

  A command-line program to download videos and audios from YouTube and other sites. Install it by following the instructions at

  - ```bash
    $ python3 -m pip install -U yt-dlp
    ```

  [https://github.com/yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp/wiki)

- ### `xclip`

  A command-line utility that can be used to copy and paste text and files to and from the clipboard.

  - ```bash
    $ sudo apt install xclip
    ```

  For Arch/Manjaro linux users

  - ```bash
    $ sudo pacman -S xclip
    ```

  * [https://github.com/astrand/xclip](https://github.com/astrand/xclip)

## Easy Installation

Simplest method to download and install the script

```bash
curl -o Video-Audio-Downloader-install.sh https://raw.githubusercontent.com/mr-alham/Video-Audio-downloader-by-ALHAM/main/install.sh

bash Video-Audio-Downloader-install.sh
```

## How to use

    To use the script, follow these steps:

    1. Clone the repository or download the shell script.
    2. Navigate to the directory where the script is located.
    3. Make the script executable by running: `chmod +x script.sh`
    4. Run the script by executing: `./script.sh`
    5. Follow the prompts and provide the required inputs as described in the script.

## Description

    - Download audio by providing the URL interactively:

      ```bash
      $ ./script.sh --audio
      $ ./script.sh -A
      ```

    - Download video by providing the URL interactively:

      ```bash
      $ ./script.sh --video
      $ ./script.sh -V
      ```

    - Download video using the best quality:

      ```bash
      $ ./script.sh --video-best
      $ ./script.sh -Vb
      ```

    - Provied the URL for download:

      ```bash
      $ ./script.sh --url <url>
      $ ./script.sh -u <url>
      ```

    - Show help menu:

      ```bash
      $ ./script.sh --help
      $ ./script.sh -h
      ```

## Usage

    - Some example how the script can be used.

      ```bash
      $ ./script.sh --audio --url <url>
      $ ./script.sh -A -u <url>

      $ ./script.sh --video --url <url>
      $ ./script.sh -V -u <url>

      $ ./script.sh -video-best --url <url>
      $ ./script.sh -Vb -u <url>
      ```

## Screenshots

**Note:** I haven't updated the screenshots for the final code revision.

    **Interactively:** Download video:

    ```bash
    $ ./script.sh
    ```

    ![example image of downloading a video on youtube using the script](https://github.com/mr-alham/projects-of-alham/blob/main/private/Audio_Video-downloader-bash-script(1).png)

    **Interactively:** Download audio:

    ```bash
    $ ./script.sh
    ```

    ![example image of downloading a song(audio) on youtube using the script](https://github.com/mr-alham/projects-of-alham/blob/main/private/Audio_Video-downloader-bash-script-audio.png)

## Creating an Alias

    To use the script as a usual command, you can create an alias. Here's an example:

    1. Open the terminal.
    2. Edit the shell configuration file (e.g., `~/.bashrc`, `~/.bash_profile`).
    3. Add the following line at the end of the file:

       ```bash
       $ alias downloader="path/to/script.sh"
       ```

    4. Save the file and exit the editor.
    5. Reload the shell configuration by running: `source ~/.bashrc` (or `source ~/.bash_profile`).
    6. You can now use the script by simply typing `downloader` in the terminal.

## Contact me

For any further assistance or inquiries, please feel free to contact me at, - ALHAM - Twitter: [@alham\_\_aa](https://www.twitter.com/@alham__aa) - Email: alham@duck.com
