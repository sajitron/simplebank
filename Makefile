DB_URL=postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable

network:
	docker network create bank-network

postgres:
	docker run --name postgres12 --network bank-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

startpg:
	docker start postgres12

stoppg:
	docker stop postgres12

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

dbdocs:
	dbdocs build doc/db.dbml

dbschema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover -short ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/sajitron/simplebank/db/sqlc Store

buildimage:
	docker build -t simplebank:latest .

runcontainer:
	docker run --name simplebank -p 8080:8080 -e GIN_MODE=release -e DB_SOURCE="postgresql://root:secret@postgres12:5432/simple_bank?sslmode=disable" simplebank:latest

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=simple_bank \
	proto/*.proto
	statik -src=./doc/swagger -dest=./doc

evans:
	evans --host localhost --port 9090 -r repl

redis:
	docker run --name redis -p 6379:6379 -d redis:7-alpine

.PHONY: network postgres createdb dropdb migrateup migratedown sqlc test server mock startpg stoppg migrateup1 migratedown1 new_migration buildimage runcontainer dbdocs dbschema proto evans redis