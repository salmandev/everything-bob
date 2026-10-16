# Test-Driven Development Rules

## 1. Test First, Always
1. **No production code without a failing test**: The Red phase is mandatory. Write the test, see it fail, then write code.
2. **One test at a time**: Focus on making one failing test pass before writing the next.
3. **Tests are specifications**: The test suite is the specification. If behavior is undocumented in tests, it is undefined behavior.

## 2. Test Quality
1. **One assertion per test**: Each test should verify one behavior. Multiple assertions are a sign the test should be split.
2. **Test names are sentences**: `it("returns 401 when user is not authenticated")` not `test1`.
3. **No test logic**: Tests should be simple. If the test has complex branching, the design is wrong.

## 3. Refactoring Discipline
1. **All tests green before refactoring**: Never refactor with a failing test. Green → Refactor.
2. **Refactor in small steps**: One rename, one extraction, one simplification — then run tests.
3. **Coverage is a floor**: Test coverage must not decrease from the baseline on any PR.
