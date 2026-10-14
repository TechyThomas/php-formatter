#!/bin/sh
set -eu

version=1.53.0
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
tools="$root/.tools/linux"
machine=$(uname -m)

case "$machine" in
    x86_64|amd64) target=x86_64-unknown-linux-gnu ;;
    aarch64|arm64) target=aarch64-unknown-linux-gnu ;;
    *) printf 'Unsupported Linux architecture: %s\n' "$machine" >&2; exit 1 ;;
esac

archive="mago-$version-$target.tar.gz"
url="https://github.com/carthage-software/mago/releases/download/$version/$archive"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

if command -v curl >/dev/null 2>&1; then
    curl -fL "$url" -o "$tmp/$archive"
elif command -v wget >/dev/null 2>&1; then
    wget -O "$tmp/$archive" "$url"
else
    printf '%s\n' 'Install curl or wget to download Mago.' >&2
    exit 1
fi

tar -xzf "$tmp/$archive" -C "$tmp"
binary=$(find "$tmp" -type f -name mago -print -quit)
if [ -z "$binary" ]; then
    printf '%s\n' 'The Mago release archive did not contain the expected binary.' >&2
    exit 1
fi
mkdir -p "$tools"
install -m 755 "$binary" "$tools/mago"
printf 'Installed Mago %s for %s at %s\n' "$version" "$target" "$tools/mago"
