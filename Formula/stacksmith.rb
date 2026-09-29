# Rendered by `fastlane mac cli_release`. Do not edit the copy in the tap by
# hand; change this template instead.
class Stacksmith < Formula
  desc "Run and inspect local development stacks defined in .stacksmith.yml"
  homepage "https://getstacksmith.app/"
  url "https://github.com/getstacksmith/stacksmith-releases/releases/download/cli-v0.1.0/stacksmith-0.1.0-macos-arm64.tar.gz"
  version "0.1.0"
  sha256 "a7147d56a326fc8f40bd4af2053fb9a0f88f33fcc9a7f4095fa134598a343e59"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  def install
    bin.install "stacksmith"
    generate_completions_from_executable(bin/"stacksmith", "--generate-completion-script")
  end

  def caveats
    <<~EOS
      Stacks run in a background daemon that starts on first use and exits
      when nothing is running.

      After an upgrade, an idle daemon is replaced automatically. If a stack
      was running, run `stacksmith daemon restart` when convenient; it stops
      running stacks.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stacksmith --version")
    (testpath/".stacksmith.yml").write <<~YAML
      version: 1
      name: Formula Test
      workers:
        worker:
          command: sleep 1
    YAML
    system bin/"stacksmith", "validate"
  end
end
