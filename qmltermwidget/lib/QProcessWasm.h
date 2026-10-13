/*
 * QProcessWasm.h
 *
 * Qt for WebAssembly ships no QProcess implementation. The terminal core
 * only needs its enum names (Session uses QProcess::ExitStatus in a slot
 * signature). Enum-only drop-in so all other files compile untouched.
 */
#ifndef QPROCESS_WASM_H
#define QPROCESS_WASM_H

class QProcess {
public:
    enum ProcessState { NotRunning, Starting, Running };
    enum ExitStatus { NormalExit, CrashExit };
    enum ProcessChannel { StandardOutput, StandardError };
};

#endif
