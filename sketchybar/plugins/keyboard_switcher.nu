#!/usr/bin/env nu

def main [] {
  let current_app = do --ignore-errors {$env.INFO} | default ""

  match $current_app {
    "Ghostty" | "Webstorm" | "Alacritty" => {keyboardSwitcher select "French dev" | ignore }
    _ => {keyboardSwitcher select "French" | ignore}
  }
}
