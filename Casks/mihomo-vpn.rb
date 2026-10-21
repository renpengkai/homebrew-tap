cask "mihomo-vpn" do
  version "0.1.2"
  sha256 "98e465174e4e408753a246c5f424eef6fb3fea5f8dc22431b24ef4904a7b0ba9"

  url "https://github.com/renpengkai/MihomoVPN/releases/download/v#{version}/MihomoVPN-#{version}.zip"
  name "Mihomo VPN"
  desc "Lightweight macOS Mihomo (Clash Meta) client with Liquid Glass UI"
  homepage "https://github.com/renpengkai/MihomoVPN"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: ">= :ventura"

  app "MihomoVPN.app"

  # 未公证的 ad-hoc 签名包, 去掉隔离属性后才能直接打开
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/MihomoVPN.app"]
  end

  uninstall quit:   "io.github.renpengkai.mihomovpn",
            delete: [
              "/Library/PrivilegedHelperTools/io.github.renpengkai.mihomovpn.helper",
              "/Library/PrivilegedHelperTools/io.github.renpengkai.mihomovpn.core",
            ]

  zap trash: [
    "~/Library/Application Support/MihomoVPN",
    "~/Library/Preferences/io.github.renpengkai.mihomovpn.plist",
  ]

  caveats <<~EOS
    Mihomo VPN 是菜单栏应用, 启动后在屏幕右上角操作。

    TUN 模式需在「设置 → 特权组件」中安装一次 (会请求管理员密码)。
  EOS
end
