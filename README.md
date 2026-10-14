# Standalone PHP formatter for Zed

This project uses the compiled Mago formatter and does not require PHP, Composer, Docker, Rust, or Node at runtime. The macOS Apple Silicon executable is included. Linux and Windows users can install the matching official Mago binary with the scripts in `bin/`.

Mago formats PHP using its PSR-12 preset, with table-style alignment for array key/value pairs and alignment for consecutive assignments enabled in `mago.toml`.

## Zed setup

The macOS configuration is in `.zed/settings.json`. Linux users can copy `.zed/settings.linux.example.json` to `.zed/settings.json`; Windows users can copy `.zed/settings.windows.example.json`. Replace the example path with the absolute path to this project. Zed passes the buffer contents to the wrapper on stdin, and the wrapper prints formatted code to stdout.

Install the native Mago executable before formatting:

```sh
# Linux x86_64 or ARM64
sh bin/install-mago-linux.sh
```

```powershell
# Windows x86_64, from PowerShell in this project directory
powershell -ExecutionPolicy Bypass -File .\bin\install-mago-windows.ps1
```

## Run from a terminal

```sh
printf '<?php\n$short=1;\n$longer=2;\n' | sh bin/zed-php-format sample.php
```

To format a file in place, use:

```sh
.tools/mago format path/to/file.php
```

## Platform

The included `.tools/mago` executable is the official Mago 1.53.0 release for `aarch64-apple-darwin`. The Linux installer supports x86_64 and ARM64 GNU/Linux and installs to `.tools/linux/mago`. The Windows installer supports x86_64 and installs to `.tools/windows/mago.exe`. Downloads come from the official [Mago releases](https://github.com/carthage-software/mago/releases). Mago is open source under the MIT or Apache 2.0 license; the license texts are in `.tools/`.

## Configuration

Edit `mago.toml` to change the formatter preset or alignment behavior. Mago's `align-assignment-like` option aligns consecutive assignments and multi-line array pairs; `array-table-style-alignment` controls table-style alignment in arrays.
