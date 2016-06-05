# inside-docker
A small project that helps to easily run linux desktop applications as Docker containers.

##Installation
1. Clone and `cd ./inside-docker`
2. Run `sudo ./install.sh`<br>
    this will create a symbolic link called `inside-docker` within your `/usr/local/bin`-folder

##Usage
Hit ALT+F2 or run a terminal and enter `inside-docker <SERVICE-NAME>` to start one of the services as a Docker container. Right now there are two, both should work with pulseaudio.

* `inside-docker skype` starts Skype<br>
    sound is working fine after a few tweaks. The cam was recognized instantly.
* `inside-docker tachrome` starts a throw-away instance of Chrome<br>
    Ghostery, AdBlock & a Proxy switcher are already installed. If you're running Tor on your host, you can pipe your traffic through it by selecting TOR as proxy.

##Troubleshooting
If sound is not working from within the containers, try

1. install `paprefson` your host system (something like `sudo apt-get install paprefs`)
2. launch "PulseAudio Preferences" and ensure that _"Enable network access to local sound devices"_ is checked on the "Network Server" tab
3. Restart PulseAudio (something like `pulseaudio -k && pulseaudio -D`)
4. launch a container and retry
