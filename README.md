# Homebrew tap for Rainbow

This public tap builds the Rainbow 1.0.0 CLI, language server and editor extension from [RainbowParser-Rust](https://github.com/NShiftUI-OSS/RainbowParser-Rust). The formula pins the source snapshot that downloads NShiftUI-Demo `v1.0.0`.

## Install

```bash
brew tap NShiftUI-OSS/rainbowparser
brew trust NShiftUI-OSS/rainbowparser
brew install rainbow
rainbow --version
rainbow doctor
```

Homebrew 6 requires trusting the tap. Rust and Node are build dependencies. The VSIX is installed in `$(brew --prefix rainbow)/share/rainbow/`.

## Use the editor extension

```bash
rainbow install cursor
```

Use `vscode` or `both` to select other supported editors. The CLI configures `rainbow.lsp.path` and the Rainbow formatter. Reload the editor, then open a `.rbw` file.

## Download the demo

```bash
rainbow demo
```

The command downloads the [NShiftUI-Demo 1.0.0 archive](https://github.com/NShiftUI-OSS/NShiftUI-Demo/archive/refs/tags/v1.0.0.tar.gz). See the [demo README](https://github.com/NShiftUI-OSS/NShiftUI-Demo) for setup and the [documentation site](https://nshiftui-oss.github.io/NShiftUI-Landing/) for Rainbow and SDK reference.

## Update

```bash
brew update
brew upgrade rainbow
rainbow install cursor
```
