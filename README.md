# Standalone PHP formatter for Zed

This project bundles the compiled Mago formatter for macOS Apple Silicon. It does not require PHP, Composer, Docker, Rust, or Node at runtime.

Mago formats PHP using its PSR-12 preset, with table-style alignment for array key/value pairs and alignment for consecutive assignments enabled in `mago.toml`.

## Zed setup

The formatter is already configured in `.zed/settings.json`. If you move this directory, update the command path there. Zed passes the buffer path to the wrapper; the wrapper passes the buffer contents to Mago over stdin and prints the formatted result to stdout.

## Run from a terminal

```sh
printf '<?php\n$short=1;\n$longer=2;\n' | sh bin/zed-php-format sample.php
```

To format a file in place, use:

```sh
.tools/mago format path/to/file.php
```

## Platform

The bundled `.tools/mago` executable is the official Mago 1.53.0 release for `aarch64-apple-darwin`. Other operating systems and CPU architectures need their matching Mago release binary. Mago is open source under the MIT or Apache 2.0 license; the license texts are in `.tools/`.

## Configuration

Edit `mago.toml` to change the formatter preset or alignment behavior. Mago's `align-assignment-like` option aligns consecutive assignments and multi-line array pairs; `array-table-style-alignment` controls table-style alignment in arrays.
