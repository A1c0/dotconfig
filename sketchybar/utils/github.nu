export def notifications_count [] {
  let notifications = gh api notifications
  | from json
  | get subject
  | where type in ["Issue", "PullRequest", "Release"]
  | select type url
  | par-each {
    insert state { |item |
      if ($item.type in ["Issue", "PullRequest"]) {
        let notification = gh api $item.url | from json

        if ($notification.state == "closed") {
          if $notification.merged {
            return 'merged'
          } else {
            return 'closed'
          }
        } else {
          return 'open'
        }
      }
    }
  };

  if ($notifications | is-not-empty) {
    return ($notifications
    | reject url
    | each {values | str join '_' | str snake-case }
    | group-by --to-table
    | update items { length }
    | rename type count)
  } else {
    return []
  }
}
