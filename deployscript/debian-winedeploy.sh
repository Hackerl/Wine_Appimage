#!/bin/bash
# Get Wine
wget https://www.playonlinux.com/wine/binaries/linux-x86/PlayOnLinux-wine-3.10-linux-x86.pol
tar xfvj PlayOnLinux-wine-*-linux-x86.pol wineversion/
cd wineversion/*/

# Add a dependency library, such as freetype font library
wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/v0.9/libhookexecv.so -O bin/libhookexecv.so
wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/v0.9/wine-preloader_hook -O bin/wine-preloader_hook

chmod +x bin/wine-preloader_hook

mkdir cache

sudo dpkg --add-architecture i386
sudo apt update
sudo apt install aptitude

sudo aptitude -d -o dir::cache::archives="$(pwd)/cache" install libwine:i386

rm cache/libwine*

find ./cache -name '*deb' -exec dpkg -x {} . \;

rm -rf cache

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
#Font Config
export FONTCONFIG_PATH="$HERE/etc/fonts"
#LD
export WINELDLIBRARY="$HERE/lib/ld-linux.so.2"
LD_PRELOAD="$HERE/bin/libhookexecv.so" "$WINELDLIBRARY" "$HERE/bin/wine" "$@" | cat
EOF

chmod +x AppRun
