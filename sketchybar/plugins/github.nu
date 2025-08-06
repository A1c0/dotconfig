#!/usr/bin/env nu

use ../utils/github.nu;
use ../utils/internet.nu;
use ../utils/color.nu;

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
  let there_is_not_internet = internet there_is_not_internet;
  if $there_is_not_internet {
    let options = $table
    | each {|item| [--set $item.skechybar_item drawing=false]}
    | prepend [--set $env.NAME drawing=true icon.color=(color mocha overlay2)]
    | flatten

    sketchybar ...$options
    return
  }

  let notification_count = do --ignore-errors {github notifications_count};
  let options = if ($notification_count | is-empty) {
    $table
    | each {|item| [--set $item.skechybar_item drawing=false]}
    | prepend [--set $env.NAME drawing=flase]
  } else {
    $table
    | join -l $notification_count github_item type
    | update count {default 0}
    | each { |item |
      if $item.count == 0 {
        return [--set $item.skechybar_item drawing=false]
      } else {
        return [--set $item.skechybar_item drawing=true label=($item.count)]
      }
    }
    | prepend [--set $env.NAME drawing=true icon.color=(color mocha text)]
  }
  | flatten
  sketchybar ...$options 
}
