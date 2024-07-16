
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