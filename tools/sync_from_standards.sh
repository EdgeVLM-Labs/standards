#!/usr/bin/env bash
set -Eeuo pipefail

# ==============================================================
#  sync_from_standards.sh
# --------------------------------------------------------------
#  Pull canonical org-wide configuration files from the
#  standards repository into the current repository.
#
#  Usage:
#    bash <(curl -sSL https://raw.githubusercontent.com/<your-org>/standards/main/tools/sync_from_standards.sh) v1.0.0
#
#  Example:
#    bash <(curl -sSL https://raw.githubusercontent.com/agentic-ai/standards/main/tools/sync_from_standards.sh) main
#
#  Notes:
#   - You can specify a tag or branch as the version argument (default: main)
#   - Safe to re-run; overwrites existing configs
# ==============================================================

ORG="EdgeVLM-Labs"
REF="main"
BASE_URL="https://raw.githubusercontent.com/${ORG}/standards/${REF}"

echo "🔄 Syncing standards from $ORG@$REF ..."
echo "   -> $BASE_URL"

mkdir -p .github/workflows

# --- Shared root configs ---
curl -sSL "${BASE_URL}/shared/.editorconfig" \
  -o .editorconfig
curl -sSL "${BASE_URL}/shared/.gitignore_global" \
  -o .gitignore
curl -sSL "${BASE_URL}/shared/pre-commit/.pre-commit-config.yaml" \
  -o .pre-commit-config.yaml
curl -sSL "${BASE_URL}/shared/pyproject.toml" \
  -o pyproject.toml
curl -sSL "${BASE_URL}/shared/workflows/ci.yml" \
  -o .github/workflows/ci.yml

echo "✅ Standards synced successfully from $ORG@$REF"


# command:
# bash <(curl -sSL https://raw.githubusercontent.com/EdgeVLM-Labs/standards/main/tools/sync_from_standards.sh) v1.0.0
