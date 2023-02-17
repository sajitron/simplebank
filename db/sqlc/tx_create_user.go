package db

import "context"

// CreateUserTxParams contains the input parameters of the transfer transaction
type CreateUserTxParams struct {
	CreateUserParams
	// function below will be called after a user has been created
	// the error being returned determines the success of the action
	// i.e. whether to commit or roll back the transaction
	AfterCreate func(user Users) error
}

// CreateUserTxResult is the result of the transfer transaction
type CreateUserTxResult struct {
	User Users
}

// CreateUserTx performs a money transfer from one account to the other
// It creates the transfer, adds account entries, and updates accounts' balance within a database transaction
func (store *SQLStore) CreateUserTx(ctx context.Context, arg CreateUserTxParams) (CreateUserTxResult, error) {
	var result CreateUserTxResult

	err := store.execTx(ctx, func(q *Queries) error {
		var err error

		result.User, err = q.CreateUser(ctx, arg.CreateUserParams)
		if err != nil {
			return err
		}
		return arg.AfterCreate(result.User)
	})

	return result, err
}
