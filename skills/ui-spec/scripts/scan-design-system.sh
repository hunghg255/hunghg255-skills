#!/usr/bin/env bash
# scan-design-system.sh — Scans React codebase for design system inventory
# Outputs: component list, design tokens, icon library, style patterns
# Usage: bash "/absolute/path/to/ui-spec/scripts/scan-design-system.sh" [project-root]

set -euo pipefail

# Resolve project root
ROOT="${1:-.}"

# Validate directory
if [ ! -d "$ROOT" ]; then
  echo "ERROR: Directory '$ROOT' does not exist"
  exit 1
fi

echo "========================================="
echo " Design System Scanner"
echo " Project: $ROOT"
echo "========================================="
echo ""

# ── 1. Detect Project Type ─────────────────────────────
echo "## Project Type"

if [ -f "$ROOT/package.json" ]; then
  FRAMEWORK="unknown"
  STYLING="unknown"
  ICON_LIB="unknown"

  # Detect framework
  if grep -q '"react"' "$ROOT/package.json" 2>/dev/null; then FRAMEWORK="react"; fi
  if grep -q '"next"' "$ROOT/package.json" 2>/dev/null; then FRAMEWORK="next.js"; fi
  if grep -q '"vue"' "$ROOT/package.json" 2>/dev/null; then FRAMEWORK="vue"; fi

  # Detect styling
  if grep -q '"tailwindcss"' "$ROOT/package.json" 2>/dev/null; then STYLING="tailwind"; fi
  if grep -q '"styled-components"' "$ROOT/package.json" 2>/dev/null; then STYLING="styled-components"; fi
  if grep -q '"@emotion"' "$ROOT/package.json" 2>/dev/null; then STYLING="emotion"; fi
  if grep -q '"sass"' "$ROOT/package.json" 2>/dev/null; then STYLING="sass"; fi
  if [ -d "$ROOT/src/styles" ] || find "$ROOT/src" -maxdepth 1 -name "*.css" -print -quit 2>/dev/null | grep -q .; then
    STYLING="${STYLING}/css"
  fi

  # Detect icon library
  if grep -q '"lucide-react"' "$ROOT/package.json" 2>/dev/null; then ICON_LIB="lucide-react"; fi
  if grep -q '"@heroicons"' "$ROOT/package.json" 2>/dev/null; then ICON_LIB="@heroicons/react"; fi
  if grep -q '"react-icons"' "$ROOT/package.json" 2>/dev/null; then ICON_LIB="react-icons"; fi
  if grep -q '"phosphor-react"' "$ROOT/package.json" 2>/dev/null; then ICON_LIB="phosphor-react"; fi

  echo "Framework: $FRAMEWORK"
  echo "Styling: $STYLING"
  echo "Icon Library: $ICON_LIB"
else
  echo "No package.json found — scanning file patterns instead"
fi

echo ""

# ── 2. Find Component Directories ──────────────────────
echo "## Component Directories"

COMPONENT_DIRS=$(find "$ROOT/src" -type d \( \
  -name "components" -o \
  -name "ui" -o \
  -name "design-system" -o \
  -name "shared" -o \
  -name "common" -o \
  -name "widgets" -o \
  -name "elements" \
\) 2>/dev/null || true)

if [ -z "$COMPONENT_DIRS" ]; then
  echo "No standard component directories found. Checking src/ root..."
  COMPONENT_DIRS="$ROOT/src"
fi

echo "$COMPONENT_DIRS"
echo ""

# ── 3. List Components ─────────────────────────────────
echo "## Component Inventory"

# Find React component files
COMPONENTS=$(find "$ROOT/src" -type f \( \
  -name "*.tsx" -o \
  -name "*.jsx" \
\) 2>/dev/null | grep -iE "(component|ui|shared|common|widget|element|button|input|card|modal|table|nav|select|dropdown|checkbox|radio|toggle|badge|avatar|tooltip|alert|toast|progress|spinner|tab|accordion|dialog|drawer|sheet|popover|calendar|form|field)" 2>/dev/null || true)

if [ -n "$COMPONENTS" ]; then
  echo "$COMPONENTS" | while read -r file; do
    # Extract component name from file
    BASENAME=$(basename "$file" | sed 's/\.\(tsx\|jsx\)$//')
    # Extract default export or named export
    EXPORT=$(sed -nE \
      's/.*export[[:space:]]+(default[[:space:]]+)?(async[[:space:]]+)?(function|const|class)[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\4/p' \
      "$file" 2>/dev/null | head -1)
    if [ -z "$EXPORT" ]; then
      EXPORT=$(sed -nE \
        's/.*export[[:space:]]+default[[:space:]]+([A-Za-z_][A-Za-z0-9_]*).*/\1/p' \
        "$file" 2>/dev/null | head -1)
    fi
    EXPORT="${EXPORT:-$BASENAME}"
    # Extract import path (relative to src)
    REL_PATH=$(echo "$file" | sed "s|$ROOT/||")
    echo "  - $EXPORT → $REL_PATH"
  done | sort -u
else
  echo "  No components found matching patterns."
  echo "  Listing all .tsx/.jsx files in src/:"
  find "$ROOT/src" -type f \( -name "*.tsx" -o -name "*.jsx" \) 2>/dev/null | head -30 | while read -r file; do
    REL_PATH=$(echo "$file" | sed "s|$ROOT/||")
    echo "  - $REL_PATH"
  done
fi

echo ""

# ── 4. Find Design Tokens ──────────────────────────────
echo "## Design Tokens"

