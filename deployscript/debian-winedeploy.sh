#!/bin/bash
# Pre install
dpkg --add-architecture i386
apt update
apt install -y aptitude wget file gnupg bzip2

# Get Wine
wget -c https://www.playonlinux.com/wine/binaries/linux-x86/PlayOnLinux-wine-3.10-linux-x86.pol
tar xfj PlayOnLinux-wine-*-linux-x86.pol wineversion/

wineworkdir=(wineversion/*)
cd $wineworkdir

# Add a dependency library, such as freetype font library
wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/v0.9/libhookexecv.so -O bin/libhookexecv.so
wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/v0.9/wine-preloader_hook -O bin/wine-preloader_hook

chmod +x bin/wine-preloader_hook

pkgcachedir='/tmp/.winedeploycache'
mkdir -p $pkgcachedir

aptitude -y -d -o dir::cache::archives="$pkgcachedir" install libwine:i386

find $pkgcachedir -name '*deb' ! -name 'libwine*' -exec dpkg -x {} . \;

rm -rf $pkgcachedir

# appimage
cd -

wget -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O  appimagetool.AppImage
chmod +x appimagetool.AppImage

chmod +x AppRun

cp AppRun $wineworkdir
cp resource/* $wineworkdir

./appimagetool.AppImage --appimage-extract

export ARCH=x86_64; squashfs-root/AppRun $wineworkdir