#!/usr/bin/env bash
set -Eeuo pipefail
if [[ -f ".env" ]]; then
  # shellcheck disable=SC2046
  export $(grep -v '^\s*#' .env | xargs -d '\n')
fi
echo "Environment loaded."
