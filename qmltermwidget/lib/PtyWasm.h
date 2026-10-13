/*
 * PtyWasm.h
 *
 * WebAssembly drop-in replacement for Pty (the Unix teletype layer).
 *
 * The browser has no forkpty(), no real ttys and no child processes.
 * This class keeps the exact interface Session.cpp uses, so the
 * terminal emulator core (Session, Emulation, TerminalDisplay, Screen,
 * ...) compiles completely unmodified: same signals, same slots, same
 * call sites. The only difference is where the bytes go:
 *
 *   sendData()            -> JS bridge  (window.crtTermReadOut / bytes)
 *   crt_wasm_in() (JS)    -> receivedData signal
 *
 * Nothing else changes. Visual code is untouched.
 */
#ifndef PTYWASM_H
#define PTYWASM_H

#include <QObject>
#include "QProcessWasm.h"
#include <QSize>

class Pty : public QObject
{
    Q_OBJECT
public:
    explicit Pty(QObject* parent = nullptr);
    ~Pty() override;

    // Minimal stub matching the pty()->slaveFd() usage in Session.cpp.
    class FdStub { public: int slaveFd() const { return -1; } };

    FdStub* pty() const { return &_fdStub; }

    QProcess::ProcessState state() const { return QProcess::Running; }
    QProcess::ExitStatus exitStatus() const { return QProcess::NormalExit; }
    int processId() const { return -1; }
    int foregroundProcessGroup() const { return -1; }

    int start(const QString& program,
              const QStringList& arguments,
              const QStringList& environment,
              qint64 winid,
              bool utmp = false);

    void setWorkingDirectory(const QString& dir);
    void setFlowControlEnabled(bool enabled);
    void setErase(char erase);
    void setWriteable(bool writeable);
    void setUtf8Mode(bool on);
    void setWindowSize(int lines, int cols);
    QSize windowSize() const;
    void setEmptyPTYProperties();
    bool waitForFinished(int msecs);
    void closePty();

public slots:
    void sendData(const char* data, int len);
    void lockPty(bool lock);

signals:
    void receivedData(const char* data, int len);
    void finished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    FdStub _fdStub;
};

// C ABI into the wasm module, called from JavaScript.
// data: pointer into linear memory (HEAPU8), len: byte count.
extern "C" void crt_wasm_in(const char* data, int len);

#endif // PTYWASM_H
