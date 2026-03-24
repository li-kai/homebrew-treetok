class Treetok < Formula
  desc "Display directory trees with LLM token counts"
  homepage "https://github.com/li-kai/treetok"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.6/treetok-aarch64-apple-darwin.tar.xz"
      sha256 "a9957e346257e4f72b2c58cf98560677425113366fcfe6f4132c2a58635ca251"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.6/treetok-x86_64-apple-darwin.tar.xz"
      sha256 "455f25ea055621fb42d9aba3b55c2493efa0847563d94098e9b8eb35e2df1776"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.6/treetok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "87e9cc2a3f96187aa79f314822efd065213369e888b01adf56e2eeb2ec93be1d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.6/treetok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "af7d7dfb10abd3d0214c1ca0d1d715dd3c9249e7a85ea77efa798750857bcabf"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "treetok" if OS.mac? && Hardware::CPU.arm?
    bin.install "treetok" if OS.mac? && Hardware::CPU.intel?
    bin.install "treetok" if OS.linux? && Hardware::CPU.arm?
    bin.install "treetok" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
