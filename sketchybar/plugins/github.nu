#!/usr/bin/env nu

use ../utils/github.nu;

let table = [
  [skechybar_item     , github_item];
  [github_release     , release],
  [github_issue_closed, issue_closed],
  [github_issue_open  , issue_open],
  [github_pr_closed   , pull_request_closed],
  [github_pr_merged   , pull_request_merged],
  [github_pr_open     , pull_request_open],
]

def main [] {
  let notification_count = github notifications_count;
  let options = $table
  | join -l $notification_count github_item type
  | update count {default 0}
  | each { |item |
    if $item.count == 0 {
      return [--set $item.skechybar_item drawing=false]
    } else {
      return [--set $item.skechybar_item drawing=true $"label=($item.count)"]
    }
  }
  | flatten 
  sketchybar ...$options
}
