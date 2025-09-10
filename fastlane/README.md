fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build

```sh
[bundle exec] fastlane ios build
```

Build the app

### ios unit_test_only

```sh
[bundle exec] fastlane ios unit_test_only
```

Run unit tests only (without cocoapods)

### ios unit_test

```sh
[bundle exec] fastlane ios unit_test
```

Run unit tests only

### ios ui_test

```sh
[bundle exec] fastlane ios ui_test
```

Run UI tests only

### ios ci

```sh
[bundle exec] fastlane ios ci
```

CI pipeline - build and unit tests only

### ios ci_unit_tests_only

```sh
[bundle exec] fastlane ios ci_unit_tests_only
```

CI pipeline - unit tests only (no build, no UI tests)

### ios github_actions

```sh
[bundle exec] fastlane ios github_actions
```

GitHub Actions - unit tests only (simple and robust)

### ios coverage

```sh
[bundle exec] fastlane ios coverage
```

Run tests with detailed coverage report

### ios clean

```sh
[bundle exec] fastlane ios clean
```

Clean build artifacts

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
