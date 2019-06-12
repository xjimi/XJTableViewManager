Pod::Spec.new do |s|

  s.name          = "XJTableViewManager"
  s.version       = "0.1.3"
  s.summary       = "Easy to use UITableView"
  s.homepage      = "https://github.com/xjimi/XJTableViewManager"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "XJIMI" => "fn5128@gmail.com" }
  s.source        = { :git => "https://github.com/xjimi/XJTableViewManager.git", :tag => s.version }
  s.source_files  = "XJTableViewManager", "XJTableViewManager/**/*.{h,m}"
  s.requires_arc  = true
  s.frameworks    = 'Foundation', 'UIKit'
  s.ios.deployment_target = '9.0'

end
