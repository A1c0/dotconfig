
# get battery status
export def 'status' [] {
  pmset -g batt
  | parse -r '-InternalBattery-0 \(id=\d+\)\s*(?<percentage>\d+)%;\s*(?<state>[^;]+);'
  | first
  | update percentage {into int}
}
