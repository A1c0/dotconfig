#!/usr/bin/env nu

use ./icon.nu *;
use ../utils/sketchy_display.nu

def find_workspace_display [workspace: string] {
  open ./states/display.nuon
  | where workspace == $workspace
  | get 0.display_id
}

def render_workspace [sid: string, workspace: string] {
  let app = aerospace list-windows --workspace $workspace --json
  | from json
  | get app-name
  | each { to-icon }
  | str join ''

  let focused_workspace = aerospace list-workspaces --focused
  let is_focused = $focused_workspace == $workspace

  let display = find_workspace_display $workspace

  if $is_focused {
    (sketchybar --set $sid $"label=($app)"
                           icon.color=0xeeeeeeee
                           label.color=0xeeeeeeee
                           background.color=0xff24273a
                           background.border_width=2
                           background.border_color=0xffcad3f5
                           $"display=($display)"
                           drawing=on)
  } else {
    if ($app | is-empty) {
      sketchybar --set $sid drawing=off
    } else {
     (sketchybar --set $sid $"label=($app)"
                            icon.color=0xdddddddd
                            label.color=0xdddddddd
                            background.color=0x9924273a
                            background.border_width=0
                            $"display=($display)"
                            drawing=on)
    }   
  }  
}

def main [sid: string, workspace: string] {
  match $env.SENDER {
    'aerospace_workspace_change' => {
      if ($workspace == $env.AEROSPACE_FOCUSED_WORKSPACE or $workspace == $env.AEROSPACE_PREV_WORKSPACE) {
        render_workspace $sid $workspace
      }
    }
    'aerospace_monitor_change' => { render_workspace $sid $workspace  }    
    'forced' => { render_workspace $sid $workspace }
    'space_windows_change' => { render_workspace $sid $workspace }
  }
}
