/***************************************************************************
 *             __________               __   ___.
 *   Open      \______   \ ____   ____ |  | _\_ |__   _______  ___
 *   Source     |       _//  _ \_/ ___\|  |/ /| __ \ /  _ \  \/  /
 *   Jukebox    |    |   (  <_> )  \___|    < | \_\ (  <_> > <  <
 *   Firmware   |____|_  /\____/ \___  >__|_ \|___  /\____/__/\_ \
 *                     \/            \/     \/    \/            \/
 *
 * Copyright (C) 2025 Hairo R. Carela
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This software is distributed on an "AS IS" basis, WITHOUT WARRANTY OF ANY
 * KIND, either express or implied.
 *
 ****************************************************************************/
#include <sys/types.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

#include "system.h"
#include "power-target.h"
#include "power.h"
#include "panic.h"
#include "sysfs.h"

#include "tick.h"

/* We get called multiple times per tick, let's cut that back! */
static long last_tick = 0;
static bool last_power = false;

static char* get_path(const char *env_key)
{
    char *p = getenv(env_key);
    return (p && *p) ? p : NULL;
}

bool charging_state(void)
{
    if ((current_tick - last_tick) > HZ/2 ) {
        char buf[12] = {0};
        
        char *path = get_path("BATTERY_STATUS");

        if (path)
            sysfs_get_string(path, buf, sizeof(buf));

        last_tick = current_tick;
        last_power = (strncmp(buf, "Charging", 8) == 0);
    }
    return last_power;
}

unsigned int power_input_status(void)
{
    int present = 0;
    
    char *path = get_path("POWER_STATUS");

    if (path)
        sysfs_get_int(path, &present);

    return present ? POWER_INPUT_USB_CHARGER : POWER_INPUT_NONE;
}

unsigned int power_get_battery_capacity(void)
{
    int battery_level;

    char *path = get_path("CAPACITY_STATUS");

    if (path)
        sysfs_get_int(path, &battery_level);

    return battery_level;
}
