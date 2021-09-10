# Ungoogled Chromium for Void Linux

Ungoogled Chromium template and builds for Void Linux, based on the void-packages `chromium` template.

- [Building from sources](#building-from-source)
- [Binary release](#binary-release)
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

*Recommended to use `git clone --depth 1 git://github.com/void-linux/void-packages.git` to fetch only the current branch instead of the full tree.*

Clone this repository or download the source archive from the [Releases](//github.com/DAINRA/ungoogled-chromium-void/releases) page.

```sh
# cd to void-packages directory
# replace source_directory below with the path where you extracted the source archive or cloned the repository
cp -r source_directory/ungoogled-chromium srcpkgs/
# check srcpkgs/ungoogled-chromium/template
./xbps-src pkg ungoogled-chromium
xbps-install -vR hostdir/binpkgs ungoogled-chromium
```

*Also check this [section](//github.com/void-linux/void-packages/#building-packages-natively-for-the-musl-c-library) of the void-packages documentation in case you want to cross-compile.*

## Binary release

### Build Notes
- All packages are build with `build_options="clang vaapi pulseaudio pipewire"`

    - `debug` is disabled to reduce the package size
    - `js-optimize` is disabled (ungoogled-chromium flags.gn `enable_js_type_check=false`)
    - `sndio` is disabled (can be enabled by adding it to `build_options` and `build_options_default` in the template, will add to future builds if there is a demand)

- Musl version is built with `enable_widevine=false` since it's not available anyway (might improve stability).
- **Note:** in the past `gtk+3` was a runtime dependency for the package. On clean installs, it is required to install the `gtk+3` package manually.
- **Note:** x86 version fails to compile if sndio is enabled.
- **Note:** To enable VAAPI edit `/usr/bin/ungoogled-chromium` and add `--enable-features=VaapiVideoDecoder` to `CHROME_FLAGS`. More info [here](//chromium.googlesource.com/chromium/src/+/refs/heads/main/docs/gpu/vaapi.md). Also check [Void Handbook](//docs.voidlinux.org/config/graphical-session/graphics-drivers/intel.html) in case of problems.

### Available builds

- **`x86_64`**
- **`x86_64-musl`**

### Binary install

Download the `xbps` package matching your architecture and C library from the [Releases](//github.com/DAINRA/ungoogled-chromium-void/releases) page and install it:

```sh
# cd to download directory
xbps-rindex -a *.xbps
sudo xbps-install -vR $PWD ungoogled-chromium
# launch application
ungoogled-chromium
```

## Credits

- [Ungoogled Chromium](//github.com/Eloston/ungoogled-chromium)
- [The Void source packages collection](//github.com/void-linux/void-packages)
- [The Void (Linux) distribution](//voidlinux.org/)
