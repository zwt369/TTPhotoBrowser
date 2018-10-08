

Pod::Spec.new do |s|
  s.name         = "TTPhotoBrowser"
  s.version      = "0.0.2"
  s.summary      = "一款仿微信的轻量级图片浏览器"

  s.description  = <<-DESC
                    一款仿微信的轻量级图片浏览器
                   DESC
  s.homepage     = "https://github.com/zwt369"
  s.license      = "MIT"
  s.author             = { "Tony" => "369388828@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zwt369/TTPhotoBrowser.git", :tag => "0.0.2" }

  s.source_files  = "TTPhotoBrowser/TTPhotoBrowser/Classess/**/**/*.{h,m}"
 # s.source_files = 'YYText/**/*.{h,m}'
  s.public_header_files = 'TTPhotoBrowser/TTPhotoBrowser/Classess/**/*.{h}'
 # s.exclude_files = "Classes/Exclude"
 # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"

  s.requires_arc = true
  s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SRCROOT)/SDWebImage" }
  s.dependency "SDWebImage"

end
