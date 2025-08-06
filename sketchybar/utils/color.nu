const palette_macchiato = {
  rosewater: "#f4dbd6",
  flamingo:  "#f0c6c6",
  pink:      "#f5bde6",
  mauve:     "#c6a0f6",
  red:       "#ed8796",
  maroon:    "#ee99a0",
  peach:     "#f5a97f",
  yellow:    "#eed49f",
  green:     "#a6da95",
  teal:      "#8bd5ca",
  sky:       "#91d7e3",
  sapphire:  "#7dc4e4",
  blue:      "#8aadf4",
  lavender:  "#b7bdf8",
  text:      "#cad3f5",
  subtext1:  "#b8c0e0",
  subtext0:  "#a5adcb",
  overlay2:  "#939ab7",
  overlay1:  "#8087a2",
  overlay0:  "#6e738d",
  surface2:  "#5b6078",
  surface1:  "#494d64",
  surface0:  "#363a4f",
  base:      "#24273a",
  mantle:    "#1e2030",
  crust:     "#181926"
}

const palette_mocha = {
  rosewater: "#f5e0dc",
  flamingo : "#f2cdcd",
  pink     : "#f5c2e7",
  mauve    : "#cba6f7",
  red      : "#f38ba8",
  maroon   : "#eba0ac",
  peach    : "#fab387",
  yellow   : "#f9e2af",
  green    : "#a6e3a1",
  teal     : "#94e2d5",
  sky      : "#89dceb",
  sapphire : "#74c7ec",
  blue     : "#89b4fa",
  lavender : "#b4befe",
  text     : "#cdd6f4",
  subtext1 : "#bac2de",
  subtext0 : "#a6adc8",
  overlay2 : "#9399b2",
  overlay1 : "#7f849c",
  overlay0 : "#6c7086",
  surface2 : "#585b70",
  surface1 : "#45475a",
  surface0 : "#313244",
  base     : "#1e1e2e",
  mantle   : "#181825",
  crust    : "#11111b"
}

def "nu-complete color_macchiato" [] { $palette_macchiato | columns }
def "nu-complete color_mocha" [] { $palette_mocha | columns }

# Generate unicode color
export def macchiato [
  color  :string@"nu-complete color_macchiato" # the color palette
  --alpha:float                                # the transpacency between 0 and 1
] {
  let prefix = $alpha
  | default 1
  | $in * 255
  | math floor
  | format number
  | get lowerhex

  $palette_macchiato
  | get $color
  | str replace '#' $prefix
}

export def mocha [
  color  :string@"nu-complete color_mocha" # the color palette
  --alpha:float                            # the transpacency between 0 and 1
] {
  let prefix = $alpha
  | default 1
  | $in * 255
  | math floor
  | format number
  | get lowerhex

  $palette_mocha
  | get $color
  | str replace '#' $prefix
}

