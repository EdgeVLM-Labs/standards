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
REF="${1:-main}"
BASE_URL="https://raw.githubusercontent.com/${ORG}/standards/${REF}"

echo "🔄 Syncing standards from $ORG@$REF ..."

# --- Shared root configs ---
curl -sSL "${BASE_URL}/shared/.editorconfig" \
  -o .editorconfig
curl -sSL "${BASE_URL}/shared/.gitignore_global" \
  -o .gitignore
curl -sSL "${BASE_URL}/shared/pre-commit/.pre-commit-config.yaml" \
  -o .pre-commit-config.yaml

# --- Shared scripts ---
mkdir -p scripts
curl -sSL "${BASE_URL}/shared/scripts/init_env.sh" \
  -o scripts/init_env.sh
curl -sSL "${BASE_URL}/shared/scripts/check_names.sh" \
  -o scripts/check_names.sh
chmod +x scripts/*.sh

echo "✅ Standards synced successfully from $ORG@$REF"
