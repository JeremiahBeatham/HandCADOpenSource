#!/usr/bin/env bash
# Build the pinned OCCT release (core/tools/occt.env) as static libraries with a
# minimal module set: FoundationClasses, ModelingData, ModelingAlgorithms,
# DataExchange. No Draw, Tcl/Tk, OpenGL, FreeType, X11 or samples.
#
# Usage: core/tools/build-occt.sh [host|ios-device|ios-simulator|macos]
#   macos: arm64, minimum macOS $HANDCAD_MACOS_DEPLOYMENT_TARGET (default 14.0) — the
#          xcframework's macOS slice for HandCADKit's `swift test`. `host` uses the
#          toolchain default (on a Mac, the running macOS version).
#
# Layout (outside the repo; override the root with HANDCAD_BUILD_ROOT):
#   $HANDCAD_BUILD_ROOT/occt/src                     pinned source checkout
#   $HANDCAD_BUILD_ROOT/occt/<ver>/build-<platform>  build tree (deleted unless KEEP_OCCT_BUILD=1)
#   $HANDCAD_BUILD_ROOT/occt/<ver>/install-<platform> install prefix (find_package(OpenCASCADE))
set -euo pipefail

PLATFORM="${1:-host}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=occt.env
source "$HERE/occt.env"

ROOT="${HANDCAD_BUILD_ROOT:-$HOME/Developer/.handcad-build}"
SRC="$ROOT/occt/src"
BUILD="$ROOT/occt/$OCCT_VERSION/build-$PLATFORM"
PREFIX="$ROOT/occt/$OCCT_VERSION/install-$PLATFORM"
JOBS="${JOBS:-$(getconf _NPROCESSORS_ONLN 2>/dev/null || echo 4)}"

if [[ -f "$PREFIX/.handcad-occt-$OCCT_COMMIT" ]]; then
  echo "OCCT $OCCT_VERSION ($PLATFORM) already installed at $PREFIX"
  exit 0
fi

# --- source at the pinned commit -------------------------------------------
if [[ ! -d "$SRC/.git" ]]; then
  git clone --depth 1 --branch "$OCCT_TAG" "$OCCT_REPO" "$SRC"
fi
actual="$(git -C "$SRC" rev-parse HEAD)"
if [[ "$actual" != "$OCCT_COMMIT" ]]; then
  echo "error: $SRC is at $actual, expected $OCCT_COMMIT ($OCCT_TAG)." >&2
  echo "       Delete $SRC or check out $OCCT_TAG." >&2
  exit 1
fi

# --- platform flags ---------------------------------------------------------
platform_args=()
case "$PLATFORM" in
  host) ;;
  ios-device)
    platform_args=(-DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT=iphoneos
                   -DCMAKE_OSX_ARCHITECTURES=arm64
                   -DCMAKE_OSX_DEPLOYMENT_TARGET="$HANDCAD_IOS_DEPLOYMENT_TARGET") ;;
  ios-simulator)
    platform_args=(-DCMAKE_SYSTEM_NAME=iOS -DCMAKE_OSX_SYSROOT=iphonesimulator
                   -DCMAKE_OSX_ARCHITECTURES=arm64
                   -DCMAKE_OSX_DEPLOYMENT_TARGET="$HANDCAD_IOS_DEPLOYMENT_TARGET") ;;
  macos)
    platform_args=(-DCMAKE_OSX_ARCHITECTURES=arm64
                   -DCMAKE_OSX_DEPLOYMENT_TARGET="${HANDCAD_MACOS_DEPLOYMENT_TARGET:-14.0}") ;;
  *) echo "error: unknown platform '$PLATFORM' (host|ios-device|ios-simulator|macos)" >&2; exit 2 ;;
esac

# --- configure / build / install --------------------------------------------
start=$(date +%s)
cmake -S "$SRC" -B "$BUILD" -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DINSTALL_DIR="$PREFIX" \
  -DBUILD_LIBRARY_TYPE=Static \
  -DBUILD_CPP_STANDARD=C++17 \
  -DBUILD_MODULE_FoundationClasses=ON \
  -DBUILD_MODULE_ModelingData=ON \
  -DBUILD_MODULE_ModelingAlgorithms=ON \
  -DBUILD_MODULE_DataExchange=ON \
  -DBUILD_MODULE_Visualization=OFF \
  -DBUILD_MODULE_ApplicationFramework=OFF \
  -DBUILD_MODULE_DETools=OFF \
  -DBUILD_MODULE_Draw=OFF \
  -DBUILD_DOC_Overview=OFF \
  -DBUILD_SAMPLES_QT=OFF \
  -DUSE_TK=OFF -DUSE_TCL=OFF -DUSE_FREETYPE=OFF -DUSE_FREEIMAGE=OFF \
  -DUSE_OPENGL=OFF -DUSE_GLES2=OFF -DUSE_XLIB=OFF -DUSE_D3D=OFF \
  -DUSE_VTK=OFF -DUSE_TBB=OFF -DUSE_RAPIDJSON=OFF -DUSE_DRACO=OFF \
  -DUSE_FFMPEG=OFF -DUSE_OPENVR=OFF -DUSE_EIGEN=OFF \
  -DINSTALL_TEST_CASES=OFF -DINSTALL_SAMPLES=OFF \
  ${platform_args[@]+"${platform_args[@]}"}
cmake --build "$BUILD" --parallel "$JOBS"
cmake --install "$BUILD"
end=$(date +%s)

# Licence texts travel with every install (needed for the notices screen and relink kit).
cp "$SRC/LICENSE_LGPL_21.txt" "$SRC/OCCT_LGPL_EXCEPTION.txt" "$PREFIX/"
touch "$PREFIX/.handcad-occt-$OCCT_COMMIT"
echo "OCCT $OCCT_VERSION ($PLATFORM) built in $((end - start)) s -> $PREFIX"

if [[ "${KEEP_OCCT_BUILD:-0}" != "1" ]]; then
  rm -rf "$BUILD"
fi
