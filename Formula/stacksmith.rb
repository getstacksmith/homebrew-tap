# Rendered by `fastlane mac cli_release`. Do not edit the copy in the tap by
# hand; change this template instead.
class Stacksmith < Formula
  desc "Run and inspect local development stacks defined in .stacksmith.yml"
  homepage "https://getstacksmith.app/"
  url "https://github.com/getstacksmith/stacksmith-releases/releases/download/cli-v0.1.2/stacksmith-0.1.2-macos-arm64.tar.gz"
  version "0.1.2"
  sha256 "d98ca445b64ee47e633569784b55b49c1094282005f9530b2c1f118553f0ead4"

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
