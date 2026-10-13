TEMPLATE = subdirs

CONFIG += ordered

SUBDIRS += qmltermwidget
wasm {
    include(wasm/wasm.pri)
}
SUBDIRS += app

desktop.files += cool-retro-term.desktop
desktop.path += /usr/share/applications

INSTALLS += desktop
