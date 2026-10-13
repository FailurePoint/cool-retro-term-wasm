#!/usr/bin/env bash
# Build cool-retro-term for WebAssembly with the tty-free pipe bridge.
#
# Requires:
#   * Emscripten SDK  >= 3.1.40   (source emsdk_env.sh first)
#   * Qt 6 for WebAssembly            (qtbase6-wasm + qtshadertools6-wasm,
#                                      e.g. via the Qt online installer)
#   * Host Qt6 (provides qsb, the shader baker) and qmake for wasm
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Emscripten environment must already be active.
command -v emcc >/dev/null || { echo "source emsdk_env.sh first"; exit 1; }

cd "$ROOT"
mkdir -p build-wasm && cd build-wasm

# qmake with the wasm mkspec; use the wasm-target's qmake.
"${QMAKE_WASM:-qmake-wasm}" ../cool-retro-term.pro CONFIG+=wasm
make -j"$(nproc)"

OUT="$ROOT/build-wasm/deploy"
mkdir -p "$OUT"
cp cool-retro-term.js cool-retro-term.wasm cool-retro-term.html "$OUT/" 2>/dev/null || true
cp -r "$ROOT/wasm/index.html" "$OUT/" 2>/dev/null || true
cp -r "$ROOT/app/qml/fonts" "$OUT/fonts" 2>/dev/null || true
cp -r "$ROOT/app/qml/images" "$OUT/images" 2>/dev/null || true
cp -r "$ROOT/app/icons" "$OUT/icons" 2>/dev/null || true

echo "Deployed to: $OUT"
echo "Serve with:  python3 -m http.server -d $OUT 8000   (must be same-origin)"
