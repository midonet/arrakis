#!/bin/bash

# Run the test for each module
for i in modules/* ; do
  if [ -d "$i" ]; then
    cd $i
    echo "Installing dependences for: $i"
    bundle install
    echo "Validating: $i"
    rake validate
    echo "Running puppet-lint for code convention errors for $i"
    rake lint
    echo "Running kitchen test suite for: $i"
    kitchen test --concurrency=5
    cd -
  fi
done
