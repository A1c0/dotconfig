#!/usr/bin/env nu

use ../utils/icon.nu;
use ../utils/aerospace.nu;

def render_workspace [] {

  let aerospace_table = aerospace table | update apps {default [] | par-each {icon from name}};
  let options = $aerospace_table | par-each {|space|
  let sid = $"space.($space.workspace)"
    if $space.visible {
      return [
        --set, $sid, $"label=($space.apps | str join)",
                     icon.color=0xeecad3f5,
                     label.color=0xeecad3f5,
                     background.color=0xff24273a,
                     background.border_width=(if $space.focused {2} else {1}),
                     background.border_color=0xffcad3f5,
                     $"display=($space.display)",
                     drawing=on,
      ]
    } else {
      if ($space.apps | is-empty) {
        return [--set, $sid, drawing=off]
      } else {
        return [ --set, $sid, $"label=($space.apps | str join)",
                              icon.color=0xddcad3f5,
                              label.color=0xddcad3f5,
                              background.color=0x9924273a,
                              background.border_width=0,
                              $"display=($space.display)",
                              drawing=on,
        ]
      }   
    }
  }

  sketchybar ...($options | flatten)

}

def main [] {
  # match $env.SENDER {
    # 'aerospace_workspace_change' => {
    #   # if ($workspace == $env.AEROSPACE_FOCUSED_WORKSPACE or $workspace == $env.AEROSPACE_PREV_WORKSPACE) {
    #   #   render_workspace $sid $workspace
    #   # }
    # }
  # }
  render_workspace 
}
