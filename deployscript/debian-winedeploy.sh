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

cd cache

apt download fontconfig-config gcc-6-base:i386 i965-va-driver:i386 libasound2:i386 libasound2-plugins:i386 libasyncns0:i386 libavahi-client3:i386 libavahi-common-data:i386 libavahi-common3:i386 libavcodec57:i386 libavresample3:i386 libavutil55:i386 libbsd0:i386 libc6:i386 libcairo2:i386 libcap2:i386 libcomerr2:i386 libcrystalhd3:i386 libcups2:i386 libdb5.3:i386 libdbus-1-3:i386 libdrm-amdgpu1:i386 libdrm-intel1:i386 libdrm-nouveau2:i386 libdrm-radeon1:i386 libdrm2:i386 libedit2:i386 libelf1:i386 libexpat1:i386 libffi6:i386 libflac8:i386 libfontconfig1:i386 libfreetype6:i386 libgcc1:i386 libgcrypt20:i386 libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libglapi-mesa:i386 libglu1-mesa:i386 libgmp10:i386 libgnutls30:i386 libgomp1:i386 libgpg-error0:i386 libgpm2:i386 libgsm1:i386 libgssapi-krb5-2:i386 libhogweed4:i386 libice6:i386 libicu57:i386 libidn11:i386 libjack-jackd2-0:i386 libjbig0:i386 libjpeg62-turbo:i386 libk5crypto3:i386 libkeyutils1:i386 libkrb5-3:i386 libkrb5support0:i386 liblcms2-2:i386 libldap-2.4-2:i386 libllvm3.9:i386 libltdl7:i386 liblz4-1:i386 liblzma5:i386 libmp3lame0:i386 libmpg123-0:i386 libncurses5:i386 libnettle6:i386 libnuma1:i386 libodbc1:i386 libogg0:i386 libopenal1:i386 libopenjp2-7:i386 libopus0:i386 libosmesa6:i386 libp11-kit0:i386 libpcap0.8:i386 libpciaccess0:i386 libpcre3:i386 libpixman-1-0:i386 libpng16-16:i386 libpulse0:i386 libsamplerate0:i386 libsasl2-2:i386 libsasl2-modules:i386 libsasl2-modules-db:i386 libselinux1:i386 libsensors4:i386 libshine3:i386 libsm6:i386 libsnappy1v5:i386 libsndfile1:i386 libsndio6.1:i386 libsoxr0:i386 libspeex1:i386 libspeexdsp1:i386 libssl1.1:i386 libstdc++6:i386 libswresample2:i386 libsystemd0:i386 libtasn1-6:i386 libtheora0:i386 libtiff5:i386 libtinfo5:i386 libtwolame0:i386 libtxc-dxtn-s2tc:i386 libuuid1:i386 libva-drm1:i386 libva-x11-1:i386 libva1:i386 libvdpau-va-gl1:i386 libvdpau1:i386 libvorbis0a:i386 libvorbisenc2:i386 libvpx4:i386 libwavpack1:i386 libwebp6:i386 libwebpmux2:i386 libwrap0:i386 libx11-6:i386 libx11-xcb1:i386 libx264-148:i386 libx265-95:i386 libxau6:i386 libxcb-dri2-0:i386 libxcb-dri3-0:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-render0:i386 libxcb-shm0:i386 libxcb-sync1:i386 libxcb1:i386 libxcomposite1:i386 libxcursor1:i386 libxdamage1:i386 libxdmcp6:i386 libxext6:i386 libxfixes3:i386 libxi6:i386 libxinerama1:i386 libxml2:i386 libxrandr2:i386 libxrender1:i386 libxshmfence1:i386 libxslt1.1:i386 libxtst6:i386 libxvidcore4:i386 libxxf86vm1:i386 libzvbi0:i386 mesa-va-drivers:i386 mesa-vdpau-drivers:i386 ocl-icd-libopencl1:i386 va-driver-all:i386 vdpau-driver-all:i386 zlib1g:i386

cd ..
find ./cache -name '*tar.xz' -exec dpkg -x {} . \;

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
