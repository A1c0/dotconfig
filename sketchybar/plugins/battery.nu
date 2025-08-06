#!/usr/bin/env nu

use ../utils/battery.nu;
use ../utils/color.nu;

def get_icon [percentage:number, battery_state: string] {
  if $battery_state == "AC attached" or $battery_state == "charging" {
     return '󰂄'
  }
  match $percentage {
    1..10 => '󰁺'
    11..20 => '󰁻'
    21..30 => '󰁼'
    31..40 => '󰁽'
    41..50 => '󰁾'
    51..60 => '󰁿'
    61..70 => '󰂀'
    71..80 => '󰂁'
    81..90 => '󰂂'
    91..100 => '󰁹'
  }
}

def get_color [state: string] {
  match $state {
    "AC attached" => (color mocha blue),
    "charging" => (color mocha green),
    _ => (color mocha text)
  }
}

def main [] {
  let status = battery status;
  let icon = get_icon $status.percentage $status.state
  let icon_color = get_color $status.state

  sketchybar --set $env.NAME $"label=($status.percentage)%" icon=($icon) icon.color=($icon_color)
}
