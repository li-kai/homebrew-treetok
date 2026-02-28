class Treetok < Formula
  desc "Display directory trees with LLM token counts"
  homepage "https://github.com/li-kai/treetok"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.2/treetok-aarch64-apple-darwin.tar.xz"
      sha256 "7e1b265112d709715cd9306949cecccd411a4e2fa79a2c01e30a79d2da3c9723"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.2/treetok-x86_64-apple-darwin.tar.xz"
      sha256 "d2f5f39b2c329aaa1b49cfac194952d64dd42eeb9814109237ae3566a07769c0"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.2/treetok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4ab8c82dccd740f380d4606269247516c3b19ef2404080bb41b6ccc04f6f1576"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.2/treetok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6fe8d6f6e237cb09dc7df61a7cb9b0c9866e261a3cdaa7d74c8e4ef8eaee7c2a"
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
