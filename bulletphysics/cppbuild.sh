#!/bin/bash
# This file is meant to be included by the parent cppbuild.sh script
if [[ -z "$PLATFORM" ]]; then
    pushd ..
    bash cppbuild.sh "$@" bulletphysics
    popd
    exit
fi

BULLET_VERSION=2.83.7
download https://github.com/bulletphysics/bullet3/archive/$BULLET_VERSION.tar.gz bullet3-$BULLET_VERSION.tar.gz

mkdir -p $PLATFORM
cd $PLATFORM
tar -xzvf ../bullet3-$BULLET_VERSION.tar.gz
cd bullet3-$BULLET_VERSION

case $PLATFORM in
    cygwin-x86_64)
        cmake . -G "Unix Makefiles" \
          -B"$(pwd)/../build-win64/" \
          -DCMAKE_TOOLCHAIN_FILE=../../../mingw-w64-toolchain.cmake \
          -DBUILD_SHARED_LIBS=ON \
          -DBUILD_EXTRAS=OFF -DBUILD_BULLET3=OFF \
          -DCMAKE_BUILD_TYPE=Release 
        cd ../build-win64/
        make -j4
        ;;
    linux-x86_64)
        cmake . -G "Unix Makefiles" \
          -B"$(pwd)/../build-linux64/" \
          -DEXECUTABLE_OUTPUT_PATH="$(pwd)/../build-linux64/bin" -DLIBRARY_OUTPUT_PATH="$(pwd)/../lib/linux-x86_64/" \
          -DBUILD_SHARED_LIBS=on \
          -DBUILD_EXTRAS=OFF -DBUILD_BULLET3=OFF \
          -DCMAKE_BUILD_TYPE=Release 
        cd ../build-linux64/
        make -j4
        ;;
    macosx*)
        cmake . -G "Unix Makefiles" \
          -B"$(pwd)/../build-ios/" 
          -DFRAMEWORK=ON -DCMAKE_OSX_ARCHITECTURES='i386;x86_64' \
          -DBUILD_SHARED_LIBS=ON \
          -DBUILD_EXTRAS=OFF -DBUILD_BULLET3=OFF \
          -DCMAKE_BUILD_TYPE=Release
        cd ../build-ios/
        make -j4
        ;;
    *)
        echo "Error: Platform \"$PLATFORM\" is not supported"
        ;;
esac

cd ../..
