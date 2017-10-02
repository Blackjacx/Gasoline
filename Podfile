platform :ios, '10.0'
use_frameworks!

target 'Gasoline' do
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

target 'Core' do
    target 'CoreTests' do
        inherit! :search_paths
        pod 'Quick'
        pod 'Nimble'
    end
end

