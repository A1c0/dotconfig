#!/usr/bin/env nu

def main [] {
  let current_app = do --ignore-errors {$env.INFO} | default ""

  match $current_app {
    "Ghostty" => {keyboardSwitcher select "French dev"}
    _ => {keyboardSwitcher select "French"}
  }
}