# Color tokens
echo "### Colors"
COLOR_FILES=$(find "$ROOT/src" -type f \( \
  -name "colors*" -o -name "palette*" -o -name "color*" \
\) 2>/dev/null || true)
THEME_FILES=$(find "$ROOT/src" -type f \( \
  -name "theme*" -o -name "tokens*" -o -name "design-tokens*" \
\) 2>/dev/null || true)
TAILWIND_CONFIG=$(find "$ROOT" -maxdepth 1 -name "tailwind.config.*" 2>/dev/null || true)

if [ -n "$COLOR_FILES" ]; then
  echo "  Color files found:"
  echo "$COLOR_FILES" | while read -r f; do echo "    - $(echo $f | sed "s|$ROOT/||")"; done
fi
if [ -n "$THEME_FILES" ]; then
  echo "  Theme files found:"
  echo "$THEME_FILES" | while read -r f; do echo "    - $(echo $f | sed "s|$ROOT/||")"; done
fi
if [ -n "$TAILWIND_CONFIG" ]; then
  echo "  Tailwind config found: $(echo $TAILWIND_CONFIG | sed "s|$ROOT/||")"
fi
if [ -z "$COLOR_FILES" ] && [ -z "$THEME_FILES" ] && [ -z "$TAILWIND_CONFIG" ]; then
  echo "  No color/token files found. Check CSS variables or inline styles."
fi

CSS_FILES=$(find "$ROOT/src" -type f -name "*.css" 2>/dev/null || true)
if [ -n "$CSS_FILES" ]; then
  echo "  CSS custom properties and Tailwind theme values:"
  echo "$CSS_FILES" | while read -r f; do
    MATCHES=$(grep -nE -- '(^|[[:space:]])--[a-zA-Z][a-zA-Z0-9_-]*:' "$f" 2>/dev/null || true)
    if [ -n "$MATCHES" ]; then
      echo "    $(echo "$f" | sed "s|$ROOT/||"):"
      echo "$MATCHES" | head -80 | sed 's/^/      /'
    fi
  done
fi

echo ""

# Spacing tokens
echo "### Spacing"
SPACING_FILES=$(find "$ROOT/src" -type f \( \
  -name "spacing*" -o -name "space*" \
\) 2>/dev/null || true)
if [ -n "$SPACING_FILES" ]; then
  echo "$SPACING_FILES" | while read -r f; do echo "  - $(echo $f | sed "s|$ROOT/||")"; done
else
  echo "  No spacing token files. Likely defined in theme/tailwind config."
fi

echo ""

# Typography tokens
echo "### Typography"
TYPO_FILES=$(find "$ROOT/src" -type f \( \
  -name "typography*" -o -name "fonts*" -o -name "text*" \
\) 2>/dev/null | grep -iv "test" || true)
if [ -n "$TYPO_FILES" ]; then
  echo "$TYPO_FILES" | while read -r f; do echo "  - $(echo $f | sed "s|$ROOT/||")"; done
else
  echo "  No typography token files. Likely defined in theme/tailwind config."
fi

if [ -n "${CSS_FILES:-}" ]; then
  echo "  Font declarations:"
  grep -rhE "font-family:|--font-" $CSS_FILES 2>/dev/null | sort -u | head -30 || true
fi

echo ""

# ── 5. Find Icons ──────────────────────────────────────
echo "## Icon Inventory"

ICON_DIRS=$(find "$ROOT/src" -type d -name "icons" 2>/dev/null || true)
ICON_FILES=$(find "$ROOT/src" -type f \( \
  -name "*Icon*" -o -name "*icon*" \
\) -name "*.tsx" 2>/dev/null | head -20 || true)

if [ -n "$ICON_DIRS" ]; then
  echo "  Icon directories:"
  echo "$ICON_DIRS" | while read -r d; do echo "    - $(echo $d | sed "s|$ROOT/||")/"; done
fi
if [ -n "$ICON_FILES" ]; then
  echo "  Icon component files (sample):"
  echo "$ICON_FILES" | while read -r f; do echo "    - $(echo $f | sed "s|$ROOT/||")"; done
fi

# Check for icon library usage in imports
echo "  Icon library imports in codebase:"
ICON_IMPORTS=$(grep -r "from 'lucide-react'\|from '@heroicons'\|from 'react-icons'\|from 'phosphor-react'" "$ROOT/src" --include="*.tsx" --include="*.jsx" -l 2>/dev/null | head -5 || true)
if [ -n "$ICON_IMPORTS" ]; then
  echo "$ICON_IMPORTS" | while read -r f; do echo "    - $(echo $f | sed "s|$ROOT/||")"; done
  # Sample which icons are used
  echo "  Sample icon imports:"
  grep -rh "from 'lucide-react'\|from '@heroicons\|from 'react-icons\|from 'phosphor-react'" "$ROOT/src" --include="*.tsx" --include="*.jsx" 2>/dev/null | head -10
else
  echo "    No icon library imports found."
fi

echo ""

# ── 6. Folder Structure ────────────────────────────────
echo "## Source Folder Structure (top-level)"

if command -v tree &>/dev/null; then
  tree -L 3 -d "$ROOT/src" 2>/dev/null | head -40 || ls -R "$ROOT/src" 2>/dev/null | head -40
else
  find "$ROOT/src" -type d -maxdepth 3 2>/dev/null | head -40 | while read -r d; do
    echo "  $(echo $d | sed "s|$ROOT/||")/"
  done
fi

echo ""
echo "========================================="
echo " Scan complete."
echo "========================================="
