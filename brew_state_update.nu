# The list of installed brew formulae and casks as a nu table
def "brew state" [] {
    let brew_formula = brew list --installed-on-request -1 | lines; 
    brew info --json=v2 --installed 
    | from json 
    | update formulae {
        where name in $brew_formula 
        | select name full_name tap versions 
        | rename --block {str camel-case}} 
    | update casks {
        select token full_token tap name version 
        | rename --block {str camel-case}}
}

http post --content-type application/json --headers [api-key, '7cbc6d30-0f4f-4d7e-8fbc-3a39d31d271c'] https://dev.a1c0.com/brew (brew state);

print $"(ansi green)✓(ansi reset) Brew state updated on https://dev.a1c0.com/brew";