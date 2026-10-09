cask "macmonitor" do
  version "0.1.2"
  sha256 "f8d5f0c9d6d80e466e6d6b0fe62af53d2154c195d61b205229a2db8a48d2f305"

  url "https://github.com/renpengkai/macmonitor/releases/download/v#{version}/MacMonitor-#{version}.zip"
  name "MacMonitor"
  desc "Tiny menu bar monitor for CPU, memory, power, temperature and fans"
  homepage "https://github.com/renpengkai/macmonitor"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "MacMonitor.app"

  # 未公证的 ad-hoc 签名包, 去掉隔离属性后才能直接打开
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/MacMonitor.app"]
  end

  # 先退出应用 (退出时会把风扇恢复为自动), 再删除 setuid 的风扇控制组件
  uninstall quit:   "io.github.renpengkai.macmonitor",
            delete: "/Library/PrivilegedHelperTools/io.github.renpengkai.macmonitor.fanctl"

  zap trash: "~/Library/Preferences/io.github.renpengkai.macmonitor.plist"

  caveats <<~EOS
    MacMonitor 是菜单栏应用, 启动后在屏幕右上角查看。

    风扇控制需要在面板中点「启用风扇控制」, 输入管理员密码安装 setuid 组件:
      /Library/PrivilegedHelperTools/io.github.renpengkai.macmonitor.fanctl
    卸载 cask 时会一并删除该组件。
  EOS
end
