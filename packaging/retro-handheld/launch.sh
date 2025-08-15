#!/bin/sh
PAK_DIR="$(dirname "$0")"
RBDIR="$PAK_DIR/rockbox"
RBDIR_BIND="/tmp/rockbox"
GPTOKEYB2="$PAK_DIR/gptokeyb2"
cd "$PAK_DIR" || exit 1
# properly set home directory to .userdata folder
HOME="$USERDATA_PATH"

# -------
# ROCKBOX
# -------

# bind RBDIR to /tmp/rockbox.
if [ ! -f "$RBDIR_BIND/rockbox" ]; then
  mkdir -p "$RBDIR_BIND"
  mount --bind "$RBDIR" "$RBDIR_BIND"
fi

# Set main power_supply path.
POWERPATH="/sys/class/power_supply"
# Save panel res values.
PANEL_XVAL="$(cat /sys/class/disp/disp/attr/xres)"
PANEL_YVAL="$(cat /sys/class/disp/disp/attr/yres)"

# Check what battery path we set.
if [ -d "$POWERPATH/axp2202-battery" ]; then
  BATTPATH="axp2202"
else 
  BATTPATH=""
fi

# Create links to battery paths for capacity, status and online
if [ -n "$BATTPATH" ]; then
  if [[ "$BATTPATH" == "axp2202" ]]; then
    if [ ! -f "/tmp/rb_batt" ]; then
      ln -s "$POWERPATH/$BATTPATH-battery/capacity" "/tmp/rb_batt"
    fi
    if [ ! -f "/tmp/rb_charge" ]; then
      ln -s "$POWERPATH/$BATTPATH-battery/status" "/tmp/rb_charge"
    fi
    if [ ! -f "/tmp/rb_usb" ]; then
      ln -s "$POWERPATH/$BATTPATH-usb/online" "/tmp/rb_usb"
    fi
  fi
else
  if [ ! -f "/tmp/rb_batt" ]; then
    echo "-1" > "/tmp/rb_batt"
  fi
  if [ ! -f "/tmp/rb_charge" ]; then
    echo "Discharging" > "/tmp/rb_charge"
  fi
  if [ ! -f "/tmp/rb_usb" ]; then
    echo "0" > "/tmp/rb_usb"
  fi
fi

# Set zoom/device value
if [[ "$PANEL_XVAL" == "1024" ]]; then
  ZOOMVAL="3.2" # TUI BRICK
  RBDEVICE="TUI-Brick"
elif [[ "$PANEL_XVAL" == "720" ]]; then
  ZOOMVAL="3" # TUI Smart Pro
  RBDEVICE="TUI-SmartPro"
else
  ZOOMVAL="1"
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
