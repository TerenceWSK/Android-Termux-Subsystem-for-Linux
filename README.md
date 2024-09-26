# Android-Termux-Subsystem-for-Linux

This repository is the personal collection of configurations for running Linux on Android. Transform your Android tablet into a (more portable) ARM64 Linux laptop!

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

**Time of test:** September 2024.
**Device:** Xiaomi Pad 6S Pro 12.4 (24018RPACC)
**Resolution:** 3048x2032
**SoC:** Qualcomm Snapdragon 8gen2 @ 3.19GHz
**RAM:** 16 GB
**ROM:** 1 TB
**Android Version:** 14 (Patch 2024-09-01)
**Android Kernel:** 5.15.123-android13-8-00008-g2ca6a2912c7e-ab11087001
**HyperOS Version:** 1.0.11.0.UNXCNXM

## Prerequisite

### App installation

**DO NOT** download from Google Play Store since the versions are outdated.

- [Termux](https://github.com/termux/termux-app/releases)
- [Termux:X11](https://github.com/termux/termux-x11/releases/tag/nightly)
- [Termux:Widget]()
