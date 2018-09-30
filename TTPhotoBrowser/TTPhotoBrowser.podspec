

Pod::Spec.new do |s|
  s.name         = "TTPhotoBrowser.podspec"
  s.version      = "0.0.1"
  s.summary      = "一款仿微信的轻量级图片浏览器"

  s.description  = <<-DESC
                    一款仿微信的轻量级图片浏览器
                   DESC
  s.homepage     = "https://github.com/zwt369"
  s.license      = "MIT"
  s.author             = { "Tony" => "369388828@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/zwt369/TTPhotoBrowser.git", :tag => "0.0.1" }

  s.source_files  = "TTPhotoBrowser/TTPhotoBrowser/Classes/**/**/*.{h,m}"
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

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
   s.dependency "SDWebImage"

end