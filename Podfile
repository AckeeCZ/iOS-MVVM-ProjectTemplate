project_name='ProjectTemplate'

platform :ios, '10.3'
project project_name, 'Beta-Development' => :release, 'Beta-Stage' => :release, 'Beta-Production' => :release, 'Release' => :release, 'Development' => :debug

inhibit_all_warnings!
use_frameworks!

workspace project_name + '.xcworkspace'

target project_name do
    project project_name + '.xcodeproj'
    pod 'SwiftLint', '~> 0.27'
    
    pod 'SwiftGen', '~> 6.3'
    pod 'Smartling.i18n', '~> 1.0'
    pod 'LicensePlist', '~> 2.14'
    
    target 'ProjectTemplateTests' do
        inherit! :complete
    end
end

target 'Localization' do
    project 'Localization/Localization.xcodeproj'
    pod 'ACKLocalization', '~> 1.1'
end
