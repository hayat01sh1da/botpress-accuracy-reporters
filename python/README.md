## 1. Environment

- Python 3.14.6
- pip 26.1.2

## 2. Install Libraries via requirements.txt

```command
$ pip install -r requirements.txt
```

## 3. Execution

### 3-1. Export the accuracy score report to Botpress

```command
$ invoke export_accuracy_score_report
--- Successfully exported accuracy score chart under ../csv/ ---
```

### 3-2. Convert the CSV test data to JSON format and export

```command
$ invoke format_test_data
--- Successfully exported JSON training data under ../json/ ---
```

## 4. Unit Test

```command
$ invoke
============================= test session starts ==============================
platform linux -- Python 3.14.6, pytest-9.0.3, pluggy-1.6.0
rootdir: botpress-accuracy-reporters/python
configfile: pyproject.toml
collected 2 items

test/lib/test_chart_drawer.py .                                          [ 50%]
test/test_training_data_formatter.py .                                   [100%]

============================== 2 passed in 0.45s ===============================
```

## 5. Static Code Analysis

```command
$ flake8 .
./src/accuracy_reporter.py:24:80: E501 line too long (86 > 79 characters)
./src/queries/accuracy_check_query.py:24:80: E501 line too long (127 > 79 characters)
./test/queries/test_accuracy_check_query.py:19:80: E501 line too long (111 > 79 characters)
./test/test_accuracy_reporter.py:17:80: E501 line too long (101 > 79 characters)
./test/test_accuracy_reporter.py:21:80: E501 line too long (111 > 79 characters)
$ autoflake8 --in-place --remove-duplicate-keys --remove-unused-variables --recursive .
$ autopep8 --in-place --aggressive --aggressive --recursive .
```

## 6. Type Checks

```command
$ mypy .
Success: no issues found in 14 source files
```
