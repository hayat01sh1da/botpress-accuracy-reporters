## 1. Environment

- Ruby 4.0.6
- Gemfile 4.0.16
- Bundler 4.0.16

## 2. Install Gems via Gemfile and Bundler

```command
$ bundle install
$ bundle lock --add-checksums
```

## 3. Execution

### 3-1. Export the accuracy score report to Botpress

```command
$ rake export_accuracy_report
--- Successfully exported accuracy score chart under ../csv/ ---
```

### 3-2. Convert the CSV test data to JSON format and export

```command
$ rake convert_test_data
--- Successfully exported JSON training data under ../json/ ---
```

## 4. Unit Test

```command
$ rake
Run options: --seed 32524

# Running:

..

Finished in 0.022878s, 87.4189 runs/s, 87.4189 assertions/s.

2 runs, 2 assertions, 0 failures, 0 errors, 0 skips
```

## 5. Static Code Analysis

```command
$ rubocop
Inspecting 13 files
.............

13 files inspected, no offenses detected
```

## 6. Type Checks

```command
$ rbs-inline --output sig/generated/ .
🎉 Generated 10 RBS files under sig/generated
$ steep check
# Type checking files:

....................

No type error detected. 🧋
```
