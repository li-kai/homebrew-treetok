class Treetok < Formula
  desc "Display directory trees with LLM token counts"
  homepage "https://github.com/li-kai/treetok"
  version "0.1.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.7/treetok-aarch64-apple-darwin.tar.xz"
      sha256 "3c32953c38c491588984838b75a69921b7938ff46400ec5cc4362eff890237c6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.7/treetok-x86_64-apple-darwin.tar.xz"
      sha256 "138ab05798711621a1b56aee3ba1bdfa6aba693fe45a410d81eb595f243d3272"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.7/treetok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "37beec9c6e527c59b8e473b95b874154f22a653ac51d2c7da1c591999e3c069f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.7/treetok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1a4b0db3b00e550bc121c362f0dadbc633dbe3d1c5ad30465395f1fb4057d6f9"
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
