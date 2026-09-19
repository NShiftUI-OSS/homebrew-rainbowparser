# frozen_string_literal: true

class Rainbow < Formula
  desc "DSL toolchain for SDUI (CLI, Language Server, and editor extension)"
  homepage "https://gitlab.com/tcc-nshiftui/global/rainbowparser-rust"
  url "https://gitlab.com/tcc-nshiftui/global/rainbowparser-rust.git",
      branch: "release/0.1.0-beta.1"
  version "0.1.0-beta.1"
  license "MIT"

  head "https://gitlab.com/tcc-nshiftui/global/rainbowparser-rust.git",
       branch: "main"

  depends_on "node" => :build
  depends_on "rust" => :build

  # Single formula on purpose: keep `brew install rainbow` stable while adding
  # more binaries / shared assets from the Rainbow workspace over time.
  def install
    system "cargo", "install", *std_cargo_args(path: "crates/rainbow-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/rainbow-lsp")

    cd "editors/vscode-rainbow" do
      system "npm", "ci"
      system "npm", "run", "compile"
      system "npx", "vsce", "package", "--skip-license"
      (share/"rainbow").install Dir["*.vsix"]
    end
  end

  def caveats
    <<~EOS
      Installed binaries:

        rainbow       CLI — parse / format / validate / install
        rainbow-lsp   Language Server for VS Code / Cursor

      Editor extension (VSIX) was packed to:

        #{opt_share}/rainbow/

      Install into Cursor or VS Code (writes rainbow.lsp.path and
      [rainbow] defaultFormatter for Format Document):

        rainbow install
        rainbow install cursor
        rainbow install vscode
        rainbow install both

      Check the environment:

        rainbow doctor

      Then Developer: Reload Window and open a .rbw file.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rainbow --version")
    assert_match "Compatible IDEs", shell_output("#{bin}/rainbow install --list")
    (testpath/"ok.rbw").write 'Button(title: "Hi")'
    system bin/"rainbow", "validate", testpath/"ok.rbw"
    assert_path_exists share/"rainbow"
  end
end
