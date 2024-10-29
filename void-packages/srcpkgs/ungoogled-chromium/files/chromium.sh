#!/bin/sh
export CHROME_WRAPPER=/usr/lib/ungoogled-chromium/ungoogled-chromium
export CHROME_DESKTOP=ungoogled-chromium.desktop
CHROME_FLAGS="--enable-gpu-rasterization $CHROME_FLAGS"
exec /usr/lib/ungoogled-chromium/ungoogled-chromium $CHROME_FLAGS "$@"
