#!/bin/bash
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
WASM_QMAKE="${QMAKE_WASM:-$QT_ROOT_DIR/bin/qmake}"

cd "$ROOT"
mkdir -p build-wasm && cd build-wasm

# qmake with the wasm target's qmake.
"$WASM_QMAKE" ../cool-retro-term.pro CONFIG+=wasm CONFIG+=wasm 'QMAKE_LFLAGS+="-s INITIAL_MEMORY=134217728"'
make -j"$(nproc)"

OUT="$ROOT/build-wasm/deploy"
mkdir -p "$OUT"
cp cool-retro-term.js cool-retro-term.wasm cool-retro-term.worker.js cool-retro-term.js.metadata "$OUT" 2>/dev/null || true
cp -r "$ROOT/wasm"/* "$OUT"
find "$OUT" -type f | sort
