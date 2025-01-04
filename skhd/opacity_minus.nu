yabai -m query --windows | from json | where has-focus | first | get opacity | $in - 0.05
| [$in, 0.1] | math max | into string --decimals 2 | yabai -m window --opacity $in
