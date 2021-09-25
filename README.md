# Ungoogled Chromium for Void Linux

Ungoogled Chromium template and builds for Void Linux, based on the void-packages `Chromium` template.

## Content Overview

- [Building from sources](#building-from-source)
- [Binary release](#binary-release)
    - [Important note](#important-note)
    - [Build Notes](#build-notes)
    - [Troubleshooting](#troubleshooting)
    - [Available builds](#available-builds)
    - [Installing the binary package](#installing-the-binary-package)
- [Credits](#credits)

## Building from source

*If you haven't set up the void-packages repository consult this [page](//github.com/void-linux/void-packages/#readme) for more information. Relevant section:*

>### Quick start
>
>Clone the `void-packages` git repository and install the bootstrap packages:
>
>```
>$ git clone git://github.com/void-linux/void-packages.git
>$ cd void-packages
>$ ./xbps-src binary-bootstrap
>```

*Recommended to use **`git clone --depth 1`** to fetch only the current branch instead of the full tree.*

Clone this repository or download the source archive from the [Releases](//github.com/DAINRA/ungoogled-chromium-void/releases) page.

    # copy the folder ungoogled-chromium-void/ungoogled-chromium to void-packages/srcpkgs/
    $ ./xbps-src pkg ungoogled-chromium
    $ xbps-install -vR hostdir/binpkgs ungoogled-chromium

*Also check this [section](//github.com/void-linux/void-packages/#building-packages-natively-for-the-musl-c-library) of the void-packages documentation in case you want to cross-compile.*

## Binary release

### Important note

- Releases tagged with **`vx.x.x.x-x`** and the title **`Release vx.x.x.x-x`** are always based on official [void-packages](//github.com/void-linux/void-packages/tree/master/srcpkgs/chromium) template and [ungoogled-chromium](//github.com/Eloston/ungoogled-chromium/releases) release.
- Releases tagged with **`pre-vx.x.x.x-x`** and the title **`Pre-Release vx.x.x.x-x`** are based on PR from void-packages **and/or** ungoogled-chromium.  
    Unless there are major changes when the PR's are merged into the releases, these get promoted to the release version, otherwise the release version is rebuild.
- Releases tagged with **`testing-vx.x.x.x-x`** and the title **`Testing-Release vx.x.x.x-x`** are personal builds based on either void-packages **or** ungoogled-chromium.  
    As the name suggests, you should probably avoid these since they are just my tests for getting a version to build and might have missing patches and security fixes. Feel free to test them if you want to provide feedback.  
    Good enough for generating an initial ccache, opening a video on youtube and checking out the Print preview page 😃.

### Build Notes

All packages are build using `void-packages` with `build_options="clang vaapi pulseaudio pipewire"`.

- `debug` is disabled to reduce the package size
- `js-optimize` is disabled (ungoogled-chromium flags.gn `enable_js_type_check=false`)

Musl version is built with `enable_widevine=false` since it's not available anyway (might improve stability).

### Troubleshooting

- In the past `gtk+3` was a runtime dependency for the package. On clean installs, it is required to install the `gtk+3` package manually.
- i686 version fails to compile if `sndio` is enabled. Also breaks ungoogled-chromium patching. The patch is moved to the files directory and I have added a few checks to the template, so unless it is specified in `build_options` it won't be patched in.
- To enable VAAPI edit `/usr/bin/ungoogled-chromium` and add `--enable-features=VaapiVideoDecoder` to `CHROME_FLAGS`. More info [here](//chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md). Also check [Void Handbook](//docs.voidlinux.org/config/graphical-session/graphics-drivers/intel.html) in case of problems.
- As a warning, you might experience some stability issues on musl (tabs crashing with code 11 on javascript heavy sites). Most of the instability is caused by musl and has nothing to do with Chromium or the patches from Void or Ungoogled Chromium.

### Available builds

Architecture | Status
:---: | ---
**`x86_64`** | Released
**`x86_64-musl`** | Released
**`i686`** | Unreleased, builds fine, can't test if it's actually running.

### Installing the binary package

Download the `xbps` package matching your architecture and C library from the [Releases](//github.com/DAINRA/ungoogled-chromium-void/releases) page.

Index and install the package:

    $ xbps-rindex -a *.xbps
    $ sudo xbps-install -vR $PWD ungoogled-chromium
    $ ungoogled-chromium

## Credits

- [Ungoogled Chromium](//github.com/Eloston/ungoogled-chromium)
- [The Void source packages collection](//github.com/void-linux/void-packages)
- [The Void (Linux) distribution](//voidlinux.org/)
