
# Clean all the images key in the database
export def "clean-all-img-key" [] {
    alias psql = docker exec -w /dumps -e PGUSER=postgres apricity-nap-postgres-1 psql;
    psql -U postgres -d liv -c "UPDATE apricity_client.client SET picture = NULL"
    psql -U postgres -d liv -c "UPDATE apricity_staff.staff SET picture = NULL"
}

# Hash a password to setup a user in the database
export def "hash-password" [
    password:string # The password to hash
    ] {
    node /Users/a1c0/dev/apricity-nap/apricity-api/sandbox/hash-password.js $password
}

# Start the api/web serveur with performance monitoring
export def "dashboard" [] {
    wd api;
    zellij -l dashboard/full-nap-debug.kdl
} 

# Down and restore the database from the latest dump and run the migrations
export def "db reset" [] {
    wd api;

    let dump = ls dumps 
    | where name =~ 'staging.*\.dump' 
    | sort-by modified 
    | last 
    | get name 
    | str replace 'dumps/' ''

    y;
    yb;
    dcdn postgres; 
    dcup -d postgres; 
    sleep 2sec;
    try {
        docker exec -w /dumps apricity-nap-postgres-1 pg_restore -d liv -U postgres -O staging-2024-06-26.dump
    } catch {} ;
    NODE_ENV=dev ./node_modules/.bin/typeorm migration:run --config ./dist/ormconfig.json
    clean-all-img-key;
}

# Generate a new migration based on entities changes
export def "db migration generate" [name: string] {
    wd api;
    y;yb;
    let output = NODE_ENV=dev ./node_modules/.bin/typeorm migration:generate --config dist/ormconfig.json --dir src/data/migration --pretty --name $name;
    print $output;
    $output | str replace -r '^.*?(\/.*?\.ts).*$' '$1' | ws $in
}

# Delete the last migration and generate a new one
export def "db migration refresh" [] {
    wd api;    
    let file = ls src/data/migration | sort-by modified | last | get name;
    let name = $file | str replace -r '.*\d+\-(.*?)\.ts' '$1';
    rm $file;
    db migration generate $name;
}

def --env "db_set_env" [environment: string] {
    const postgres_regex = 'postgres:\/\/(?<PGUSER>[^:@]+)(:(?<PGPASSWORD>[^@]+))?@(?<PGHOST>[^:]+):(?<PGPORT>\d+)\/(?<PGDATABASE>[a-z_]+)';
    let pg_config = op read $"op://SysAdmin/Postgres URL/NAP/($environment)" | parse -r $postgres_regex | first | reject capture1;
    load-env $pg_config;
}

export def --env "db set_env staging" [] {
    db_set_env staging
}

export def --env "db set_env production" [] {
    db_set_env production
}

def "complete_bump_types" [] { ["patch", "minor", "major"] }

export def "bump" [type: string@complete_bump_types] {
    yarn run $"bump:($type)"
    git commit --all --message $"🔖 (open package.json | get version)"
}

def "redis_cli_complete" [] {["production", "nonproduction"]}

# use redis-cli on production or nonproduction pod
export def "redis-cli" [
stage: string@redis_cli_complete
-c : string
] {
    print $"(ansi yellow)Warning: It use VPN to connect to pod, be sure it's on(ansi reset)"
    if ($stage == "nonproduction") {
        AWS_PROFILE=nonproduction aws eks update-kubeconfig --region eu-west-1 --name apr-eks-nonproduction
        let pod_name = kubectl get pods -n nap-staging
        | detect columns 
        | rename -b {str snake-case } 
        | where name like 'api' and status == 'Running' 
        | first 
        | get name;
        print $"Connect to ($pod_name)..."
        kubectl exec -it $pod_name -n nap-staging -- /bin/bash -c 'redis-cli -u $REDIS_URI'
    } else if ($stage == "production") {
        AWS_PROFILE=production aws eks update-kubeconfig --region eu-west-1 --name apr-eks-production
        let pod_name = kubectl get pods -n nap-production 
        | detect columns 
        | rename -b {str snake-case } 
        | where name like 'api' and status == 'Running' 
        | first 
        | get name;
        print $"Connect to ($pod_name)..."
        kubectl exec -it $pod_name -n nap-production -- /bin/bash -c 'redis-cli -u $REDIS_URI'
  }
}
