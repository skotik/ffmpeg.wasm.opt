#!/bin/bash
# `-o <OUTPUT_FILE_NAME>` must be provided when using this build script.
# ex:
#     bash ffmpeg-wasm.sh -o ffmpeg.js

set -euo pipefail

PREFIX="$PWD/opt"
INSTALL_DIR="$PWD/opt"
EXPORT_NAME="createFFmpegCore"
CFLAGS="-O3  -msimd128 -I${PREFIX}/include"
LDFLAGS="$CFLAGS -L${PREFIX}/lib -s INITIAL_MEMORY=33554432"


CONF_FLAGS=(
  -I. 
  -I./src/fftools 
  -I$INSTALL_DIR/include 
  -L$INSTALL_DIR/lib 
  -Llibavcodec 
  -Llibavdevice 
  -Llibavfilter 
  -Llibavformat 
  -Llibavutil 
  -Llibpostproc 
  -Llibswresample 
  -Llibswscale 
  -lavcodec 
  -lavdevice 
  -lavfilter 
  -lavformat 
  -lavutil 
  -lpostproc 
  -lswresample 
  -lswscale 
  -Wno-deprecated-declarations 
  $LDFLAGS 
  -sWASM_BIGINT                            # enable big int support
  -sUSE_SDL=2                              # use emscripten SDL2 lib port
  -sMODULARIZE                             # modularized to use as a library
  -sINITIAL_MEMORY=32MB -sALLOW_MEMORY_GROWTH # Use just enough memory as memory usage can grow
  -sEXPORT_NAME="$EXPORT_NAME"             # required in browser env, so that user can access this module from window object
  -sEXPORTED_FUNCTIONS=$(node src/bind/ffmpeg/export.js) # exported functions
  -sEXPORTED_RUNTIME_METHODS=$(node src/bind/ffmpeg/export-runtime.js) # exported built-in functions
  -lworkerfs.js
  --pre-js src/bind/ffmpeg/bind.js        # extra bindings, contains most of the ffmpeg.wasm javascript code
  # ffmpeg source code
  src/fftools/cmdutils.c 
  src/fftools/ffmpeg.c 
  src/fftools/ffmpeg_filter.c 
  src/fftools/ffmpeg_hw.c 
  src/fftools/ffmpeg_mux.c 
  src/fftools/ffmpeg_opt.c 
  src/fftools/opt_common.c 
)

emcc "${CONF_FLAGS[@]}" $@
