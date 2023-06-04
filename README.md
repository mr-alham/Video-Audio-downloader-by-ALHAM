# Audio/Video Downloader by ALHAM

This shell script provides a convenient way to download audio and video files from various websites using the `yt-dlp` command-line tool. It allows you to easily specify the desired format and provides a user-friendly interface for a seamless downloading experience.

* ## Requirements

    - ### `yt-dlp`
      A command-line program to download videos and audios from YouTube and other sites. Install it by following the instructions at 
        - ```bash
          $ python3 -m pip install -U yt-dlp
          ```
        * [https://github.com/yt-dlp/yt-dlp](https://github.com/yt-dlp/yt-dlp/wiki/Installation)

    - ### `xclip`
      A command-line utility that can be used to copy and paste text and files to and from the X clipboard.
        - ```bash
          $ sudo apt install xclip
          ```
        * [https://github.com/astrand/xclip](https://github.com/astrand/xclip)

* ## How to use

    To use the script, follow these steps:

    1. Open a terminal.
    2. Navigate to the directory where the script is located.
    3. Make the script executable by running: `chmod +x script.sh`
    4. Run the script by executing: `./script.sh`
    5. Follow the prompts and provide the required inputs as described in the script.

* ## Examples

    **Example 1:** Download video:

    ```bash
    $ ./script.sh
    ```
    ![example image of downloading a video on youtube using the script](https://github.com/mr-alham/projects-of-alham/blob/main/private/Audio_Video-downloader-bash-script(1).png)

    **Example 2:** Download audio:

    ```bash
    $ ./script.sh
    ```
    ![example image of downloading a song(audio) on youtube using the script](https://github.com/mr-alham/projects-of-alham/blob/main/private/Audio_Video-downloader-bash-script-audio.png)

* ## Creating an Alias
    
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
* ## Contact me
   For any further assistance or inquiries, please feel free to contact me at [alham@duck.com](mailto:alham@duck.com).
