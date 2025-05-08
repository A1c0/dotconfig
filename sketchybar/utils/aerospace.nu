export def table [] {
  let visible_workspaces = aerospace list-workspaces --monitor all --visible | lines
  let focused_workspace = aerospace list-workspaces --focused

  let monitor_table = aerospace list-monitors --json
  | from json
  | select monitor-id
  | rename monitor
  | insert workspace {
    aerospace list-workspaces --monitor $in.monitor
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
  | rename monitor display
  | select monitor display

  let app_table = aerospace list-workspaces --monitor all --empty no
  | lines
  | wrap workspace
  | par-each {
    insert apps {
      aerospace list-windows --workspace $in.workspace --json
      | from json
      | get app-name
    }
  }

  $monitor_table
  | join -l $display_monitor_table monitor
  | join -l $app_table workspace | par-each {
    $in
    | insert visible {$in.workspace in $visible_workspaces}
    | insert focused {$in.workspace == $focused_workspace}
  }
}
