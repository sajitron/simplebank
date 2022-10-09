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
npm install --location=global dbdocs
```

1. Copy DB schema from [Db Diagram](https://dbdiagram.io)
2. Create new folder/file in root (doc/db.dbml)
3. Run `dbdocs login`
4. Run `dbdocs build doc/db.dbml`
5. Run `dbdocs password --set <password> --project <project_name>` to set the password

### Generating SQL Schema

```
npm install --location=global @dbml/cli
```
1. Run `dbml2sql --postgres -o <path_to_output> <dbml_source_file>`
   1. E.g. `dbml2sql --postgres -o doc/schema.sql doc/dbml`


## GRPC

- Run `brew install protobuf`
- Run `protoc --version`
- Install go plugins from [here](https://grpc.io/docs/languages/go/quickstart/)
- Copy proto3 settings from the plugin documentation in vscode. 
- Go to preferences > settings, search for "proto3", and select "edit in settings.json"
- Run `go mod tidy` to take care of missing packages

### Evans Cli

- Download [here](https://github.com/ktr0731/evans)
- RUn with `evans --host localhost --port <port_number e.g. 9090> -r repl`