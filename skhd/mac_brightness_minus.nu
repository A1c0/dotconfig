mac-brightnessctl
| parse -r '(?<data>\d+.\d+)'
| get data
| first
| into float
| if $in == 0.1 {0.01} else if $in == 0.01 {0} else {$in - 0.1}
| [0, $in]
| math max
| mac-brightnessctl $in
