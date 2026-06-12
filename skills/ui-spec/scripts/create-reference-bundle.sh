#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -lt 2 ]; then
  echo "Usage: bash /absolute/path/to/create-reference-bundle.sh <source-image> <output-dir> [name:x:y:width:height ...]"
  exit 1
fi

SOURCE="$1"
OUTPUT_DIR="$2"
shift 2

if [ ! -f "$SOURCE" ]; then
  echo "ERROR: Source image does not exist: $SOURCE"
  exit 1
fi

if ! command -v sips >/dev/null 2>&1; then
  echo "ERROR: This script currently requires macOS sips"
  exit 1
fi

mkdir -p "$OUTPUT_DIR"

EXTENSION="${SOURCE##*.}"
REFERENCE="$OUTPUT_DIR/reference.$EXTENSION"
cp "$SOURCE" "$REFERENCE"

MANIFEST="$OUTPUT_DIR/manifest.tsv"
printf "asset\tpath\tx\ty\twidth\theight\tsha256\n" >"$MANIFEST"

SOURCE_WIDTH=$(sips -g pixelWidth "$SOURCE" | awk '/pixelWidth/ { print $2 }')
SOURCE_HEIGHT=$(sips -g pixelHeight "$SOURCE" | awk '/pixelHeight/ { print $2 }')
REFERENCE_HASH=$(shasum -a 256 "$REFERENCE" | awk '{ print $1 }')
printf "reference\treference.%s\t0\t0\t%s\t%s\t%s\n" \
  "$EXTENSION" "$SOURCE_WIDTH" "$SOURCE_HEIGHT" "$REFERENCE_HASH" >>"$MANIFEST"

for CROP in "$@"; do
  IFS=: read -r NAME X Y WIDTH HEIGHT <<<"$CROP"

  if [ -z "$NAME" ] || [ -z "$X" ] || [ -z "$Y" ] || [ -z "$WIDTH" ] || [ -z "$HEIGHT" ]; then
    echo "ERROR: Invalid crop '$CROP'. Expected name:x:y:width:height"
    exit 1
  fi

  TARGET="$OUTPUT_DIR/$NAME.$EXTENSION"
  cp "$SOURCE" "$TARGET"
  sips --cropToHeightWidth "$HEIGHT" "$WIDTH" --cropOffset "$Y" "$X" "$TARGET" >/dev/null

  HASH=$(shasum -a 256 "$TARGET" | awk '{ print $1 }')
  printf "%s\t%s.%s\t%s\t%s\t%s\t%s\t%s\n" \
    "$NAME" "$NAME" "$EXTENSION" "$X" "$Y" "$WIDTH" "$HEIGHT" "$HASH" >>"$MANIFEST"
done

echo "Reference bundle created: $OUTPUT_DIR"
