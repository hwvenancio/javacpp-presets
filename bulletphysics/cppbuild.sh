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
        #"$CMAKE" . -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../../../mingw-w64-toolchain.cmake \
        #  -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON \
        #  -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON \
        #  -DCMAKE_OSX_ARCHITECTURES='i386;x86_64' \
        #  -DFRAMEWORK=ON \
        #  -DBUILD_BULLET3=OFF \
        #  -DBUILD_OPENGL3_DEMOS=OFF \
        #  -DBUILD_OPENGL3_DEMOS=OFF \
        #  -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF \
        #  -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF \
        #  -DBUILD_EXTRAS=OFF -DBUILD_BULLET3=OFF \
        #  -DCMAKE_INSTALL_PREFIX=/Library/Frameworks -DCMAKE_INSTALL_NAME_DIR=/Library/Frameworks \
        #  -DCMAKE_INSTALL_PREFIX=/Library/Frameworks -DCMAKE_INSTALL_NAME_DIR=/Library/Frameworks \
        #  -DCMAKE_EXE_LINKER_FLAGS="-static-libgcc -static-libstdc++" \
        #  -DCMAKE_EXE_LINKER_FLAGS="-static-libgcc -static-libstdc++" \
        #  -DCMAKE_BUILD_TYPE= 
        cmake . -G "Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=../../../mingw-w64-toolchain.cmake \
          -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON \
          -DINSTALL_LIBS=ON -DBUILD_SHARED_LIBS=ON \
          -DCMAKE_OSX_ARCHITECTURES='i386;x86_64' \
          -DFRAMEWORK=ON \
          -DBUILD_EXTRAS=OFF -DBUILD_BULLET3=OFF \
          -DCMAKE_INSTALL_PREFIX=/Library/Frameworks -DCMAKE_INSTALL_NAME_DIR=/Library/Frameworks \
          -DCMAKE_EXE_LINKER_FLAGS="-static-libgcc -static-libstdc++" \
          -DCMAKE_BUILD_TYPE= 
        #cd ../../build/
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
          -DBUILD_OPENGL3_DEMOS=OFF -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF \
          -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_INSTALL_PREFIX=/Library/Frameworks \
          -DCMAKE_INSTALL_NAME_DIR=/Library/Frameworks
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