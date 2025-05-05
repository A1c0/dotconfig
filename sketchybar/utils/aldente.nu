
# get AlDente battery status
export def 'status' [] {
  let shortcuts = [
    "AlDente - Get State",
    "Aldente - Get Battery Percentage"
  ];

  $shortcuts
  | par-each { shortcuts run $in | into string }
  | do { |value| [state, percentage] | zip $value } $in
  | into record
  | update percentage {into int}
}
