
export const postgres_regex = 'postgres:\/\/(?<PGUSER>[^:@]+)(:(?<PGPASSWORD>[^@]+))?@(?<PGHOST>[^\/:]+)(:(?<PGPORT>\d+))?\/(?<PGDATABASE>.*)'

# Parse postgres URI 
export def "from pg_uri" [] {
  $in
  | parse -r $postgres_regex
  | first
  | reject ...($in | columns | where $it =~ 'capture')
}

def "from psql" [] {
  $in
  | lines
  | [$in.0, ...($in | skip 2 | drop 1)]
  | str trim | split column -r '\s*\|\s*'
  | headers 
}

# Run an sql query and parse output into table
export def "pg query" [query: string] {psql -c $query --csv | from csv }


# List all tables
export def "pg tables" [] {pg query 'SELECT * FROM pg_catalog.pg_tables'}
