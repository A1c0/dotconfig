#!/usr/bin/env nu

use ../utils/icon.nu;
use ../utils/color.nu;
use ../utils/aerospace.nu;

def render_visible_workspace [item, table] {

  let display = $item.display;
  let workspace = $item.workspace;
  let is_focused = $item.focused;
  let is_another_workspace_in_display = $table | where display == $display and workspace != $workspace | length | $in > 0;
  print "display" $display
  print "workspace" $workspace
  print "is_focused" $is_focused
  print "is_another_workspace_in_display" $is_another_workspace_in_display

  let separator_sid = $"space_separator.($display)"
  let label_sid = $"focused_space.($display).label"
  let panel_sid = $"focused_space.($display).panel"
  let endind_paddind_sid = $"focused_space.($display).item.last"

  let app_options = $item.apps | enumerate | each {|app_item|
    print app_item $app_item
    let app_sid = $"focused_space.($display).item.($app_item.index)"
    return [
      --add item $app_sid left
      --set $app_sid "label.font=sketchybar-app-font:Regular:16.0"
                     label=($app_item.item | get name | icon from name)
                     label.color=(if $app_item.item.focused {color macchiato mauve} else {color macchiato text})
                     icon.drawing=false
                     label.padding_left=4
                     label.padding_right=4
                    display=($display)
    ]
  }

  let workspace_option = [
    --set $separator_sid drawing=($is_another_workspace_in_display)
    --remove $"/focused_space.($display).*/"

      --add item $"focused_space.($display).label" left
      --set $"focused_space.($display).label" "icon.font=SF Pro:Bold:15.0"
                                              label.drawing=false
                                              icon=($workspace)
                    display=($display)
      ...$app_options
      --add item $"focused_space.($display).item.last" left
      --set $"focused_space.($display).item.last" label.padding_right=4
                                                  icon.drawing=false
                                                  label.padding_left=0
                    display=($display)
      --add bracket $"focused_space.($display).panel" $"/focused_space.($display).*/"
      --set         $"focused_space.($display).panel" background.color=(color macchiato base --alpha 0.9)
                                          background.corner_radius=5
                                          background.height=25
                                          blur_radius=50
                                          background.border_width=(if $is_focused {2} else {1}),
                                          background.border_color=(if $is_focused {color macchiato mauve} else {color macchiato text})
                    display=($display)
  ]

  return ($workspace_option | append $app_options)

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
      let a = render_visible_workspace $space $aerospace_table
      return ([ --set $sid drawing=off ] | append $a | flatten )
      } else {
      if ($space.apps | is-empty) {
        return [--set, $sid, drawing=off]
      } else {
        return [ --set, $sid, label=($space.apps | get name | each {icon from name} | str join),
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

  let all_options = $options | flatten --all
  print $all_options

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
