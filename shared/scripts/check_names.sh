#!/usr/bin/env bash
set -Eeuo pipefail

# Enforce snake_case for directories and files (except common root/system files).
# Allowed exceptions: dotfiles, system folders, and well-known uppercase files.
is_exception() {
  case "$1" in
    .|./.|*/.|*/..|*/.git|*/.git/*|*/.gitignore_global|*/.venv/*|*/node_modules/*) return 0 ;;
    */.gitignore|*/.editorconfig|*/pre-commit|*/.pre-commit-config.yaml|./.pre-commit-hooks.yaml) return 0 ;;
    */README.md|*/LICENSE|*/CHANGELOG.md|*/CODEOWNERS) return 0 ;;
    *) return 1 ;;
  esac
}

snake='^[a-z0-9_]+$'
fail=0

# === only search within src/ ===
search_dir="src"

if [[ ! -d "$search_dir" ]]; then
  echo "⚠️  Directory '$search_dir' not found. Skipping snake_case check."
  exit 0
fi

# Directories
while IFS= read -r -d '' d; do
  base="$(basename "$d")"
  is_exception "$d" && continue
  [[ "$base" =~ $snake ]] || { echo "❌ Folder not snake_case: $d"; fail=1; }
done < <(find "$search_dir" -type d -print0)

# Files
while IFS= read -r -d '' f; do
  base="$(basename "$f")"
  is_exception "$f" && continue
  name="${base%.*}"  # strip extension
  [[ "$name" =~ $snake ]] || { echo "❌ File not snake_case (basename): $f"; fail=1; }
done < <(find "$search_dir" -type f -print0)

exit $fail
