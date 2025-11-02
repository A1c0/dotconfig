#!/usr/bin/env nu

def normalize_duration [duration: duration] {
  $duration
  | into record
  | transpose
  | take 1
  | transpose -rd
  | into duration
}

def send-push-notif [name : string] {
  osascript -e $"tell application "Notifier" to notify\("Reminder", "($name)", "funk")"
}

def on-event-finish [name: string] {
  sketchybar --remove $env.NAME
  send-push-notif $name
}

def main [uuid: string] {
  let item = open ~/.cache/reminder.nuon
  | where uuid == $uuid
  | get 0 --optional

  if ($item | is-not-empty) {
    let remaining_time = ( $item.done_date | into datetime ) - ( date now );

    if ($remaining_time < 1sec) {
      on-event-finish $item.name
    } else {
      sketchybar --set $env.NAME icon=( normalize_duration $remaining_time )
    }

  }
}
