#!/bin/bash
# Get Wine
wget https://www.playonlinux.com/wine/binaries/linux-x86/PlayOnLinux-wine-3.5-linux-x86.pol
tar xfvj PlayOnLinux-wine-*-linux-x86.pol wineversion/
cd wineversion/*/

# Get suitable old ld-linux.so and the stuff that comes with it
wget -c http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6_2.24-11+deb9u3_i386.deb
dpkg -x libc6_2.24-11+deb9u3_i386.deb .

# Add a dependency library, such as freetype font library
# .....

# Get libhookexecv.so
wget -c https://github.com/probonopd/libhookexecv/releases/download/continuous/libhookexecv.so -O lib/libhookexecv.so

# Get patched wine-preload
wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/testing/wine-preloader-patched.zip
unzip wine-preloader-patched.zip
mv wine-preloader bin/

# Clean
rm wine-preloader-patched.zip
rm libc6_2.24-11+deb9u3_i386.deb

cat > AppRun <<\EOF
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"

export LD_LIBRARY_PATH="$HERE/usr/lib":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/lib":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/lib/i386-linux-gnu":$LD_LIBRARY_PATH

#Sound Library
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu/pulseaudio":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu/alsa-lib":$LD_LIBRARY_PATH

#LD
export WINELDLIBRARY="$HERE/lib/ld-linux.so.2"

LD_PRELOAD="$HERE/lib/libhookexecv.so" "$WINELDLIBRARY" "$HERE/bin/wine" "$@" | cat
EOF

chmod +x AppRun

# Run
./AppRun explorer.exe
