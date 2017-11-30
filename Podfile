platform :ios, '8.1'

source 'https://github.com/CocoaPods/Specs.git'


target 'CLIDemo' do
  use_frameworks!

  # Network
  pod 'Moya'
  pod 'Moya/ReactiveSwift'

  # Reactive
  pod 'ReactiveCocoa'
  pod 'ReactiveSwift'
  
  # UI
  pod 'SnapKit'

  # Utils
  pod 'Unbox'

  # Linting
  pod 'SwiftLint'
  
  target 'CLIDemoTests' do
    inherit! :search_paths
    pod 'Nimble'
    pod 'Quick'
  end

end

swift3Targets = ['Moya', 'Moya/ReactiveSwift', 'ReactiveCocoa', 'ReactiveSwift']
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if swift3Targets.include? target.name
                config.build_settings['SWIFT_VERSION'] = '3.2'
                else
                config.build_settings['SWIFT_VERSION'] = '4'
            end
        end
    end
end

