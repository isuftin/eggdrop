Eggdrop IRC Bot
===============

### Tags/Dockerfile

- [0.0.1](https://github.com/isuftin/eggdrop-docker/blob/0.0.1/)/[Dockerfile](https://github.com/isuftin/eggdrop-docker/blob/0.0.1/Dockerfile)

From [the Eggdrop IRC Bot website](http://www.eggheads.org/):
 
Eggdrop is the world's most popular Open Source IRC bot, designed for flexibility and ease of use, and is freely distributable under the GNU General Public License (GPL). Eggdrop was originally developed by Robey Pointer; however, he no longer works on Eggdrop so please do not contact him for help solving a problem or bug. 

Some features of Eggdrop: 

- Designed to run on Linux, \*BSD, SunOs, Windows, Mac OS X, etc ...
- Extendable with Tcl scripts and/or C modules
- Support for the big five IRC networks (Undernet, DALnet, EFnet, IRCnet, and QuakeNet)
- The ability to form botnets and share partylines and userfiles between bots
- Some benefits of Eggdrop: 
- The oldest IRC bot still in active development (Eggdrop was created in 1993)
- Established IRC help channels and web sites dedicated to Eggdrop
- Countless premade Tcl scripts and C modules
- Best of all ... It's FREE!

## Image Information

The docker image is based on the official Ubuntu 14.04 image. Building the image installs dependencies required to compile the eggdrop bot: 
- wget 
- build-essential 
- libtcl8.6 
- libtcl8.6-dbg 
- tcl8.6-dev

It then pulls the Eggdrop latest Eggdrop source from [Eggheads' FTP site](ftp://ftp.eggheads.org/pub/eggdrop/source/eggdrop-latest.tar.gz), unpackages and compiles. The eggdrop installation is created to a non-root user. The user's default name is ```eggdrop``` but this can be changed by setting the environment variable ```eggdrop_user```.

## Mapped Volumes

- **/scripts** - All eggdrop TCL scripts should go here. All default scripts that come with eggdrop will be copied here during the inital run
- **/modules** - A place to put any eggdrop modules. This is not used by default.
- **/files** and **/files/incoming** - Used for the file transfer eggdrop module.
- **/logs** - All log files are stored here
- **/configs** - The eggdrop user file will be stored here by default. You may use this for other configuration files (like eggdrop.conf) if you wish.

## Basic Usage

#### Pulling the container to your local registry:

```
docker pull isuftin/eggdrop:latest
```

#### Getting the source (including environments and docker-compose files)

```
git clone https://github.com/isuftin/eggdrop-docker.git
cd eggdrop-docker
```

## Running the built image:

### Creating the userfile

When running the container for the first time, unless you already have a pre-existing user file ( described below ), you will need to create one. I've included an environments file list that make for sensible default variables in creating the initial bot. In order to do so, make sure you are in the directory you pulled the source from GitHub to. You will need to run your image in userfile creation mode:

```
docker run -p 8001:8001 \
    --env-file=env-file.list \
    -it isuftin/eggdrop:latest \
    eggdrop -nm eggdrop.conf
```

In the logs, you should see:

```
STARTING BOT IN USERFILE CREATION MODE.
Telnet to the bot and enter 'NEW' as your nickname.
OR go to IRC and type:  /msg testbot hello
This will make the bot recognize you as the master.
```

Note that if you are going to go on IRC and send a message to the bot, the default message to send is "hellohello" instead of "hello". This is done for security purposes. This may also be changed through the environment variable `rebind_hello`. I would suggest that you telnet to the bot and enter NEW as your nickname. This allows you to immediately issue the ".save" command in the party line so that the user file is guaranteed to be saved properly. Your new userfile is then saved to the `/configs` directory. This directory is a `VOLUME` and may be mapped to your host file system or a volume container. The file will be named using the bot's nicknam by default ( ex. TestBot.user ). This is also configurable using the `userfile` environment variable

### Pre-existing userfile

If you already have a user file you wish to use, put it into your host's filesystem or a volume container and map it to the `/configs` directory. If you name is the same name as your bot's nickname and suffix it with `.user`, your bot should pick it up during the initial run. If you are giving it a name other than your bot's nickname ( ex. NotMyBotsName.user ), set that in the `userfile` environment variable.

### Running the eggdrop bot for normal operation

There is a [docker-compose template](https://github.com/isuftin/eggdrop-docker/blob/master/docker-compose.yml) included in the source to get started quickly.  

There are three mandatory variables that need to be set during a run:

- **listen_ports** - Tells the Eggdrop bot which port(s) to expect telnet connections through. (Ex.: 8001|all ) The variable is a string and is semicolon delimited. An example of multiple port listeners: "8001|bots;8002|users". [More info about this setting](http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?view=markup#l228)
- **owner**  - This is a mandatory setting that signifies who the owner of the bot is. [More info about this setting](http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?view=markup#l358)
- **eggdrop_nickname** - The nickname of the bot. This affects multiple settings (log file names, irc nickname, botnet nickname, etc)

Example run:

```
docker run \
 -e "listen_ports=8001" -e "owner=isuftin" -e "eggdrop_nickname=eggyweggy" \
  -p 8001:8001 -it eggdrop:latest 
```

The eggdrop configuration file is written at run-time and is fully configurable through environment variables. The sensible defaults are those from the original [eggdrop.conf](http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?revision=1.69) fille.  In order to customize the bot to your liking, check out the [configuration file](https://github.com/isuftin/eggdrop-docker/blob/master/scripts/configure-eggdrop.sh) to see which variables need changing. You may also provide a pre-existing configuration file by putting it into the mapped `/configs` volume. If, for example, your eggdrop configuration file is `/configs/my-eggdrop.conf`, your docker run will look like:

```
docker run [...] -it eggdrop:latest eggdrop -n /configs/my-eggdrop.conf
```
I advise that unless you really need it, allow the docker run to create the config file using environment variables. In this way, your configuration may be held in a Docker environments file and picked up using the `--env-file=[]` command-line parameter as described in the [Docker command-line documentation](https://docs.docker.com/reference/commandline/cli/).  

### Pre-run configuration

If you link a volume to `/docker-egg-init.d` any files in there will be run before eggdrop begins. The files are run in numerical and lexical order, depending on the filenames. For example, these files will be run in order: 

- 10-do-something.sh
- 20-do-the-next-thing.sh

Included in the source is [`init/10-init.sh`](https://github.com/isuftin/eggdrop-docker/blob/master/init/10-init.sh) which will check if you've updated the default scripts directory and will copy all of the default scripts into that directory before starting eggdrop.

### Notes:
- if you are having issues connecting to the bot from outside your LAN, check your that `nat_ip` variable is set correctly.  On my host, the docker0 interface is broadcasting to 0.0.0.0, so I set my `nat_ip	` variable to "0.0.0.0" 