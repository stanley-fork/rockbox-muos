<p align="center">
  <img src="./logo/rockbox-logo.svg"/>
</p>
<p align="center">
  <a href="./README">Original README</a>
</p>

## What is Rockbox?

**Rockbox** is a free, open-source firmware replacement for digital audio players (DAPs), offering an alternative to the original operating system. It's designed to be highly customizable, with features like advanced equalizers, themes, and support for various file formats.

## What is this?

This is a fork of Rockbox with a few changes to make it compatible with various retro handhelds as an app. Currently supports **muOS** and **NextUI**.

**Portmaster** support is unofficial [due to some issues](https://github.com/IncognitoMan/rockbox/issues/1).

## Notes

#### Setting Database Scan Directory

Would ***highly*** suggest setting database scan directory before scanning/building the database. Have `Database` highlighted, press and hold `A` button to pull up the database menu and scroll down and select the `Select directories to scan` option.

Press `A` to enter highlighted directories. Once you have you your main music folder highlighted, press `A` again until the folder icon turns into a "play" symbol. Press `DPAD LEFT` to exit and press `A` to save changes, then `A` again to initialize database.

When it finishes, restart Rockbox.

#### Installing Themes:

> [!NOTE]
> Themes created pre-4.0 may not display correctly even if listed as working with 4.0/dev build.

Download any themes from the `Ipod Classic` section [here](https://themes.rockbox.org/index.php?target=ipod6g) and extract. Copy the contents inside the `.rockbox` folder into the `rockbox` directory. 

Make sure to restart Rockbox to fix theme paths before applying a theme.

## Controls

#### In Menu:

|    Button    |        Action       |
|:------------:|:-------------------:|
|    DPAD UP   |       Move UP       |
|   DPAD DOWN  |      Move DOWN      |
|   DPAD LEFT  |       Go Back       |
| DPAD RIGHT/A |     Enter/Accept    |
|    Hold A    |     Context Menu    |
|    Press B   |      Main Menu      |
|    Press X   |  WPS/Resume Playing |
|    Press Y   |  Pause/Stop Playing |
|      L1      |   Lock/Hold Input   |
|      R1      | Shuffle/Repeat Menu |
|     L2+R2    |   Shutdown (Exit)   |

#### In WPS (What's Playing Screen):

> [!IMPORTANT]
> Volume controls are separate from system volume.

|      Button     |           Action           |
|:---------------:|:--------------------------:|
|     DPAD UP     |          Volume UP         |
|    DPAD DOWN    |         Volume Down        |
|    DPAD LEFT    | Restart Song/Previous Song |
|  Hold DPAD LEFT |           Rewind           |
|    DPAD RIGHT   |          Next Song         |
| Hold DPAD RIGHT |        Fast-Forward        |
|     Press A     |         Play Pause         |
|      Hold A     |     Pause and Main Menu    |
|     Press B     |          Main Menu         |
|     Press X     |        File Browser        |
|      Hold X     |        Context Menu        |
|     Press Y     |          Playlist          |
|      Hold Y     |         Track Info         |
|        L1       |       Lock/Hold Input      |
|        R1       |     Shuffle/Repeat Menu    |
|     Hold R1     |         Pitch Menu         |

> [!NOTE]
> For detailed info on plugin controls [please check the wiki section](https://github.com/IncognitoMan/rockbox/wiki).

## Building

#### Environment

See [this guide](https://github.com/christianhaitian/arkos/wiki/Building#to-create-debian-based-chroots-in-a-linux-environment) on creating a chroot.

#### Configure
```
mkdir build
cd build
../tools/configure
```

Configure with the following options:
* Target platform: `200`
* LCD width: `320`
* LCD height: `240`
* Build Type: `N`
  - Alternatively, `A` and then `D` to enabled debugging.

Changes to `Makefile`:
```
export MEMORYSIZE=64

export LDOPTS= -lm -ldl -L/usr/lib -lSDL2 -lpthread

export RBDIR=/tmp/rockbox
export ROCKBOX_SHARE_PATH=/tmp/rockbox
export ROCKBOX_BINARY_PATH=/tmp/rockbox
export ROCKBOX_LIBRARY_PATH=/tmp/rockbox
```

Changes to `autoconf.h`:
```
#define ROCKBOX_DIR "/tmp/rockbox"
#define ROCKBOX_SHARE_PATH "/tmp/rockbox"
#define ROCKBOX_BINARY_PATH "/tmp/rockbox"
#define ROCKBOX_LIBRARY_PATH "/tmp/rockbox"
```

#### Build
```
make && make fullzip
```

## Thanks

[Rockbox Team](https://www.rockbox.org/) - For creating Rockbox.  
[Hairo](https://github.com/Hairo) - For helping with this port (battery status, plugins and path shenanigans).