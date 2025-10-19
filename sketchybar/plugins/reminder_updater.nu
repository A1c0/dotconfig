#!/usr/bin/env nu

let PLUGIN_DIR = $"($env.CONFIG_DIR)/plugins"

use ../utils/color.nu;


def add_item [uuid: string, name: string, done_date: datetime] {
  let reminder_item = $"reminder-($uuid)"

  (sketchybar --add item $reminder_item right
              --set $reminder_item icon.font="Hack Nerd Font:Regular:11.0"
                                   background.color=(color mocha base --alpha 0.6)
                                   background.corner_radius=10
                                   background.height=25
                                   background.border_width=2
                                   background.padding_right=10
                                   icon.color=(color mocha text)
                                   icon.padding_right=10
                                   icon.padding_left=10
                                   label=($name)
                                   label.font="Hack Nerd Font:Regular:11.0"
                                   label.max_chars=10
                                   scroll_texts=true
                                   script=$"($PLUGIN_DIR)/reminder.nu ($name) ($done_date | format date '%+')"
                                   update_freq=1
                                   label.scroll_duration=200)
}

def main [] {
  let items = open ~/.cache/reminder.nuon

  for $item in $items {
    add_item $item.uuid $item.name $item.done_date
  }
}
