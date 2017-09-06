platform :ios, '10.0'
use_frameworks!

# ignore all warnings from all pods
inhibit_all_warnings!

target 'Gasoline' do
    use_frameworks!
    pod 'SHDateFormatter'
    pod 'SwiftLint'
    pod 'Fabric'
    pod 'Crashlytics'

    target 'GasolineTests' do
        inherit! :search_paths
        pod 'Quick'
        pod 'Nimble'
    end

    target 'GasolineUITests' do
        inherit! :search_paths
    end
end

post_install do |options|
    options.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.2'
        end
    end
end
