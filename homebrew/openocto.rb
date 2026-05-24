# frozen_string_literal: true

class Openocto < Formula
  desc "Command-line interface for AI models with autonomous agent capabilities"
  homepage "https://github.com/octo-ai/octo"
  url "https://rubygems.org/downloads/octo-0.6.1.gem"
  sha256 "" # Will be updated when gem is published
  license "MIT"

  depends_on "ruby@3.3"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "install", cached_download, "--no-document"
    
    # Create wrapper scripts
    (bin/"octo").write_env_script libexec/"bin/octo", GEM_HOME: ENV["GEM_HOME"]
    (bin/"octo").write_env_script libexec/"bin/octo", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    assert_match "octo version #{version}", shell_output("#{bin}/octo version")
  end
end
