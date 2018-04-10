# Appimage For Wine
## 简介
AppImage 是一种把应用打包成单一文件的格式，允许在各种不同的目标系统（基础系统(Debian、RHEL等)，发行版(Ubuntu、Deepin等)）上运行，无需进一步修改。
创建Appimage就是搜集可执行程序及其依赖，放到一个文件夹下面。然后设置可执行文件依赖库路径，使得程序的执行不再依赖当前系统环境。此文件夹就相当于程序执行时的系统环境，然后将文件夹压缩，最后打包成Appimage。
运行Appimage时会解压出文件夹，然后运行其中的可执行脚本。
## Download
[Appimage Releases](https://github.com/Hackerl/Wine_Appimage/releases)
### Windows Apps
* Wine-x86_64.AppImage
* ThunderMini-x86_64.AppImage 迅雷精简版
* TIM-x86_64.AppImage TIM应用来自[askme765cs](https://github.com/askme765cs/Wine-QQ-TIM)，进行了重新打包

应用皆依赖于Wine-x86_64.AppImage，所以请先下载Wine-x86_64.AppImage，执行：
```Bash
sudo ln -s $(pwd)/Wine-x86_64.AppImage /usr/local/bin/wine
```
## Wine
Wine （“Wine Is Not an Emulator” 的递归缩写）是一个能够在多种 POSIX-compliant 操作系统（诸如 Linux，Mac OSX 及 BSD 等）上运行 Windows 应用的兼容层。
而Wine的依赖库比较多，而且必须安装i386架构才能执行Win32位程序，如果能打包成一个Appimage，将省去安装、配置等繁琐步骤。
## AppDir
先创建打包Appimage的文件夹，然后我们需要搜集Wine的可执行程序。
从源下载的包安装后，可执行文件及库会分布在系统不同路径，于是我想手动编译，指定prefix就能搜集Wine的所有文件。
但我发现PlayOnLinux提供编译好的[压缩包](https://www.playonlinux.com/wine/binaries/linux-x86/)，下载最新版本的Wine -- PlayOnLinux-wine-3.5-linux-x86.pol。
解压查看文件目录：

![](/images/1.png)

删除无关的files、playonlinux目录，将Wine目录移到AppDir下：

![](/images/2.png)


## 搜集系统依赖
现在我们有了Wine的所有可执行文件、依赖，但是没有系统依赖。此次打包的是wine32，所以需要安装i386系统环境。
我选择让apt帮我寻找依赖：
```Bash
sudo apt install wine32:i386
```
得到依赖：
> gcc-6-base:i386 i965-va-driver:i386 libasound2:i386 libasound2-plugins:i386 libasyncns0:i386 libavahi-client3:i386 libavahi-common-data:i386 libavahi-common3:i386 libavcodec57:i386 libavresample3:i386 libavutil55:i386 libbsd0:i386 libc6:i386 libcairo2:i386 libcap2:i386 libcomerr2:i386 libcrystalhd3:i386 libcups2:i386 libdb5.3:i386 libdbus-1-3:i386 libdrm-amdgpu1:i386 libdrm-intel1:i386 libdrm-nouveau2:i386 libdrm-radeon1:i386 libdrm2:i386 libedit2:i386 libelf1:i386 libexpat1:i386 libffi6:i386 libflac8:i386 libfontconfig1:i386 libfreetype6:i386 libgcc1:i386 libgcrypt20:i386 libgl1-mesa-dri:i386 libgl1-mesa-glx:i386 libglapi-mesa:i386 libglu1-mesa:i386 libgmp10:i386 libgnutls30:i386 libgomp1:i386 libgpg-error0:i386 libgpm2:i386 libgsm1:i386 libgssapi-krb5-2:i386 libhogweed4:i386 libice6:i386 libicu57:i386 libidn11:i386 libjack-jackd2-0:i386 libjbig0:i386 libjpeg62-turbo:i386 libk5crypto3:i386 libkeyutils1:i386 libkrb5-3:i386 libkrb5support0:i386 liblcms2-2:i386 libldap-2.4-2:i386 libllvm3.9:i386 libltdl7:i386 liblz4-1:i386 liblzma5:i386 libmp3lame0:i386 libmpg123-0:i386 libncurses5:i386 libnettle6:i386 libnuma1:i386 libodbc1:i386 libogg0:i386 libopenal1:i386 libopenjp2-7:i386 libopus0:i386 libosmesa6:i386 libp11-kit0:i386 libpcap0.8:i386 libpciaccess0:i386 libpcre3:i386 libpixman-1-0:i386 libpng16-16:i386 libpulse0:i386 libsamplerate0:i386 libsasl2-2:i386 libsasl2-modules:i386 libsasl2-modules-db:i386 libselinux1:i386 libsensors4:i386 libshine3:i386 libsm6:i386 libsnappy1v5:i386 libsndfile1:i386 libsndio6.1:i386 libsoxr0:i386 libspeex1:i386 libspeexdsp1:i386 libssl1.1:i386 libstdc++6:i386 libswresample2:i386 libsystemd0:i386 libtasn1-6:i386 libtheora0:i386 libtiff5:i386 libtinfo5:i386 libtwolame0:i386 libtxc-dxtn-s2tc:i386 libuuid1:i386 libva-drm1:i386 libva-x11-1:i386 libva1:i386 libvdpau-va-gl1:i386 libvdpau1:i386 libvorbis0a:i386 libvorbisenc2:i386 libvpx4:i386 libwavpack1:i386 libwebp6:i386 libwebpmux2:i386 libwrap0:i386 libx11-6:i386 libx11-xcb1:i386 libx264-148:i386 libx265-95:i386 libxau6:i386 libxcb-dri2-0:i386 libxcb-dri3-0:i386 libxcb-glx0:i386 libxcb-present0:i386 libxcb-render0:i386 libxcb-shm0:i386 libxcb-sync1:i386 libxcb1:i386 libxcomposite1:i386 libxcursor1:i386 libxdamage1:i386 libxdmcp6:i386 libxext6:i386 libxfixes3:i386 libxi6:i386 libxinerama1:i386 libxml2:i386 libxrandr2:i386 libxrender1:i386 libxshmfence1:i386 libxslt1.1:i386 libxtst6:i386 libxvidcore4:i386 libxxf86vm1:i386 libzvbi0:i386 mesa-va-drivers:i386 mesa-vdpau-drivers:i386 ocl-icd-libopencl1:i386 va-driver-all:i386 vdpau-driver-all:i386 zlib1g:i386

下载所有依赖：
```Bash
apt download files
```
将所有deb包让如AppDir/debs中，使用dpkg解压文件：
```Bash
find ./debs -exec dpkg -x {} ./ \;
```
执行完后，所有deb包中的内容都解压出来了：

![](/images/3.png)

## ld-linux.so
这是负责加载动态库的解释器，在程序中是硬编码指定的：

![](/images/4.png)

对于32位程序是/lib/ld-linux.so.2,64位是/lib64/ld-linux-x86-64.so.2。
此文件包含在libc6中，我们已经解压了libc6:i386.deb，ld-linux.so.2 在 AppDir/lib 中。
有一个办法是，手动复制 AppDir/lib/ld-linux.so.2 至 /lib，不过这就需要每个使用者下载后都执行此操作。

还有一个方式是改变可执行文件的硬编码解释器路径，执行：
```Bash
FILES=$(grep -r ld-linux.so.2 ./bin | cut -d " " -f 3)
for FILE in $FILES ; do
    patchelf --set-interpreter /tmp/ld-linux.so.2 $FILE
done
```
改变所有路径为/tmp/ld-linux.so.2，然后在执行Appimage时，创建软链接/tmp/ld-linux.so.2 指向 AppDir/lib/ld-linux.so.2。
## 声音播放问题
声音播放依赖于AppDir/usr/lib/libpulse.so.0，libpulse.so中指定了runpath：

![](/images/5.png)

动态库加载顺序：
> libraries goes as follows:
1 - rpath
2 - $LD_LIBRARY_PATH
3 - runpath
4 - ld.so.cache
5 - default ld.so directories (where glibc has been installed)

此时 pulseaudio 在 AppDir/usr/lib/i386-linux-gnu 中，所以在 LD_LIBRARY_PATH 中添加 AppDir/usr/lib/i386-linux-gnu/pulseaudio：
```Bash
#Sound Library
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu/pulseaudio":$LD_LIBRARY_PATH
#插件
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu/alsa-lib":$LD_LIBRARY_PATH
```
## 打包
编写AppRun：
```Bash
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"

export LD_LIBRARY_PATH="$HERE/usr/lib":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/lib":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/lib/i386-linux-gnu":$LD_LIBRARY_PATH

#Sound Library
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu/pulseaudio":$LD_LIBRARY_PATH
export LD_LIBRARY_PATH="$HERE/usr/lib/i386-linux-gnu/alsa-lib":$LD_LIBRARY_PATH

LD_SO="/tmp/ld-linux.so.2"

if [ ! -e $LD_SO ] ; then
  echo "Create ld-linux.so.2"
  ln -s $(readlink -f "$HERE"/lib/ld-linux.so.2 ) $LD_SO
fi

function finish {
  echo "Wine Cleaning up"
  rm $LD_SO
}
trap finish EXIT

$("$HERE/bin/wine" "$@")
wait
```
此时Wine已经可以执行，完全不依赖系统环境，执行打包命令：
```Bash
export ARCH=x86_64; appimagetool-x86_64.AppImage AppDir
```
成功完成Wine的Appimage打包。

---
# 构建Windows Appimage应用
## 创建wine软链接
其实在构建Windows Appimage时，不必将Wine放入每个应用中。完全可以将Wine Appimage的软链接放入/usr/local/bin，在各个Windows Appimage应用中调用Wine Appimage。
下载Wine Appimage，创建软链接：
```Bash
ln $(pwd)/Wine-x86_64.AppImage /usr/local/bin/wine
```
## 构建应用AppDir
将应用Wine配置目录放入AppDir，以迅雷精简版为例：

![](/images/6.png)

之后通过设置 WINEPREFIX 变量，使得Wine以目录为起始，作为读写源。
## 虚拟目录
Wine需要对Appimage中的WINEPREFIX目录进行读写，但Appimage中的内容挂载出来是只读属性。
所以需要使用使用虚拟目录，将对WINEPREFIX的写操作重定向至$HOME，从而存储应用数据：
```Bash
RO_DATADIR="$HERE/opt/apps.com.thunder.mini/"
RW_DATADIR="$HOME/.ThunderMini"
TOP_NODE="/tmp/.ThunderMini.unionfs"

mkdir -p $RW_DATADIR $TOP_NODE

$HERE/usr/bin/unionfs-fuse -o use_ino,nonempty,uid=$UID -ocow "$RW_DATADIR"=RW:"$RO_DATADIR"=RO "$TOP_NODE" || exit 1
```
将unionfs-fuse放入Appimage中，使用unionfs-fuse形成虚拟节点。
上面的命令将创建 TOP_NODE 虚拟节点，只读目录 RO_DATADIR 指向WINEPREFIX目录，而读写目录 RW_DATADIR 用来储存数据。
当对虚拟节点 TOP_NODE 进行读时，会到RO_DATADIR、RW_DATADIR中寻找文件。
当对 TOP_NODE 进行写时，会重定向至 RW_DATADIR。
## AppRun
创建运行脚本：
```Bash
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"

export WINEDEBUG=-all

RO_DATADIR="$HERE/opt/apps.com.thunder.mini/"
RW_DATADIR="$HOME/.ThunderMini"
TOP_NODE="/tmp/.ThunderMini.unionfs"

mkdir -p $RW_DATADIR $TOP_NODE

$HERE/usr/bin/unionfs-fuse -o use_ino,nonempty,uid=$UID -ocow "$RW_DATADIR"=RW:"$RO_DATADIR"=RO "$TOP_NODE" || exit 1

function finish {
  echo "Cleaning up"
  killall $HERE/usr/bin/unionfs-fuse
}
trap finish EXIT

export WINEPREFIX="$TOP_NODE"
wine "c:\\Program Files\\Thunder Network\\MiniThunder\\Bin\\ThunderMini.exe" "$@"
```
最后的命令运行wine，必须保证指向Wine Appimage的软链接/usr/local/bin/wine存在。
## 打包运行
```Bash
export ARCH=x86_64; ./appimagetool-x86_64.AppImage squashfs-root
```
运行：

![](/images/7.png)
