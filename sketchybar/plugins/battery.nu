#!/usr/bin/env nu

use ../utils/aldente.nu;
use ../utils/color.nu;

def get_icon [percentage:number, state:string] {
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

def main [] {
  let status = aldente status;
  let icon = get_icon $status.percentage $status.state
  sketchybar --set $env.NAME label=($status.percentage)% icon=($icon) icon.color=(color macchiato text)
}
