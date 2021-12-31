#!/bin/sh

# Copyright 2021 Yury Gribov
# 
# Use of this source code is governed by MIT license that can be
# found in the LICENSE.txt file.

set -eu

if test -n "${TRAVIS:-}" -o -n "${GITHUB_ACTIONS:-}"; then
  set -x
fi

cd $(dirname $0)/..

make "$@" clean all
make "$@" test

# Upload coverage
if test -n "${CODECOV_TOKEN:-}"; then
  curl --retry 5 -s https://codecov.io/bash > codecov.bash
  bash codecov.bash -X gcov -Z
  find -name \*.gcda -o -name \*.gcno -o -name \*.gcov | xargs rm
fi