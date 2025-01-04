yabai -m query --windows | from json | where has-focus | first | get opacity | $in + 0.05
| [$in, 1] | math min | into string --decimals 2 | str replace ',' '.' | yabai -m window --opacity $in
