#!/bin/sh
PREFIX="$PWD/opt"
MAKEFLAGS="-j4"
CFLAGS="-O3  -msimd128 -I${PREFIX}/include"
LDFLAGS="$CFLAGS -L${PREFIX}/lib -s INITIAL_MEMORY=33554432"
#echo $LDFLAGS
#  --disable-everything \
#  --disable-network \
#  --enable-ffmpeg \

emmake make clean
emconfigure ./configure \
  --prefix=${PREFIX} \
  --target-os=none \
  --arch=x86_32 \
  --enable-cross-compile \
  --disable-everything \
  --disable-network \
  --disable-programs \
  --disable-debug \
  --disable-asm \
  --disable-x86asm \
  --disable-inline-asm \
  --disable-stripping \
  --disable-doc \
  --disable-autodetect \
  --disable-runtime-cpudetect \
  --disable-pthreads \
  --disable-w32threads \
  --disable-os2threads \
  --enable-gpl \
  --enable-protocol=file,pipe \
  --enable-demuxer=avi,h264  \
  --enable-muxer=mp4,h264 \
  --enable-parser=h264 \
  --enable-bsf=dts2pts \
  --extra-cflags="$CFLAGS" \
  --extra-cxxflags="$CFLAGS" \
  --extra-ldflags="$LDFLAGS" \
  --nm=emnm \
  --ar=emar \
  --as=false \
  --ranlib=emranlib \
  --cc=emcc \
  --cxx=em++ \
  --objcc=emcc \
  --dep-cc=emcc

emmake make -j 4