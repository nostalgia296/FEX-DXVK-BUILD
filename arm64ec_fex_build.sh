apt install wget unzip -y

WORKDIR=$(pwd)
wget https://github.com/bylaws/llvm-mingw/releases/download/20250920/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64.tar.xz
tar -xf llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64.tar.xz
PATH=$WORKDIR/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64/bin:$PATH

git clone --recurse-submodules https://github.com/FEX-Emu/FEX.git
cd FEX
mkdir build-arm64ec
cd build-arm64ec
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../Data/CMake/toolchain_mingw.cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/wine/aarch64-windows -DENABLE_LTO=False -DMINGW_TRIPLE=arm64ec-w64-mingw32 -DBUILD_TESTING=False -DENABLE_JEMALLOC_GLIBC_ALLOC=False -DCMAKE_INSTALL_PREFIX=/tmp/FEX ..
ninja
sudo ninja install
cd ..
mkdir build-wow64
cd build-wow64
cmake -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../Data/CMake/toolchain_mingw.cmake -DCMAKE_INSTALL_LIBDIR=/usr/lib/wine/aarch64-windows -DENABLE_LTO=False -DMINGW_TRIPLE=aarch64-w64-mingw32 -DBUILD_TESTING=False -DENABLE_JEMALLOC_GLIBC_ALLOC=False -DCMAKE_INSTALL_PREFIX=/tmp/FEX ..
ninja
sudo ninja install
cd ..