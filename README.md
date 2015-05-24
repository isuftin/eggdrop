Eggdrop IRC Bot
===============

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

It then pulls the Eggdrop latest Eggdrop source from [Eggheads' FTP site](ftp://ftp.eggheads.org/pub/eggdrop/source/eggdrop-latest.tar.gz), unpackages and compiles. The eggdrop installation is created to a non-root user. The user's default name is "eggdrop" but this can be changed by setting the environment variable **eggdrop_user**.

## Basic Usage

Building the container to your local system:

```bash
cd $eggdrop_docker_directory
sudo docker build -t eggdrop:latest .
```
Running the built image:

There is a docker-compose template included in the source for convenience.  There are three mandatory variables that need to be set during a run:

- **listen_ports** - Tells the Eggdrop bot which port(s) to expect telnet connections through. (Ex.: 8001|all ) The variable is a string and is semicolon delimited. An example of multiple port listeners: "8001|bots;8002|users". [More info about this setting](http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?view=markup#l228)
- **owner**  - This is a mandatory setting that signifies who the owner of the bot is. [More info about this setting](http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?view=markup#l358)
- **eggdrop_nickname** - The nickname of the bot. This affects multiple settings (log file names, irc nickname, botnet nickname, etc)

Example run:
```bash
sudo docker run -e \
  "listen_ports=8001" -e "owner=isuftin" -e "eggdrop_nickname=eggyweggy" \
  -p 8001:8001 -it eggdrop:latest 
```

The eggdrop configuration file is written at run-time and is fully configurable through environment variables. The sensible defaults are those from the original [eggdrop.conf](http://cvs.eggheads.org/viewvc/eggdrop1.6/eggdrop.conf?revision=1.69) fille.  In order to customize the bot to your liking, check out the [configuration file](https://github.com/isuftin/eggdrop-docker/blob/master/scripts/configure-eggdrop.sh) to see which variables need changing.  

If you link a volume to `/docker-egg-init.d` any files in there will be run before eggdrop begins. The files are run in numerical and lexical order, depending on the filenames. For example, these files will be run in order: 

- 10-do-something.sh
- 20-do-the-next-thing.sh

Included in the source is [`init/10-init.sh`](https://github.com/isuftin/eggdrop-docker/blob/master/init/10-init.sh) which will check if you've updated the default scripts directory and will copy all of the default scripts into that directory before starting eggdrop.