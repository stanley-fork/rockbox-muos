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

Would ***highly*** suggest setting database scan directory before scanning/building the database. Have `Database` highlighted, press `START` button to pull up the database menu and scroll down and select the `Select directories to scan` option.

Press `A` to enter highlighted directories. Once you have you your main music folder highlighted, press `A` again until the folder icon turns into a "play" symbol. Press `B` to exit and press `A` to save changes, then `A` again to initialize database.

When it finishes, restart Rockbox.

#### Installing Themes:

> [!NOTE]
> Themes created pre-4.0 may not display correctly even if listed as working with 4.0/dev build.

Download any themes from the `Ipod Classic` section [here](https://themes.rockbox.org/index.php?target=ipod6g) and extract. Copy the contents inside the `.rockbox` folder into the `rockbox` directory. 

Make sure to restart Rockbox to fix theme paths before applying a theme.

## Controls

> [!NOTE]
> Controls more or less follow the RG Nano port of Rockbox, see [the manual from the dev builds](https://download.rockbox.org/manual/rockbox-rgnano.pdf) for more info as well as plugin controls.

#### In Menu:

|   Button   |       Action      |
|:----------:|:-----------------:|
|   DPAD UP  |      Move UP      |
|  DPAD DOWN |     Move DOWN     |
|  DPAD LEFT |      Page UP      |
| DPAD Right |     Page DOWN     |
|   Press A  |    Enter/Accept   |
|   Press B  |        Back       |
|   Press X  |        WPS        |
|   Press Y  |     Main Menu     |
|    START   |    Context Menu   |
|   Hold L1  |   Stop Playback   |
|     L1     |  Hotkey Function  |
|     R1     | Quick Screen Menu |
|    L2+R2   |    Lock / Hold    |
|  START+R2  |  Shutdown (Exit)  |

#### In WPS (What's Playing Screen):

> [!IMPORTANT]
> Volume controls are separate from system volume.

|      Button     |                        Action                       |
|:---------------:|:---------------------------------------------------:|
|     DPAD UP     |                      Volume UP                      |
|    DPAD DOWN    |                     Volume Down                     |
|    DPAD LEFT    |             Restart Song / Previous Song            |
|  Hold DPAD LEFT |                        Rewind                       |
|    DPAD RIGHT   |                      Next Song                      |
| Hold DPAD RIGHT |                     Fast-Forward                    |
|     Press A     |                     Play / Pause                    |
|      Hold A     |                 Pause and Main Menu                 |
|     Press B     |                      Main Menu                      |
|     Press X     |                      Track Info                     |
|     Press Y     | Return to `FILE BROWSER` / `DATABASE` / `PLAYLISTS` |
|      START      |                     Context Menu                    |
|        L1       |      WPS Hotkey Function<br>(Default: Playlist)     |
|        R1       |                  Quick Screen Menu                  |
|     Hold R1     |                     Pitch Screen                    |
|      L2+R2      |                     Lock / Hold                     |

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
* Target platform: `210`
* Build Type: `N`
  - Alternatively, `A` and then `D` to enabled debugging.

#### Build and ZIP
```
make
make rhbuild
```

* For muOS: `make muos-zip`
* for NextUI: `make nextui-zip`

## Thanks

[Rockbox Team](https://www.rockbox.org/) - For creating Rockbox.  
[Hairo](https://github.com/Hairo) - For helping with this port (battery status, plugins and path shenanigans).