#!/bin/sh

FILE="$HOME/area-$(date +%Y-%m-%d_%H-%M-%S).png"

# stop xhidecursor if running
if pgrep -x xhidecursor >/dev/null; then
    pkill -x xhidecursor
    RESTART=1
else
    RESTART=0
fi

import "$FILE"

# restart xhidecursor if it was running
if [ "$RESTART" -eq 1 ]; then
    xhidecursor &
fi

