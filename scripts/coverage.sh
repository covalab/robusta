#!/bin/bash

# Inspired by Riverpod.

set -e

dart pub global activate coverage

dart test --coverage="coverage"

format_coverage --lcov --in=coverage --out=coverage.lcov --packages=.dart_tool/package_config.json --report-on=lib