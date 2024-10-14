
# Run an sql query and parse output into table
export def "pg query" [query: string] {psql -c $query --csv | from csv }


# List all tables
export def "pg tables" [] {pg query 'SELECT * FROM pg_catalog.pg_tables'}
