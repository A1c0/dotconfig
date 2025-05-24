#!/usr/bin/env nu

def main [] {
  sketchybar --set $env.NAME $"label=(date now | format date '%T')"
}


