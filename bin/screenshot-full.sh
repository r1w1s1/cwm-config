#!/bin/sh

FILE="$HOME/screen-$(date +%Y-%m-%d_%H-%M-%S).png"

import -window root "$FILE"

