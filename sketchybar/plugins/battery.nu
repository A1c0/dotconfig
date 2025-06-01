#!/usr/bin/env nu

use ../utils/aldente.nu;
use ../utils/color.nu;

def get_icon [percentage:number, battery_state: string] {
  if $battery_state == "AC" {
     return '󰂄'
  }
  match $percentage {
    1..10 => {'󰁺'}
    11..20 => {'󰁻'}
    21..30 => {'󰁼'}
    31..40 => {'󰁽'}
    41..50 => {'󰁾'}
    51..60 => {'󰁿'}
    61..70 => {'󰂀'}
    71..80 => {'󰂁'}
    81..90 => {'󰂂'}
    91..100 => {'󰁹'}
  }
}

def get_color [aldente_state: string, battery_state: string] {
  if $battery_state == "AC" {
    if ($aldente_state == "Sailing" or $aldente_state == "HeatProtect") {
      color macchiato blue
    } else {
      color macchiato green
    }
  } else {
    color macchiato text
  }
}

def main [] {
  if ($env.SENDER == 'power_source_change') {
    $env.INFO | save -f "~/.battery-state"
  }
  let battery_state = open ~/.battery-state;
  let aldente_status = aldente status;
  let icon = get_icon $aldente_status.percentage $battery_state
  let icon_color = get_color $aldente_status.state $battery_state
  sketchybar --set $env.NAME $"label=($aldente_status.percentage)%" icon=($icon) icon.color=($icon_color)
  
}
