### To run a new migration

```
migrate create -ext sql -dir db/migration -seq <migration_name>
```

Update the migration files

```
make migrateup
```

After running `make sqlc`, don't forget to run `make mock` to update the store

### Using DbDocs

```
npm install -g dbdocs
```

1. Copy DB schema from [Db Diagram](https://dbdiagram.io)
2. Create new folder/file in root (doc/db.dbml)
3. Run `dbdocs login`
4. Run `dbdocs build doc/db.dbml`
5. Run `dbdocs password --set <password> --project <project_name>` to set the password
