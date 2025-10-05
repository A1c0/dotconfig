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
  (terminal-notifier -message "Reminder"
                     -title $name
                     -sound "Funk"
                     -appIcon "/chemin/vers/votre/icone.png")
}

def on-event-finish [item : record<uuid: string, name: string, done_date: string>] {
  sketchybar --remove $env.NAME
  open ~/.cache/sketchybar.sqlite | query db $"DELETE FROM reminder WHERE uuid = '($item.uuid)'"
  send-push-notif $item.name
}

def main [uuid: string] {
  let db = open ~/.cache/sketchybar.sqlite;
  let item = $db | query db $"SELECT * FROM reminder WHERE uuid = '($uuid)'" | first ;
  let remaining_time = ($item.done_date | into datetime) - (date now);

  print $remaining_time
  print (normalize_duration $remaining_time)
  print $item;

  if ($remaining_time < 1sec) {
    on-event-finish $item
  } else {
    sketchybar --set $env.NAME icon=(normalize_duration $remaining_time)
  }
}
