#!/usr/bin/env nu

use ../utils/aldente.nu;

def get_icon [percentage:number] {
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
  let icon = get_icon $status.percentage
  sketchybar --set $env.NAME label=($status.percentage)% icon=($icon)
}
