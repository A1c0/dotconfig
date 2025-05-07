#!/usr/bin/env nu

use ../utils/icon.nu;
use ../utils/color.nu;
use ../utils/aerospace.nu;

def render_workspace [
  --only_workspaces: list<string>
] {
  let aerospace_table = aerospace table | update apps {default [] | par-each {icon from name}};
  let options = if ($only_workspaces | is-not-empty) {
    $aerospace_table
    | where workspace in $only_workspaces
  } else {
    $aerospace_table
  }
  | par-each {|space|
  let sid = $"space.($space.workspace)"
    if $space.visible {
      return [
        --set, $sid, label=($space.apps | str join),
                     icon.color=(color macchiato text),
                     label.color=(color macchiato text),
                     background.color=(color macchiato base --alpha 0.9),
                     background.border_width=(if $space.focused {2} else {1}),
                     background.border_color=(color macchiato text),
                     display=($space.display),
                     drawing=on,
      ]
    } else {
      if ($space.apps | is-empty) {
        return [--set, $sid, drawing=off]
      } else {
        return [ --set, $sid, label=($space.apps | str join),
                              icon.color=(color macchiato text --alpha 0.8),
                              label.color=(color macchiato text --alpha 0.8),
                              background.color=(color macchiato base --alpha .6),
                              background.border_width=0,
                              display=($space.display),
                              drawing=on,
        ]
      }   
    }
  }

  sketchybar ...($options | flatten)

}

def main [] {
  match $env.SENDER {
    'aerospace_workspace_change' => {
      render_workspace --only_workspaces [$env.AEROSPACE_FOCUSED_WORKSPACE, $env.AEROSPACE_PREV_WORKSPACE] 
    },
    _ => { render_workspace }
  }
}
