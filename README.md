# Android-Termux-Subsystem-for-Linux

This repository is the personal collection of configurations for running Linux on Android **without root**. Transform your Android tablet into a (more portable) ARM64 Linux laptop!

This tutorial provides solutions for:
- **Native** Android-Termux-based Linux Desktop environment
- Termux-based **PRoot** Linux Distros (in this article, we select Ubuntu as an example)

The **native** solution is faster but **PRoot** has much more Linux apps support.

## References & Credits

Many tutorials exist on how to run Linux on Android. However, depending on the **version of Android you are using** and the **version of Linux you installed** (and also it depends on the **time you decide to try** -- some services might have changed), **your mileage may vary**. 
I followed the listed tutorials and adapted them to my needs.
I wrote this tutorial as my personal note & script-bakcups as well as a reference for future readers.

- [Termux project](https://termux.dev/en/) [GitHub](https://github.com/termux/termux-app)
- [Ivon's Blog](https://ivonblog.com/en-us/posts/termux-proot-distro-ubuntu/)
- [Termux-Desktops tutorials](https://github.com/LinuxDroidMaster/Termux-Desktops)
- [Technical Bot's video on PRoot Chromium installation](https://www.youtube.com/watch?v=SA03NwenOck)
- [Documentation on Android phantom process killer](https://github.com/agnostic-apollo/Android-Docs/blob/master/en/docs/apps/processes/phantom-cached-and-empty-processes.md)

## Testing Environment

- **Time of test:** September 2024.
- **Device:** Xiaomi Pad 6S Pro 12.4 (24018RPACC)
- **Resolution:** 3048x2032
- **SoC:** Qualcomm Snapdragon 8gen2 @ 3.19GHz
- **RAM:** 16 GB
- **ROM:** 1 TB
- **Android Version:** 14 (Patch 2024-09-01)
- **Android Kernel:** 5.15.123-android13-8-00008-g2ca6a2912c7e-ab11087001
- **HyperOS Version:** 1.0.11.0.UNXCNXM

## 1. Prerequisite (for both native and PRoot)

### 1.1 Android apps

#### 1.1.1 Install Termux apps

**DO NOT** download from *Google Play Store* since the versions are outdated.

- [Termux](https://github.com/termux/termux-app/releases)
- [Termux:X11](https://github.com/termux/termux-x11/releases/tag/nightly) to display your desktop environment
- [Termux:Widget](https://github.com/termux/termux-widget/releases) is used for quickly launching the Termux and PRoot desktop enviroment
- [Termux:Styling](https://github.com/termux/termux-styling/releases) (optional, if you want to adjust the look of your Termux command-line interface)

#### 1.1.2 In Termux app using command:

Give permission for storage:

```
termux-setup-storage
```

Check for updates:

```
pkg update
```

```
pkg upgrade
```

Install X11 repos for displaying:

```
pkg install x11-repo
```

```
pkg install termux-x11-nightly
```

```
pkg install pulseaudio
```

To fix any repository issues:

```
termux-change-repo
```

Useful tools:

```
pkg install wget
```

```
pkg install git
```

#### 1.1.3 Settings for Termux:X11 app:

If there is no ```preference``` button, take a look at your notification list in Android. Change the preference default settings: 

- **Display resolution mode:** scaled
- **Fullscreen on device display:** on
- **Force landscape orientation:** on
- **Hide display cutout:** on
- **Touchscreen input mode:** trackpad
- **Capture external mouse when possible:** on
- **Show additional keyboard:** off

Connecting to a (wireless) keyboard and mouse is recommended. 

### 1.2 Disable Android phantom process killer

#### 1.2.1 What is phantom process killer?

In a word, the phantom process killer is a mechanism introduced recently (Android version >= 12) in Android Open Source Project (AOSP) that is present on almost all smart devices running Android-based OS (stock Android, HyperOS/MIUI, OriginOS, ColorOS, MagicOS, HarmonyOS (before NEXT), One UI, myUI, Flyme, etc.)
It limits the number of children processes (phantom process running in the background) of apps and kills them without prompt.
The default number of total phantom processes allowed is 32, which is not enough for running an OS on top of Android.

More about this mechanism: [Documentation on Android phantom process killer](https://github.com/agnostic-apollo/Android-Docs/blob/master/en/docs/apps/processes/phantom-cached-and-empty-processes.md). **This section is based on this article under the MIT licence.**

An note for HarmonyOS (1.x--4.x) users: HarmonyOS does not display Android versions. To check the Android version your system is based on, you can use third-party tools to detect the API level. Note that the developer options available are also a little different from standard Android.

#### 1.2.2 Method 1: Developer options (recommended)

**ONLY for Android version >= 14**

Enable toggle once at ```Android Settings -> System -> Developer options -> Disable child process restrictions``` to disable killing of **extra phantom processes > 32** and processes using excessive cpu. You will need to enable Developer options first on your device for it to show in ```System``` settings page, and it can usually be done by tapping ```Android Settings -> About -> Build number``` field **7** times.

If you disable ```Developer options``` again, then ```Disable child process restrictions``` toggle will be disabled again automatically and killing of phantom processes will be enabled again. 

#### 1.2.3 Method 2: Wireless ADB debugging (NOT recommended)

**For Android 12L & 13+**

The wireless adb debugging is also in ```Developer options```. Assuming there is no root access, the commands should be re-enabled on each reboot.

On some devices, such as the one I am testing with, the method using adb wireless debugging do not work due to unknown reason.

**Android 13:**

```
adb shell "settings put global settings_enable_monitor_phantom_procs false"
```

```
adb shell "/system/bin/device_config get_sync_disabled_for_tests"
```

**Android 12:**

```
adb shell "/system/bin/device_config put activity_manager max_phantom_processes 2147483647"
```

```
adb shell "/system/bin/device_config is_sync_disabled_for_tests"
```

## 2. Native Termux Linux Desktop Environment

### 2.1 Install xfce4 desktop environment

```
pkg install xfce4
```

### 2.2 Install ported Linux software

**Prerequiste:**

```
pkg install tur-repo
```

**Chromium:** 

```
pkg install chromium
```

*Known issue:* crash on Google account login. To launch it, later in graphical interface: add ```--no-sandbox``` after launch command.

**Code-oss:** (open source project of Visual Studio Code)

```
pkg install code-oss
```

*Known issue:* cannot sync with Microsoft.

### 2.3 Add script for launching desktop environment

Download the script:

```
wget https://raw.githubusercontent.com/LinuxDroidMaster/Termux-Desktops/main/scripts/termux_native/startxfce4_termux.sh
```

OR, here is a backup if the original script no longer accessible:

```
wget https://raw.githubusercontent.com/TerenceWSK/Android-Termux-Subsystem-for-Linux/main/scripts/startxfce4_termux.sh
```

Copy the scrupt to ```./.shortcuts/``` to be accessible with Termux:Widget

```
cp ./startxfce4_termux.sh ./shortcuts/
```

Give excution permissions:

```
chmod +x ./.shortcuts/startxfce4_termux.sh
```

### 2.4 Launch the Termux Native desktop environment from Termux:Widget

- Long click/hold on the blank places on any Android home screen (launcher)
- Add a **Android Widget "Termux:Widget"**
- You should find the ```startxfce4_termux.sh```
- Click on it and you should be able to lanch **Termux:X11**.
- Otherwise, in Termux terminal, use ```sh ./startxfce4_termux.sh```

<img src="/img/termux-android.jpg">

### 2.5 File sharing with Android

In Termux native desktop, you can access your user files and folders of Android host machine mounted at ```~/Desktop/shared/``` or ```/data/data/com.termux/files/home/Desktop/shared```. You can make a link on desktop or pin it to the sidebar of the file manager.

## 3. Termux-based PRoot Linux Distros (Ubuntu)

The Ubuntu system installation part is mostly based on [Ivon's blog](https://ivonblog.com/en-us/posts/termux-proot-distro-ubuntu/), the software installation part is *my collection and adaptation from various sources to make things work*.

### 3.1 Ubuntu setup

**Installation:**

```
pkg install proot-distro
```

```
proot-distro install ubuntu
```

**Login to Ubuntu:**

```
proot-distro login ubuntu --user root --shared-tmp
```

**Install tools:**

```
apt update
```

```
apt install sudo vim software-properties-common
```

**Due to no systemd on Android, disable Ubuntu snap:**

```
cat <<EOF | sudo tee /etc/apt/preferences.d/nosnap.pref
# To prevent repository packages from triggering the installation of Snap,
# this file forbids snapd from being installed by APT.
# For more information: https://linuxmint-user-guide.readthedocs.io/en/latest/snap.html
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
```

**Install Firefox or you will not have a browser to download software:**

```
sudo add-apt-repository ppa:mozillateam/ppa
```

```
sudo apt-get update
```

```
sudo apt-get install firefox-esr
```

**Create a password for root:**

```
passwd
```

**Create groups:**

```
groupadd storage
groupadd wheel
groupadd video
```

**Create a regular user other than root:**

```
useradd -m -g users -G wheel,audio,video,storage -s /bin/bash user
```

```
passwd user
```

**Add user to sudo group:**

```
visudo
```

Press the "I" key for insertion of:

```
user ALL=(ALL:ALL) ALL
```

Touch "ESC" on the bottom of the screen and type:

```
wq
```

to exit.

**Switch to regular user:**

```
su user
cd
```

**Install xfce desktop environment:**

```
sudo apt install xubuntu-desktop
```

```
sudo update-alternatives --config x-terminal-emulator
```

For KDE and GNOME you can refer to
[Ivon's blog](https://ivonblog.com/en-us/posts/termux-proot-distro-ubuntu/) or the [Tutorials by LinuxDroidMaster](https://github.com/LinuxDroidMaster/Termux-Desktops/blob/main/Documentation/proot/ubuntu_proot.md)

**Disable Ubuntu lockscreen.** When Android is locked and unlocked, Ubuntu displays a lockscreen with no correct password to login. This might be due to compatibility isuues with PRoot:

```
xset s off
```

```
xset -dpms
```

### 3.2 (Optional) Support for the Chinese language （可选）添加中文支持

**添加字体：**

```
sudo apt install locales fonts-noto-cjk
```

**修改配置文件：**

```
vim /etc/locale.gen
```

将其中```zh_CN.UTF-8 UTF-8```前的#号移除
使用```:wq!```退出vim

**生成语言：**

```
locale-gen
```

```
echo "LANG=zh_CN.UTF-8 UTF-8" > /etc/locale.conf
```

**移除ibus组件：**

```
sudo apt purge ibus
```

**安装fcitx组件和Google拼音：**

```
apt install fcitx fcitx-pinyin
``` 

```
fcitx-googlepinyin
```

在3.3节成功进入xfce4图形界面后，在应用菜单>语言支持(Language Support)和fcitx设置中，添加English(US)作为键盘布局，以及选择Google Pinyin作为输入法，重启终端。

### 3.3 Add script for launching desktop environment

Download the script:

```
wget https://raw.githubusercontent.com/TerenceWSK/Android-Termux-Subsystem-for-Linux/main/scripts/startproot_ubuntu.sh
```

Copy the scrupt to ```./.shortcuts/``` to be accessible with Termux:Widget

```
cp ./startproot_ubuntu.sh ./shortcuts/
```

Give excution permissions:

```
chmod +x ./.shortcuts/startproot_ubuntu.sh
```

### 3.4 Launch the Ubuntu desktop environment from Termux:Widget

- Long click/hold on the blank places on any Android home screen (launcher)
- Add a Android Widget "Termux:Widget"
- You should find the ```startproot_ubuntu.sh```
- Click on it and you should be able to lanch Termux:X11.
- Otherwise, in Termux terminal, use ```sh ./startproot_ubuntu.sh```

<img src="/img/termux-ubuntu.jpg">

### 3.5 File sharing with Android

In Termux native desktop, you can access your user files and folders of Android host machine mounted at ```/storage/emulated/0```. You can make a link on desktop or pin it to the sidebar of the file manager.

### 3.6 Ubuntu softwares

#### Tested to work directly:

- GIMP (pre-installed)
- Octave (```sudo apt install octave```)
- TeX Live (```sudo apt install texlive```)

#### Does not work:

- WPS office (crash on launch)
- blender (crash on launch)

#### Visual Studio Code

- Go to [VS Code download page](https://code.visualstudio.com/download#) and select Linux Arm64.
- In ```Downloads``` folder: ```sudo dpkg -i code*.deb```
- In the properties of the VS Code launch icon: add ```--no-sandbox```

#### Chromium
On September 2024, the method introduced in the tutorial video ["How to install Chromium in Ubuntu | Termux" by Technical Bot](https://www.youtube.com/watch?v=SA03NwenOck) can no longer work smoothly, mainly due to gpg key management issue due to the current server conditions and the updated software.

**Check if gpg is installed:**

```
sudo apt install gnupg
```

**Add the debian source that has Chromium:**

```
echo "deb http://ftp.debian.org/debian buster main" >> /etc/apt/sources.list
```

``` 
sudo apt update
```

**Then a gpg key error will occur.** The original method:

```
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
```

will NOT work.

One solution is to exit the graphical enviroment, kill, and re-open Termux:

```
proot-distro login ubuntu
```

Try the following solutions:

**Solution 1:**

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 8B48AD6246925553
```

**Solution 2:**

```
gpg2 --keyserver hkps://keyserver.ubuntu.com:443 --recv-keys 648ACFD622F3D138
```

**Solution 3:**

```
gpg --keyserver pgp.mit.edu --recv-keys 54404762BBB6E853 BDE6D2B9216EC7A8 648ACFD622F3D138 0E98404D386FA1D9 F8D2585B8783D481 0E98404D386FA1D9 6ED0E7B82643E131
```

or

```
gpg --armor --export DC30D7C23CBBABEE | sudo apt-key add -
```

Then

```
sudo apt update
```
```
sudo apt install chromium
```

In the properties of the VS Code launch icon: add ```--no-sandbox```
