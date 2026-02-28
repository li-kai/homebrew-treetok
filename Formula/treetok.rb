class Treetok < Formula
  desc "Display directory trees with LLM token counts"
  homepage "https://github.com/li-kai/treetok"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.3/treetok-aarch64-apple-darwin.tar.xz"
      sha256 "7a0b4c49015fd3f43ee2577fb41dc57615a0e407786149dd3ab06b66aaa5eb38"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.3/treetok-x86_64-apple-darwin.tar.xz"
      sha256 "6ede0b7c73eedfbe2dc7a1c28566c84de545e3a928906c995bbe62ae872eb04a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.3/treetok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "799a3961429c6ea40ab4a87aab5173c4e99c54bf6f47557286df7349c9a8621c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.3/treetok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b9e4eec181dbe5640cbf45243726ea2e45cde959f2fc68fdef2ebc781e7b3b3e"
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
