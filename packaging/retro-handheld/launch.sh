#!/bin/sh
PAK_DIR="$(dirname "$0")"
RBDIR="$PAK_DIR/rockbox"
RBDIR_BIND="/tmp/rockbox"
GPTOKEYB2="$PAK_DIR/gptokeyb2"
cd "$PAK_DIR" || exit 1
# properly set home directory to .userdata folder
HOME="$USERDATA_PATH"

# Set DEVICE_ID...
if [ $PLATFORM == "tg5040" ]; then
  if [ $DEVICE == "brick" ]; then
    RBDEVICE="TUI-Brick"
    . "$RBDIR/systems/tui-brick.sys"
  else
    RBDEVICE="TUI-SmartPro"
    . "$RBDIR/systems/tui-spoon.sys"
  fi
elif [ $PLATFORM == "my355" ]; then
  RBDEVICE="Miyoo-Flip"
  . "$RBDIR/systems/my355.sys"
else
  # While technically theres support for others, will need device specific GUID for gptokeyb2...
  echo "Unsupported platform."
  exit 1
fi

# -------
# ROCKBOX
# -------

# bind RBDIR to /tmp/rockbox.
if [ ! -f "$RBDIR_BIND/rockbox" ]; then
  mkdir -p "$RBDIR_BIND"
  mount --bind "$RBDIR" "$RBDIR_BIND"
fi

# Check and patch themes to use /media/rockbox path.
for theme in "$RBDIR/themes/*.cfg"; do
  sed -i 's#/.rockbox#/tmp/rockbox#g' $theme
done

unset SDL_HQ_SCALER SDL_ROTATION SDL_BLITTER_DISABLED

SDL_GAMECONTROLLERCONFIG=$(grep "$RBDEVICE" "$PAK_DIR/gamecontrollerdb.txt") $GPTOKEYB2 "$RBDIR/rockbox" -c "$PAK_DIR/rockbox.gptk" &
sleep 1 # All because of the TSP...
$RBDIR/rockbox --zoom $ZOOMVAL

kill -9 "$(pidof gptokeyb2)"
