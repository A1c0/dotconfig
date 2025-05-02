export def cache [] {
  open ~/.config/sketchybar/states/display.nuon
}

export def refresh [] {
  let monitor_table = aerospace list-monitors --json
  | from json
  | select monitor-id
  | rename monitor_id
  | insert workspace {
    aerospace list-workspaces --monitor $in.monitor_id
    | lines
  }
  | flatten

  let display_monitor_table = sketchybar --query displays
  | from json
  | insert sort-value { $in.frame.x - $in.frame.y }
  | sort-by sort-value
  | enumerate
  | rename id
  | update id {$in + 1}
  | flatten
  | rename monitor_id display_id

  $monitor_table
  | join $display_monitor_table monitor_id
  | save -f ~/.config/sketchybar/states/display.nuon
}
