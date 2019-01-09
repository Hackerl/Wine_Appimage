#!/bin/bash
# Enable Multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf

pacman -Syy
pacman -S --noconfirm wget file pacman-contrib

# Get Wine
wget -c https://www.playonlinux.com/wine/binaries/linux-x86/PlayOnLinux-wine-3.10-linux-x86.pol
tar xfj PlayOnLinux-wine-*-linux-x86.pol wineversion/

wineworkdir=(wineversion/*)
cd $wineworkdir

# Add a dependency library, such as freetype font library
dependencys=$(pactree -s -u wine |grep lib32 | xargs)

wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/v0.9/libhookexecv.so -O bin/libhookexecv.so
wget -c https://github.com/Hackerl/Wine_Appimage/releases/download/v0.9/wine-preloader_hook -O bin/wine-preloader_hook

chmod +x bin/wine-preloader_hook

mkdir cache

pacman -Scc --noconfirm
pacman -Syw  --noconfirm --cachedir cache fontconfig $dependencys

find ./cache -name '*tar.xz' -exec tar -xJf {} \;

rm -rf cache

# appimage
cd -

wget -c "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -O  appimagetool.AppImage
chmod +x appimagetool.AppImage

chmod +x AppRun

cp AppRun $wineworkdir
cp resource/* $wineworkdir

./appimagetool.AppImage --appimage-extract

export ARCH=x86_64; squashfs-root/AppRun $wineworkdir