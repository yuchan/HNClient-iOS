#
# Be sure to run `pod lib lint HNClient-iOS.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "HNClient-iOS"
  s.version          = "0.1.0"
  s.summary          = "HNClient-iOS."
  s.description      = <<-DESC
Hacker news api wrapper in Objective-C.                       
DESC
  s.homepage         = "https://github.com/yuchan/HNClient-iOS"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "yuchan" => "yusuke@junkpiano.me" }
  s.source           = { :git => "https://github.com/yuchan/HNClient-iOS.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'HNClient-iOS' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  #s.frameworks = 'Firebase'
  s.dependency 'Firebase', '~> 2.2.0'
  s.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '"${PODS_ROOT}/Firebase"' }
end
