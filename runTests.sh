#!/bin/bash

find . -mindepth 2 -maxdepth 2 -name 'runTests.sh' | xargs -I {} -- bash {}

# | grep -F -v './runTest