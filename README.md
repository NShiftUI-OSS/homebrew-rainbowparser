# homebrew-tap

Private Homebrew tap for **tcc-nshiftui** tools.

## Prerequisites

- [Homebrew](https://brew.sh)
- Access to the private GitLab group `tcc-nshiftui` (SSH key recommended)
- Cursor and/or VS Code with the shell CLI on `PATH` (`cursor` / `code`) — only needed for editor install

Confirm GitLab SSH works:

```bash
ssh -T git@gitlab.com
```

You should see a welcome message. If you get `Permission denied (publickey)` or `no such identity`, fix `~/.ssh/config` so `Host gitlab.com` points at an existing key that is registered in GitLab.

## First-time install

Run these once on each machine:

```bash
# 1) Register the private tap (one-time)
brew tap tcc-nshiftui/tap git@gitlab.com:tcc-nshiftui/global/homebrew-tap.git

# 2) Trust the tap (required on Homebrew 6+)
brew trust tcc-nshiftui/tap

# 3) Install Rainbow (CLI + LSP + VSIX; builds from source the first time)
brew install rainbow

# 4) Install the editor extension + write rainbow.lsp.path
rainbow install cursor    # or: vscode | both | rainbow install
```

Then in Cursor / VS Code:

1. Command Palette → **Developer: Reload Window**
2. Open a `.rbw` file

Notes:

- Step 1 (`brew tap`) is **one-time**. Do not repeat it on every install.
- Step 2 (`brew trust`) is also **one-time** per machine (Homebrew 6 refuses untrusted third-party taps).
- Step 3 can take several minutes the first time (`rust` + `node` are build dependencies).
- `rainbow install` packs the extension from Homebrew `share/rainbow/` and configures `"rainbow.lsp.path"` in the editor user settings. Use `--no-settings` to skip writing settings.

### Verify

```bash
brew tap | grep tcc-nshiftui
which rainbow rainbow-lsp
rainbow --version
rainbow doctor
rainbow install --list
```

## Update

When there is a new Rainbow release / formula change:

```bash
brew update
brew upgrade rainbow
rainbow install cursor    # reinstall extension if the VSIX changed (or: vscode | both)
```

Reload the editor window after upgrading.

If the tap is already trusted and tapped, you do **not** need `brew tap` or `brew trust` again.

## What `brew install rainbow` gives you

| Artifact | Role |
|----------|------|
| `rainbow` | CLI — `parse` / `format` / `validate` / `install` |
| `rainbow-lsp` | Language Server for VS Code / Cursor |
| `share/rainbow/*.vsix` | Prebuilt editor extension package |

Source: [`rainbowparser-rust`](https://gitlab.com/tcc-nshiftui/global/rainbowparser-rust).

## Editor commands

```bash
rainbow install            # interactive if both CLIs exist
rainbow install cursor
rainbow install vscode
rainbow install both
rainbow install --list
rainbow install --no-settings cursor
```

### Private GitLab VSIX fallback (optional)

If the VSIX is missing from Homebrew `share/`, `rainbow install` can download it from the GitLab Generic Package Registry:

```bash
export GITLAB_TOKEN="<personal-access-token with read_api>"
rainbow install cursor
```

Create a PAT at GitLab → Preferences → Access Tokens (`read_api` is enough).

## Troubleshooting

| Error | Fix |
|-------|-----|
| `Permission denied (publickey)` / `no such identity` | Fix SSH key path in `~/.ssh/config` for `Host gitlab.com`, then `ssh -T git@gitlab.com` |
| `Refusing to load formula … from untrusted tap` | `brew trust tcc-nshiftui/tap` then `brew install rainbow` |
| `No available formula with the name "rainbow"` | Tap failed or was not trusted; re-run first-time steps 1–2 |
| Neither Cursor nor VS Code CLI found | Install shell command from the editor Command Palette (`Install 'cursor'/'code' command`) |
| Extension loads but no underlines / empty "Rainbow Language Server" output | Reinstall so the VSIX includes `vscode-languageclient`: `brew reinstall rainbow && rainbow install vscode` then Reload Window |
| `brew upgrade rainbow` does nothing | Same formula version — use `brew reinstall rainbow` to rebuild from the latest branch commit |

## Adding more tools to this tap

This repo is the org catalog. Options:

1. **Same formula `rainbow`** — add another crate/binary to `Formula/rainbow.rb`. Users still run `brew install rainbow`.
2. **New formula** — add `Formula/outra-ferramenta.rb` and install with `brew install outra-ferramenta` (may also need `brew trust`).

## Layout

```text
Formula/
  rainbow.rb    # brew install rainbow
```

## Development notes

- Formula tracks branch `release/0.1.0-beta.1` of `rainbowparser-rust`.
- For latest `main`: `brew install --HEAD rainbow`
- After publishing a git tag on `rainbowparser-rust`, prefer switching the formula `url` to `tag:` + `revision:` for reproducible installs.
