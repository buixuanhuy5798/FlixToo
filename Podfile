# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'FLixToo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FLixToo
pod 'SnapKit'
pod 'Kingfisher', '~> 7.0'
pod 'Reusable'
pod 'Swinject', '2.7.1'
pod 'SwinjectStoryboard', '2.2.1'
pod 'SVProgressHUD'
pod 'Alamofire'
pod 'RxSwift'
pod 'RxCocoa'
pod 'SwiftKeychainWrapper'
pod 'MASegmentedControl'
pod 'Cosmos'
pod 'YouTubePlayer'
pod 'PanModal'
pod "ImageSlideshow/Kingfisher"
pod 'Google-Mobile-Ads-SDK'
pod 'IQKeyboardManagerSwift'
pod "ExpandableLabel"

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
    end
end
