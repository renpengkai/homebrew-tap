cask "smoothscroll" do
  version "0.2.0"
  sha256 "df230845fc7dbe4b9ba6dccd69de0800c8b0e6934d534123082f762fba4fe535"

  url "https://github.com/renpengkai/smooth-scroll-mac/releases/download/v#{version}/SmoothScroll-#{version}.zip"
  name "SmoothScroll"
  desc "Tiny menu bar app for smooth mouse wheel scrolling (algorithm adapted from Mos)"
  homepage "https://github.com/renpengkai/smooth-scroll-mac"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "SmoothScroll.app"

  # 未公证的 ad-hoc 签名包, 去掉隔离属性后才能直接打开
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/SmoothScroll.app"]
  end

  uninstall quit: "io.github.renpengkai.smoothscroll"

  zap trash: "~/Library/Preferences/io.github.renpengkai.smoothscroll.plist"

  caveats <<~EOS
    SmoothScroll 需要「辅助功能」权限:
      系统设置 → 隐私与安全性 → 辅助功能 → 勾选 SmoothScroll

    每次升级后旧授权会失效 (ad-hoc 签名), 需在该列表中删除旧条目后重新勾选。
    如果同时装了 Mos, 请先退出 Mos, 避免两边叠加平滑。
  EOS
end
