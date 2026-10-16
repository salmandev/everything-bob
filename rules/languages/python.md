# Python Rules

## 1. Type Annotations
1. **All functions annotated**: Every function must have parameter and return type annotations.
2. **Python 3.12+**: Target Python 3.12 or later. Use `|` union syntax, not `Optional[]`.
3. **No `Any` without justification**: Avoid `typing.Any`. Use `object` or a Union type instead.

## 2. Data Modeling
1. **Pydantic v2 for data models**: Use `pydantic.BaseModel` for all data structures that cross boundaries.
2. **Dataclasses for pure data**: Use `@dataclass` for simple data containers without validation.

## 3. Code Quality
1. **Ruff for formatting and linting**: Run `ruff format` and `ruff check` before committing.
2. **No bare `except`**: Always catch specific exceptions: `except ValueError:`, not `except:`.
3. **Explicit over implicit**: No magic `__init__` side effects. No module-level code with side effects.

## 4. Testing
1. **pytest**: All tests use pytest with `conftest.py` for fixtures.
2. **Test file naming**: `test_<module>.py` in a `tests/` directory.

## 5. Dependencies
1. **Pin versions in `pyproject.toml`**: Use `~=` for minor version pins in production.
2. **Virtual environments**: Always work in a virtual environment. Never install globally.
