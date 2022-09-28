# Ungoogled Chromium for Void Linux  
Ungoogled Chromium template and builds for Void Linux, based on the void-packages [chromium][1] template.

![GitHub release (latest by date)](https://img.shields.io/github/v/release/DAINRA/ungoogled-chromium-void?style=flat-square)

## Content Overview

- [**Building from sources**](#building-from-source)
- [**Binary release**](#binary-release)
    - [Available builds](#available-builds)
    - [Installing the binary package](#installing-the-binary-package)
- [**Troubleshooting**](#troubleshooting)
    - [Musl crashes mitigation](#musl-crashes-mitigation)
    - [General tweaks](#general-tweaks)
- [**Credits**](#credits)

## Building from source

> **Note**
>
> *Consult void-packages [documentation][2] for more information about setting it up.*
>
> [*Quick start*][2a]
>
> [*Building packages natively for the musl C library*][2b]

Clone and setup the void-packages repository in a work directory and:

```shell
git clone --depth=1 //github.com/DAINRA/ungoogled-chromium-void.git
[[ -d void-packages/srcpkgs/ungoogled-chromium ]] && rm -r void-packages/srcpkgs/ungoogled-chromium
cp -r ungoogled-chromium-void/void-packages/srcpkgs/ungoogled-chromium void-packages/srcpkgs/
cd void-packages
./xbps-src pkg ungoogled-chromium
```

## Binary release

```shell
./xbps-src show-options ungoogled-chromium
=> ungoogled-chromium-x.x.x.x_x: the following build options are set:
   clang: Use clang to build (ON)
   pipewire: Enable support for screen sharing for WebRTC via PipeWire (ON)
   pulseaudio: Enable support for the PulseAudio sound server (ON)
   vaapi: Enable support for VA-API (ON)
   debug: Build with debug symbols (OFF)
   js_optimize: Optimize the JS used for Chromium's UI (OFF)
   sndio: Enable support for the sndio sound server (OFF)
```

- `js_optimized` disabled as per [enable_js_type_check=false][3].
- `sndio` is disabled (same as the void-linux build) and `sndio.patch` is moved to the files directory.  
  If the option is enabled, it is applied at the end of the patching stage, otherwise it causes patching to fail.
- [remove-strip_binary.patch][4] removed since it is already included in [fix-building-with-prunned-binaries.patch][5].

### Available builds

You can check the workflow file for the available builds:

https://github.com/DAINRA/ungoogled-chromium-void/blob/17c6b58ef263d3dc2868102a0b9b6398de140c92/.github/workflows/create-release.yml#L35-L40

and the Actions tab for current [build progress](//github.com/DAINRA/ungoogled-chromium-void/actions/workflows/create-release.yml).

### Installing the binary package

#### Method 1 - manual update

Download the `xbps` package from the [releases](//github.com/DAINRA/ungoogled-chromium-void/releases) page, index and install the package:

```shell
xbps-rindex -a *.xbps
sudo xbps-install -vR $PWD ungoogled-chromium
```

#### Method 2 - updates handled by xbps-install

Add the releases page as a repository:

```shell
cat << EOF > /etc/xbps.d/20-ungoogled-chromium.conf
repository=//github.com/DAINRA/ungoogled-chromium-void/releases/latest/download/
EOF
xbps-install -Su ungoogled-chromium
```

First `xbps-install -S` run it will ask to import the repository key, same as [88:ac:8f:99:4d:b0:20:8f:6b:f0:8f:49:b9:13:fb:17.plist](void-packages/common/repo-keys/88:ac:8f:99:4d:b0:20:8f:6b:f0:8f:49:b9:13:fb:17.plist).

## Troubleshooting

- Although it is not included in the run dependencies, `gtk+3` package must be installed.
- To enable VAAPI add `--enable-features=VaapiVideoDecoder` to `CHROME_FLAGS` [environment variable][6].  
  More info [vaapi.md][7]. Also check [Void Handbook][8] in case of problems.
- For VAAPI `--disable-features=UseChromeOSDirectVideoDecoder` might also be needed.  
  Check in `chrome://gpu` if `Video Decode: Hardware accelerated`.

### Musl crashes mitigation

- Make sure you have `dbus` running (on glibc it doesn't matter).  
  Symptoms: crashes, pages stalling and refusing to load until browser restart, plugin crashes.
- Try adding `--js-flags=--jitless` to `CHROME_FLAGS`. If nothing else, it's a security hardening option.

### General tweaks

- Lower ram usage: `--renderer-process-limit=2` [renderer-process-limit][9].
- Reduce disk activity: `--disk-cache-size=1 --v8-cache-options=none` [disk-cache-size][10], [v8-cache-options][11].
- Dark Mode: `chrome://flags/#enable-force-dark`.
- Global media controls can cause crashes either by opening or closing it, as described in this [issue][12].  
  Either avoid using the feature or disable it completely (`--disable-features=GlobalMediaControls`).

## Credits

- [Ungoogled Chromium](//github.com/ungoogled-software/ungoogled-chromium)
- [The Void source packages collection](//github.com/void-linux/void-packages)
- [The Void (Linux) distribution](//voidlinux.org/)

[1]:  //github.com/void-linux/void-packages/blob/master/srcpkgs/chromium
[2]:  //github.com/void-linux/void-packages/#readme
[2a]: //github.com/void-linux/void-packages/#quick-start
[2b]: //github.com/void-linux/void-packages/#building-for-musl
[3]:  //github.com/ungoogled-software/ungoogled-chromium/blob/master/flags.gn
[4]:  //github.com/void-linux/void-packages/blob/master/srcpkgs/chromium/patches/remove-strip_binary.patch
[5]:  //github.com/ungoogled-software/ungoogled-chromium/blob/master/patches/core/ungoogled-chromium/fix-building-with-prunned-binaries.patch
[6]:  //wiki.archlinux.org/title/Environment_variables
[7]:  //chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md
[8]:  //docs.voidlinux.org/config/graphical-session/graphics-drivers/intel.html
[9]:  //peter.sh/experiments/chromium-command-line-switches/#renderer-process-limit
[10]: //peter.sh/experiments/chromium-command-line-switches/#disk-cache-size
[11]: //peter.sh/experiments/chromium-command-line-switches/#v8-cache-options
[12]: //bugs.chromium.org/p/chromium/issues/detail?id=1314342
