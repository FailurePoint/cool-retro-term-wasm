# wasm link configuration: embind for the JS bridge, generous memory.
LIBS += -lembind
QMAKE_LFLAGS += "-s INITIAL_MEMORY=134217728 -s ALLOW_MEMORY_GROWTH=1"
