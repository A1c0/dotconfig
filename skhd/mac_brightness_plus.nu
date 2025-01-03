mac-brightnessctl
| parse -r '(?<data>\d+.\d+)'
| get data
| first
| into float
| if $in == 0 {0.01} else if $in == 0.01 {0.1} else {$in + 0.1}
| [1, $in]
| math min
| mac-brightnessctl $in
