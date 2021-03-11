Pod::Spec.new do |s|
  s.name             = 'WZPagerView'
  s.version          = '1.0.5'
  s.summary          = '分页上下左右滚动组件 '
  s.description      = <<-DESC
分页上下左右滚动组件.
                       DESC
  s.homepage         = 'https://github.com/WZLYiOS/WZPagerView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LiuSky' => '327847390@qq.com' }
  s.source           = { :git => 'https://github.com/WZLYiOS/WZPagerView.git', :tag => s.version.to_s }

  
  s.requires_arc = true
  s.static_framework = true
  s.swift_version         = '5.0'
  s.ios.deployment_target = '9.0'
  s.default_subspec = 'Source'
  
  s.subspec 'Source' do |ss|
    ss.source_files = 'WZPagerView/Classes/*.{h,m}'
  end


  #s.subspec 'Binary' do |ss|
   # ss.vendored_frameworks = "Carthage/Build/iOS/Static/WZPagerView.framework"
  #end
end
