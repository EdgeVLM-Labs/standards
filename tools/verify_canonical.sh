#!/usr/bin/env bash
set -Eeuo pipefail

# ==============================================================
#  verify_canonical.sh
# --------------------------------------------------------------
#  Compare local configuration files against canonical versions
#  in the standards repository and report any drift.
#
#  Usage:
#    bash <(curl -sSL https://raw.githubusercontent.com/<your-org>/standards/main/tools/verify_canonical.sh) v1.0.0
#
#  Example (CI check):
#    bash <(curl -sSL https://raw.githubusercontent.com/agentic-ai/standards/main/tools/verify_canonical.sh) main
#
#  Exit codes:
#    0  -> All files match the canonical standards
#    1  -> Differences found
# ==============================================================

ORG="EdgeVLM-Labs"
REF="${1:-main}"
FAIL=0

echo "🔍 Verifying local configs against $ORG@$REF ..."

compare_file() {
  local remote_path="$1"
  local local_path="$2"

  tmpfile=$(mktemp)
  curl -sSL "https://raw.githubusercontent.com/$ORG/standards/$REF/$remote_path" -o "$tmpfile"

  if ! diff -q "$tmpfile" "$local_path" >/dev/null 2>&1; then
    echo "❌ Drift detected: $local_path differs from $remote_path"
    FAIL=1
  else
    echo "✅ $local_path matches canonical version"
  fi

  rm -f "$tmpfile"
}

# --- Compare root configs ---
compare_file "shared/.editorconfig" ".editorconfig"
compare_file "shared/.gitignore_global" ".gitignore"
compare_file "shared/pre-commit/.pre-commit-config.yaml" ".pre-commit-config.yaml"

# --- Compare shared scripts ---
compare_file "shared/scripts/init_env.sh" "scripts/init_env.sh"
compare_file "shared/scripts/check_names.sh" "scripts/check_names.sh"

if [[ "$FAIL" -eq 0 ]]; then
  echo "🎯 All configuration files match canonical standards."
else
  echo "⚠️  Some files are out of sync with $ORG@$REF."
  echo "    Run the sync script to update them:"
  echo "    bash <(curl -sSL https://raw.githubusercontent.com/$ORG/standards/main/tools/sync_from_standards.sh) $REF"
  exit 1
fi
