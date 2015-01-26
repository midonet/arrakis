#!/bin/bash
check_status() {
    if [ $? -ne 0 ]; then
        exit 1;
    fi
}

set -x

# Run the test for each module
for i in modules/* ; do
  if [ -d "$i" ]; then
    cd $i
    echo "Installing dependences for: $i"
    bundle install
    check_status
    echo "Validating: $i"
    rake validate
    check_status
    echo "Running puppet-lint for code convention errors for $i"
    rake lint
    echo "Running kitchen test suite for: $i"
    kitchen test
    check_status
    cd -
  fi
done

set +x
