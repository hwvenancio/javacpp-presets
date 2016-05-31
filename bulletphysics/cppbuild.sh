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
INSTALL_PATH=`pwd`
tar -xzvf ../bullet3-$BULLET_VERSION.tar.gz
cd bullet3-$BULLET_VERSION

case $PLATFORM in
    linux-x86_64)
        mkdir -p bullet-build
        cd bullet-build
        "$CMAKE" .. -G "Unix Makefiles" -DBUILD_SHARED_LIBS=on \
          -DEXECUTABLE_OUTPUT_PATH="$(pwd)/../bin" -DLIBRARY_OUTPUT_PATH="$(pwd)/../bin" \
          -DCMAKE_INSTALL_PREFIX="$INSTALL_PATH"
        make -j4
        make install
        ;;
    windows-x86)
        #cd build3
        #SCRIPT_WINPATH='cygpath --windows --absolute "vs2010.bat"'
        #EXPLORER_CYGPATH='which explorer'
        #EXPLORER_WINPATH='cygpath --windows --absolute "${EXPLORER_CYGPATH}"'
        #cmd /C start "clean shell" /I "${EXPLORER_WINPATH}" "${SCRIPT_WINPATH}"
        #cmd //c "vs2010.bat"
        "$CMAKE" . -G "MinGW Makefiles" -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON \
          -DFRAMEWORK=ON  -DCMAKE_OSX_ARCHITECTURES='i386;x86_64' \
          -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/Library/Frameworks \
          -DCMAKE_INSTALL_NAME_DIR=/Library/Frameworks -DBUILD_DEMOS:BOOL=OFF
        mingw32-make install
        ;;
    windows-x86_64)
        #cd build3
        #SCRIPT_WINPATH='cygpath --windows --absolute "vs2010_bullet2gpu.bat"'
        #EXPLORER_CYGPATH='which explorer'
        #EXPLORER_WINPATH='cygpath --windows --absolute "${EXPLORER_CYGPATH}"'
        #cmd /C start "clean shell" /I "${EXPLORER_WINPATH}" "${SCRIPT_WINPATH}"
        cmd //c "vs2010.bat"
        ;;
    *)
        echo "Error: Platform \"$PLATFORM\" is not supported"
        ;;
esac

cd ../..