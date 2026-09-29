cask "smoothscroll" do
  version "0.1.0"
  sha256 "7ddb5d1c387fe3a68da5936f321dc6a5756f3462162fa8ed4d47b5f335a4db66"

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

  # steps 块在独立 DSL 中求值, 取不到 appdir, 需在外面先算好路径
  installed_app = "#{appdir}/SmoothScroll.app"

  # 未公证的 ad-hoc 签名包, 去掉隔离属性后才能直接打开
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", installed_app]
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
