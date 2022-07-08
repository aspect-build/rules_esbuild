#!/usr/bin/env bash

set -uo pipefail;

while [ "$#" -ne 0 ]; do
  [[ "lib_metadata.json" == "$(basename $1)" ]] && exit 0;
  shift;
done

echo "Expected lib_metadata.json to be produced" >&2
exit 1
