#!/usr/bin/env nu

use ../utils/icon.nu;
use ../utils/color.nu;
use ../utils/aerospace.nu;

def render_visible_workspace [item, table] {

  let display = $item.display;
  let workspace = $item.workspace;
  let is_focused = $item.focused;

  let focused_app = $item | get apps | where focused | get 0.name --optional | if ($in | is-not-empty ) {icon from name}
  let unfocused_apps = $item | get apps | where focused == false | get name | each {icon from name} | str join ''
  let border_width = if $is_focused { 2 } else { 1 }

  let workspace_option = [
      --set $"focused_space.($display).label" icon=($workspace)
      --set $"focused_space.($display).focused_app" label=($focused_app) drawing=($focused_app | is-not-empty) 
      --set $"focused_space.($display).unfocused_apps" label=($unfocused_apps) drawing=($unfocused_apps | is-not-empty)

      --set $"focused_space.($display).panel" background.border_width=($border_width),
                                              background.border_color=( if $is_focused { color mocha mauve } else { color mocha text } )
                                              background.height=( 25 + $border_width )
      --move $"focused_space.($display).label" after $"space.($workspace)"
      --move $"focused_space.($display).focused_app" after $"focused_space.($display).label"
      --move $"focused_space.($display).unfocused_apps" after $"focused_space.($display).focused_app"
      --move $"focused_space.($display).panel" after $"focused_space.($display).unfocused_apps"
  ]

  return $workspace_option
}

def render_workspace [
  --only_workspaces: list<string>
] {
  let aerospace_table = aerospace table;

  let options = if ($only_workspaces | is-not-empty) {
    $aerospace_table
    | where workspace in $only_workspaces
  } else {
    $aerospace_table
  }
  | par-each {|space|
  let sid = $"space.($space.workspace)"
    if $space.visible {
      return ( render_visible_workspace $space $aerospace_table | prepend [ --set $sid drawing=off ] )
      } else {
      if ($space.apps | is-empty) {
        return [--set, $sid, drawing=off]
      } else {
        return [ --set, $sid, label=($space.apps | get name | each {icon from name} | str join),
                              icon.color=(color mocha text --alpha 0.8),
                              label.color=(color mocha text --alpha 0.8),
                              background.color=(color mocha base --alpha .6),
                              background.border_width=0,
                              display=($space.display),
                              drawing=on,
        ]
      }   
    }
  }

  let all_options = $options | flatten --all

  sketchybar ...$all_options

}

def main [] {
  match $env.SENDER {
    'aerospace_workspace_change' => {
      render_workspace --only_workspaces [$env.AEROSPACE_FOCUSED_WORKSPACE, $env.AEROSPACE_PREV_WORKSPACE] 
    },
    _ => { render_workspace }
  }
}
