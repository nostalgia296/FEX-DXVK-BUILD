sudo apt install wget unzip glslang-tools zstd meson ninja-build binutils -y
WORKDIR=$(pwd)
wget https://github.com/bylaws/llvm-mingw/releases/download/20250920/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64.tar.xz
tar -xf llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64.tar.xz
PATH=$WORKDIR/llvm-mingw-20250920-ucrt-ubuntu-22.04-x86_64/bin:$PATH

git clone --recursive https://github.com/doitsujin/dxvk.git
cd dxvk

cat > build-arm64ec.txt << 'EOF'
[binaries]
ar = 'arm64ec-w64-mingw32-ar'
c = 'arm64ec-w64-mingw32-clang'
cpp = 'arm64ec-w64-mingw32-clang++'
ld = 'arm64ec-w64-mingw32-lld'
windres = 'arm64ec-w64-mingw32-windres'
widl = 'arm64ec-w64-mingw32-widl'
pkgconfig = 'aarch64-linux-gnu-pkg-config'

[host_machine]
system = 'windows'
cpu_family = 'aarch64'
cpu = 'aarch64'
endian = 'little'
EOF

meson setup arm64ec-build -Db_ndebug=if-release --cross-file "./build-arm64ec.txt" --buildtype "release" --prefix "/tmp/dxvk" --libdir "arm64ec" --strip 

cd arm64ec-build
ninja
sudo ninja install

cd /tmp/dxvk
tar -cf dxvk-arm64ec.tar arm64ec && zstd -19 dxvk-arm64ec.tar --rm 
