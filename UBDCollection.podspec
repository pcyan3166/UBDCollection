#
# Be sure to run `pod lib lint UBDCollection.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'UBDCollection'
  s.version          = '0.1.0'
  s.summary          = 'UBDCollection 提供 iOS 平台收集和分析用户信息的一系列辅助接口和分析页面'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'UBDCollection 提供 iOS 平台收集和分析用户信息的一系列辅助接口和分析页面，\
                        帮助开发人员快速开发出友好的分析用户行为的界面 \
                        UBD 全称：user behavior data'

  s.homepage         = 'https://github.com/pcyan3166/UBDCollection'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pcyan' => 'yanpengchao@hotmail.com' }
  s.source           = { :git => 'https://github.com/pcyan3166/UBDCollection.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'UBDCollection/Classes/**/*'
  
  # s.resource_bundles = {
  #   'UBDCollection' => ['UBDCollection/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'Foundation'
#  s.library = 'xml2'
  s.dependency 'FMDB'
  s.dependency 'AFNetworking', '~> 4.0'
  s.dependency 'BasicTools'
end
