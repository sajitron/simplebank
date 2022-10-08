### To run a new migration

```
migrate create -ext sql -dir db/migration -seq <migration_name>
```

Update the migration files

```
make migrateup
```

After running `make sqlc`, don't forget to run `make mock` to update the store