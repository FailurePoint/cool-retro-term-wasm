#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WASM_QMAKE="${QMAKE_WASM:-$QT_ROOT_DIR/bin/qmake}"

cd "$ROOT"
# Qt's wasm mkspec hardcodes INITIAL_MEMORY=50MB, less than this app's ~53 MB
# of static data. Patch the mkspec itself so every generated Makefile inherits it.
grep -rln 'INITIAL_MEMORY' "$QT_ROOT_DIR/mkspecs/" 2>/dev/null | while read f; do
  echo "found in: $f"; grep -n 'INITIAL_MEMORY' "$f"
  sed -i 's/INITIAL_MEMORY[[:space:]]*=[[:space:]]*50MB/INITIAL_MEMORY=134217728/g; s/INITIAL_MEMORY=50MB/INITIAL_MEMORY=134217728/g' "$f"
  echo "patched: $f"
done

mkdir -p build-wasm && cd build-wasm

"$WASM_QMAKE" ../cool-retro-term.pro CONFIG+=wasm CONFIG+=wasm
make -j2

OUT="$ROOT/build-wasm/deploy"
mkdir -p "$OUT"
cp cool-retro-term.js cool-retro-term.wasm cool-retro-term.worker.js cool-retro-term.js.metadata "$OUT" 2>/dev/null || true
cp -r "$ROOT/wasm"/* "$OUT"
find "$OUT" -type f | sort
