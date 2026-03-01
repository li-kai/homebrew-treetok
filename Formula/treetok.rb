class Treetok < Formula
  desc "Display directory trees with LLM token counts"
  homepage "https://github.com/li-kai/treetok"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.5/treetok-aarch64-apple-darwin.tar.xz"
      sha256 "c1e48c50c8ef111a3d5edf672ecd35fa1ed53306582eb386945cb3b2d3a7f1b7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.5/treetok-x86_64-apple-darwin.tar.xz"
      sha256 "7f694c9189ebbc50b485d5c22b493e6b6ee7ff223ad500abe1d5d56d08432951"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.5/treetok-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb5a2382bc0a69c1c8bb6a18c2630e4c83d75f716a1c9a2345fe5d2e47b5889a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/li-kai/treetok/releases/download/v0.1.5/treetok-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53f943c158563ff199ca55e771d3a3ee6e56252c312a20554ace2758e8149640"
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
