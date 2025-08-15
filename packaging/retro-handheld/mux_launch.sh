#!/bin/bash
# HELP: Rockbox
# ICON: music
# GRID: Rockbox

. /opt/muos/script/var/func.sh
echo app >/tmp/act_go

# Set paths
RBDIR="$(GET_VAR "device" "storage/rom/mount")/MUOS/application/Rockbox"
RBDIR_BIND="/tmp/rockbox"
GPTOKEYB2="$(GET_VAR "device" "storage/rom/mount")/MUOS/emulator/gptokeyb/gptokeyb2"

# Store current idle input/display settings
IDLEDISP="$(GET_VAR "config" "settings/power/idle_display")"
IDLEMUTE="$(GET_VAR "config" "settings/power/idle_mute")"
IDLESLEEP="$(GET_VAR "config" "settings/power/idle_sleep")"
BACKLIGHT_VAL="$(DISPLAY_READ lcd0 getbl)"

# Override idle settings
SET_VAR "config" "settings/power/idle_display" 0
SET_VAR "config" "settings/power/idle_mute" 0
SET_VAR "config" "settings/power/idle_sleep" 0

SETUP_SDL_ENVIRONMENT

# bind RBDIR to /tmp/rockbox.
if [ ! -f "$RBDIR_BIND/rockbox" ]; then
  mkdir -p "$RBDIR_BIND"
  mount --bind "$RBDIR" "$RBDIR_BIND"
fi

# -------
# ROCKBOX
# -------

# Set main power_supply path.
POWERPATH="/sys/class/power_supply"
# Save panel res values.
PANEL_XVAL="$(cat /sys/class/disp/disp/attr/xres)"
PANEL_YVAL="$(cat /sys/class/disp/disp/attr/yres)"

# Check what battery path we set.
# Note: These are the paths checked by Portmaster and only axp2202 is
# known at the moment.
if [ -d "$POWERPATH/axp2202-battery" ]; then
  BATTPATH="axp2202"
else 
  BATTPATH=""
fi

# Create links to battery paths for capacity, status and online
# Note: Currently only axp2202 is known... need info for the rest...
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

# Set zoom value
if [[ "$PANEL_XVAL" == "640" ]]; then
  ZOOMVAL="2" # 35XX line, 40XX line, 28XX, zero28
elif [[ "$PANEL_XVAL" == "720" ]]; then
  if [[ "$PANEL_YVAL" == "720" ]]; then
    ZOOMVAL="2.25" # CUBEXX
  elif [[ "$PANEL_YVAL" == "480" ]]; then
    ZOOMVAL="2" # 34XX/34XXSP
  elif [[ "$PANEL_YVAL" == "1280" ]]; then
    ZOOMVAL="3" # TUI Smart Pro
  fi
elif [[ "$PANEL_XVAL" == "1024" ]]; then
  ZOOMVAL="3.2" # TUI BRICK
else
  ZOOMVAL="1"
fi

cd "$RBDIR" || exit

SET_VAR "system" "foreground_process" "rockbox"

# Check and patch themes to use /media/rockbox path.
for theme in "themes/*.cfg"; do
  sed -i 's#/.rockbox#/tmp/rockbox#g' $theme
done

> "$RBDIR/log.txt" && exec > >(tee "$RBDIR/log.txt") 2>&1

unset SDL_HQ_SCALER SDL_ROTATION SDL_BLITTER_DISABLED

$GPTOKEYB2 "./rockbox" -c "./rockbox.gptk" &
sleep 1 # Seems like TUI Smart Pro needs a 1 sec delay... for reasons...
./rockbox --zoom $ZOOMVAL

# Restore idle settings
SET_VAR "config" "settings/power/idle_display" $IDLEDISP
SET_VAR "config" "settings/power/idle_mute" $IDLEMUTE
SET_VAR "config" "settings/power/idle_sleep" $IDLESLEEP
# Restore backlight value
DISPLAY_WRITE lcd0 setbl $BACKLIGHT_VAL

kill -9 "$(pidof gptokeyb2)"

