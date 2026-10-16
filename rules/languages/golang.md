# Go Rules

## 1. Error Handling
1. **Always check errors**: Never discard errors with `_`. Handle or propagate explicitly.
2. **Wrap errors with context**: Use `fmt.Errorf("context: %w", err)` to add context when wrapping.
3. **No panic in library code**: Use `panic` only in `main()` for truly unrecoverable startup failures.

## 2. Code Style
1. **`gofmt` always**: Run `gofmt -w` before every commit.
2. **`go vet` clean**: No `go vet` warnings.
3. **Named return values sparingly**: Only use named returns for documentation clarity in short functions.

## 3. Testing
1. **Table-driven tests**: Use `[]struct{ name, input, expected }` patterns for all unit tests.
2. **Test file naming**: `<file>_test.go` in the same package.
3. **Subtests**: Use `t.Run(tc.name, ...)` for table-driven sub-tests.

## 4. Concurrency
1. **No data races**: Run `go test -race ./...` before committing.
2. **Context propagation**: Pass `context.Context` as the first argument of every function that does I/O.
3. **Structured logging**: Use `log/slog` (stdlib) not `fmt.Println` for application logging.
