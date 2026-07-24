#!/bin/sh
#
# Copyright 2025  r1w1s1
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
# EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# root-daynight.sh
#
# Simple time-based root background policy for X11.
#
# Design principles:
# - Always set a solid root color (primary, fast, no dependencies)
# - Optional wallpaper overlay (secondary, via hsetroot)
# - Long-running loop with stable process count
# - Safe to call from xinitrc (will not duplicate)
#

# ---------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------

DAY_COLOR="#c6ccd6"
NIGHT_COLOR="#24272d"

# Leave empty ("") to disable wallpapers
DAY_WALLPAPER="/home/r1w1s1/wallpapers/slackware-simple.png"
NIGHT_WALLPAPER="/home/r1w1s1/wallpapers/slackware-simple.png"

DAY_START=9     # 09:00
NIGHT_START=19  # 19:00

SLEEP_TIME=300  # seconds between checks

# ---------------------------------------------------------------------
# Internal state / locking
# ---------------------------------------------------------------------

# /run/user/<UID>/root-daynight.pid
PIDFILE="${XDG_RUNTIME_DIR:-/tmp}/root-daynight.pid"

# Prevent multiple instances
if [ -f "$PIDFILE" ]; then
    OLD_PID=$(cat "$PIDFILE" 2>/dev/null)
    if [ -n "$OLD_PID" ] && kill -0 "$OLD_PID" 2>/dev/null; then
        exit 0
    fi
fi

echo $$ > "$PIDFILE"

cleanup() {
    rm -f "$PIDFILE"
    exit 0
}

trap cleanup INT TERM EXIT

# ---------------------------------------------------------------------
# Dependencies
# ---------------------------------------------------------------------

command -v xsetroot >/dev/null 2>&1 || {
    echo "root-daynight: xsetroot not found" >&2
    exit 1
}

# feh is only required if wallpapers are enabled
if [ -n "$DAY_WALLPAPER" ] || [ -n "$NIGHT_WALLPAPER" ]; then
    command -v hsetroot >/dev/null 2>&1 || {
        echo "root-daynight: hsetroot not found (required for wallpaper support)" >&2
        exit 1
    }
fi

# ---------------------------------------------------------------------
# Validate wallpaper files
# ---------------------------------------------------------------------

if [ -n "$DAY_WALLPAPER" ] && [ ! -f "$DAY_WALLPAPER" ]; then
    echo "root-daynight: Warning: DAY_WALLPAPER not found: $DAY_WALLPAPER" >&2
    DAY_WALLPAPER=""
fi

if [ -n "$NIGHT_WALLPAPER" ] && [ ! -f "$NIGHT_WALLPAPER" ]; then
    echo "root-daynight: Warning: NIGHT_WALLPAPER not found: $NIGHT_WALLPAPER" >&2
    NIGHT_WALLPAPER=""
fi

# ---------------------------------------------------------------------
# Main loop
# ---------------------------------------------------------------------

STATE=""

while :; do
    # Strip leading zero to avoid octal interpretation issues
    HOUR=$(date +%H)
    HOUR=${HOUR#0}  
 
    # Handle empty string (midnight edge case)
    [ -z "$HOUR" ] && HOUR=0

    if [ "$HOUR" -ge "$NIGHT_START" ] || [ "$HOUR" -lt "$DAY_START" ]; then
        NEW_STATE="night"
        COLOR="$NIGHT_COLOR"
        WALLPAPER="$NIGHT_WALLPAPER"
    else
        NEW_STATE="day"
        COLOR="$DAY_COLOR"
        WALLPAPER="$DAY_WALLPAPER"
    fi

    if [ "$NEW_STATE" != "$STATE" ]; then
        # Always set base root color
        xsetroot -solid "$COLOR"

        # Optional wallpaper overlay
        if [ -n "$WALLPAPER" ]; then
            hsetroot -fill "$WALLPAPER" 
        fi

        STATE="$NEW_STATE"
    fi

    sleep "$SLEEP_TIME"
done
