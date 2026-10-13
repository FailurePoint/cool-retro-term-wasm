#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WASM_QMAKE="${QMAKE_WASM:-$QT_ROOT_DIR/bin/qmake}"

cd "$ROOT"
mkdir -p build-wasm && cd build-wasm

"$WASM_QMAKE" ../cool-retro-term.pro CONFIG+=wasm CONFIG+=wasm
# Qt's wasm mkspec appends INITIAL_MEMORY=50MB after any user flag; patch the
# generated Makefiles so 128 MB wins (the app needs ~53 MB static).
sed -i 's/INITIAL_MEMORY=50MB/INITIAL_MEMORY=134217728/g' Makefile* ../qmltermwidget/Makefile* ../app/Makefile* 2>/dev/null || true

make -j2

OUT="$ROOT/build-wasm/deploy"
mkdir -p "$OUT"
cp cool-retro-term.js cool-retro-term.wasm cool-retro-term.worker.js cool-retro-term.js.metadata "$OUT" 2>/dev/null || true
cp -r "$ROOT/wasm"/* "$OUT"
find "$OUT" -type f | sort
