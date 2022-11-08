#
# Be sure to run `pod lib lint CalendarView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CalendarView'
  s.version          = '0.1.2'
  s.summary          = 'A CalendarView for iOS and macOS.'

  s.description      = 'A CalendarView made with UICollectionView that lets *you* define how it looks and feels.'

  s.homepage         = 'https://github.com/YuvarajIcon/CalendarView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Yuvaraj' => 'yuvaraj.australia@gmail.com' }
  s.source           = { :git => 'https://github.com/YuvarajIcon/CalendarView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'

  s.source_files = 'CalendarView/Classes/**/*'
  s.swift_versions = '4.0'
  # s.resource_bundles = {
  #   'CalendarView' => ['CalendarView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
