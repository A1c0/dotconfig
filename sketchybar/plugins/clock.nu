#!/usr/bin/env nu

# The $NAME variable is passed from sketchybar and holds the name of
# the item invoking this script:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting

def main [] {
  sketchybar --set $env.NAME $"label=(date now | format date '%R')"
}


