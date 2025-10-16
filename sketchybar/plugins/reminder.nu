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
  # (terminal-notifier -message "Reminder"
  #                    -title $name
  #                    -sound "Funk"
  #                   )
}

def on-event-finish [name: string] {
  sketchybar --remove $env.NAME
  send-push-notif $name
}

def main [name: string, done_date: string] {
  let remaining_time = ($done_date | into datetime) - (date now);

  if ($remaining_time < 1sec) {
    on-event-finish $name
  } else {
    sketchybar --set $env.NAME icon=(normalize_duration $remaining_time)
  }
}
