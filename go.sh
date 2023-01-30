#!/bin/bash

set -euxo pipefail

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

cat my.subs | base64 -d | jq -f sub.jq -r > my.csv
