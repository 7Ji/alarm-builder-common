# ArchlinuxARM Builder common parts
Common parts to be used in my following projects:
 - https://github.com/7Ji/amlogic-s9xxx-archlinuxarm
 - https://github.com/7Ji/orangepi5-archlinuxarm

Check the above repos to understand how this should be used in an ArchLinuxARM builder project

## Usage
A basic project using this library would have a simple `build.sh` that reads the config and sources the functions:
```
#!/bin/bash -e
. common/scripts/config.sh
. common/functions/relative_source.sh
relative_source common/functions/build.sh
```
_`-e` flag is mandatory for bailing out when error encountered_

For any configs available from `config.sh`, the caller can now change them to adapt to what it actually wants, e.g.
```
name_distro+='-OrangePi5'
``` 
After the config, the caller just needs to call the `build()` entry function:
```
build
```

Without any further settings, running `./build.sh` or `bash -e build.sh` would:
 - Create a 2G raw disk image, with a MSDOS partition table, partitions start and the first, `boot` partition starts at 1M offset, and the second, `root` partition starts at 256M offset
 - Format `boot` to fat and `root` to ext4
 - Mount `root` to `/` relative to a temporary root, and `boot` to `/boot` relative to the same temporary root
 - `pacstrap` the following package (groups) into a temporary root: `base`, `openssh`, `sudo`, `vim`
 - Do basic settings, e.g.:
   - setup fstab
   - setup locales, default is enableing {zh_CN,en_{GB,US}}.UTF-8 and using zh_CN.UTF-8 as locale
   - enable network and ssh services
   - setup users, sudoers and passwords
   - setup timezone, default is Asia/Shanghai
   - symlinking `vi` to `vim`
   - ......
 - Pack all contents under the temporary root into a tarball using `libarchive`
 - Cleanup and umount everything
 - Compress the rootfs tarball and the image using `xz`

## Build-time compiling
You can add packages, usually from AUR pacakges, under a folder `build`, the library would build them lazily and install them into the root, e.g.
```
mkdir build
git submodule add https://aur.archlinux.org/linux-aarch64-orangepi5.git
git submodule add https://aur.archlinux.org/linux-firmware-orangepi.git
```
Submodule or not does not affect the building routine, but you need to make sure the folder structure is like the following if you add local packages:
```
build
 |- pkgA
 |  L- PKGBUILD
 L- pkgB
    L- PKGBUILD
build.sh
```
Additionally `pkg.blacklist` and `pkg.whitelist` can be created at the same level the of pkg folder themselves (not in them), with each line a pkgname without version info, to disable building, or only allow building of certain split pacakges. 

If such packages are built and installed, they would be stored under `pkgs`, and an addtionally tarball `-pkgs.tar` would be created to contain all package files used in the build.

## Cross building
This library also supports cross building under a Ubuntu 22.04 x86-64 box. Support is only aimed at this scenario as it is what Github Action uses. A basic cross building entry point `cross.sh`:
```
#!/bin/bash -e
. config.sh
. common/functions/relative_source.sh
relative_source common/functions/cross.sh
cross
```
_`-e` flag is mandatory for bailing out when error encountered_  

Without further setting, calling `cross.sh` or `bash -e cross.sh` would:
 - Deploy the official toolchain of ALARM
 - Deploy an ALARM generic rootfs
 - Build packages that have cross-build alternatives under `build_cross`
 - Start distcc in the host environemnt to host the above toolchain
 - Get into the ALARM root
 - Addtionally setup the localhost as distcc vulenteer
 - Call `./build.sh`
 - Get out
 - Cleanup