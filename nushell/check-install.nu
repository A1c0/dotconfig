export def main [dependencies: list<string>] {
  let not_installed = $dependencies | where {|dep| which $dep | is-empty }

  if ($not_installed | is-not-empty) {
    brew install ...$not_installed
  }  
}
