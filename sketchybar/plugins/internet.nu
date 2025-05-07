#!/usr/bin/env nu

use ../utils/internet.nu;


def main [] {
  sketchybar --set $env.NAME drawing=(internet there_is_not_internet)
}
