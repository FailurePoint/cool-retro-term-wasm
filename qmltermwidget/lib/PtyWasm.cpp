/*
 * PtyWasm.cpp — WebAssembly pipe bridge for the tty-free Session.
 */
#include "PtyWasm.h"

#include <emscripten.h>

// The single live terminal pipe. Sessions are one-per-window here.
static Pty* activePipe = nullptr;

// Bytes flowing out of the terminal (screen output, escape sequences
// and all) are handed to JavaScript exactly as the real Pty hands
// them to the file descriptor. Nothing is reformatted or filtered.
EM_JS(void, crt_wasm_out, (const char* data, int len), {
    if (typeof globalThis.crtTermReadOut === 'function') {
        globalThis.crtTermReadOut(new Uint8Array(HEAPU8.buffer, data, len).slice());
    }
});

Pty::Pty(QObject* parent) : QObject(parent)
{
    activePipe = this;
}

Pty::~Pty()
{
    if (activePipe == this) activePipe = nullptr;
}

int Pty::start(const QString&, const QStringList&, const QStringList&, qint64, bool)
{
    // No process to launch: the host (JavaScript) owns the "program".
    return 0;
}

void Pty::setWorkingDirectory(const QString&) {}
void Pty::setFlowControlEnabled(bool) {}
void Pty::setErase(char) {}
void Pty::setWriteable(bool) {}
void Pty::setUtf8Mode(bool) {}
void Pty::setWindowSize(int, int) {}
QSize Pty::windowSize() const { return QSize(); }
void Pty::setEmptyPTYProperties() {}
bool Pty::waitForFinished(int) { return true; }
void Pty::closePty() {}

void Pty::sendData(const char* data, int len)
{
    if (len > 0) crt_wasm_out(data, len);
}

void Pty::lockPty(bool) {}

extern "C" void crt_wasm_in(const char* data, int len)
{
    if (activePipe && len > 0)
        emit activePipe->receivedData(data, len);
}
