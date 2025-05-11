#!/usr/bin/env nu
use ../utils/aerospace.nu;

def main [] {
  let mode = aerospace list-modes --current;
  let aerospace_table = aerospace table;
  let focused_display = $aerospace_table | where focused | first | get display
  if ($mode == 'main') {
    sketchybar --set $env.NAME display=0
  } else {
    sketchybar --set $env.NAME label=($mode) display=($focused_display)
  }
}
