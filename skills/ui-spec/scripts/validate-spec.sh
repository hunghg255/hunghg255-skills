#!/usr/bin/env bash

set -euo pipefail

SPEC="${1:-}"

if [ -z "$SPEC" ] || [ ! -f "$SPEC" ]; then
  echo "Usage: bash /absolute/path/to/validate-spec.sh <spec-path>"
  exit 1
fi

required_sections=(
  "## Implementation Contract"
  "## Reference Calibration"
  "## Page Context"
  "## Component Tree"
  "## Layout Structure"
  "## Visual Measurement Ledger"
  "## Reference Asset Manifest"
  "## Visual Acceptance Criteria"
)

failed=0

for section in "${required_sections[@]}"; do
  if ! grep -Fq "$section" "$SPEC"; then
    echo "MISSING: $section"
    failed=1
  fi
done

if ! grep -Eq "Intrinsic image size|Intrinsic image" "$SPEC"; then
  echo "MISSING: intrinsic image dimensions"
  failed=1
fi

if ! grep -Eq "Scale factor|scale factor" "$SPEC"; then
  echo "MISSING: scale factor"
  failed=1
fi

if ! grep -Eq "Screenshot-calibrated|Figma-exact" "$SPEC"; then
  echo "MISSING: fidelity tier"
  failed=1
fi

contract_blocks=(
  "### Fidelity Target"
  "### File Operations"
  "### DOM Contract"
  "### Style Contract"
  "### Content Fixture"
  "### State Contract"
  "### Prohibited Deviations"
  "### Verification"
)

for block in "${contract_blocks[@]}"; do
  if ! grep -Fq "$block" "$SPEC"; then
    echo "MISSING: $block"
    failed=1
  fi
done

contract=$(awk '
  /^## Implementation Contract$/ { in_contract=1; next }
  /^## / && in_contract { exit }
  in_contract { print }
' "$SPEC")

if printf '%s\n' "$contract" |
  grep -Eiq "\b(probably|likely|about|approximately|roughly|maybe|perhaps|may|should|if possible|fallback|closest)\b"; then
  echo "INVALID: Implementation Contract contains ambiguous or alternative language"
  failed=1
fi

if printf '%s\n' "$contract" |
  grep -Eq "[0-9]+[[:space:]]*-[[:space:]]*[0-9]+[[:space:]]*(px|rem|%)|[0-9]+[[:space:]]+to[[:space:]]+[0-9]+[[:space:]]*(px|rem|%)"; then
  echo "INVALID: Implementation Contract contains a numeric range"
  failed=1
fi

contract_line=$(grep -n -m1 "^## Implementation Contract$" "$SPEC" | cut -d: -f1 || true)
calibration_line=$(grep -n -m1 "^## Reference Calibration$" "$SPEC" | cut -d: -f1 || true)
if [ -n "$contract_line" ] && [ -n "$calibration_line" ] && [ "$contract_line" -gt "$calibration_line" ]; then
  echo "INVALID: Implementation Contract must precede Reference Calibration"
  failed=1
fi

if printf '%s\n' "$contract" | grep -Eq "\[[^]]*(exact|width|height|element|component|state|path)[^]]*\]"; then
  echo "INVALID: Implementation Contract contains template placeholders"
  failed=1
fi

if ! printf '%s\n' "$contract" | grep -Eq "MODIFY|CREATE"; then
  echo "MISSING: concrete file operation"
  failed=1
fi

if ! printf '%s\n' "$contract" | grep -Eiq "DPR|device pixel ratio"; then
  echo "MISSING: DPR in Implementation Contract"
  failed=1
fi

if grep -Eq "/tmp/|/private/tmp/" "$SPEC"; then
  echo "INVALID: spec references temporary assets"
  failed=1
fi

if ! grep -Eq "specs/assets/[A-Za-z0-9._/-]+/manifest\.tsv" "$SPEC"; then
  echo "MISSING: persistent reference manifest path"
  failed=1
fi

while IFS= read -r asset_path; do
  if [ ! -e "$asset_path" ]; then
    echo "MISSING ASSET: $asset_path"
    failed=1
  fi
done < <(grep -oE "specs/assets/[A-Za-z0-9._/-]+" "$SPEC" | sort -u)

if grep -Eq "\[(PAGE_NAME|DATE|IMAGE_PATH|PROJECT_NAME|value|element|component|spec-name)\]" "$SPEC"; then
  echo "INVALID: unresolved template placeholders"
  failed=1
fi

if grep -Eq "\b(probably|likely)\b" "$SPEC"; then
  echo "INVALID: unresolved uncertainty uses probably/likely"
  failed=1
fi

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "UI spec structure validated: $SPEC"
