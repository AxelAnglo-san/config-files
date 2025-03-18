#!/usr/bin/bash
### Sript that locks the screen with hyprlock

pidof hyprlock || hyprlock -q
