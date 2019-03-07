# coding: utf-8

#
# Be sure to run `pod lib lint ABCPod.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'SmartlookConsentSDK'
s.version          = '1.1.0'
s.summary          = 'This SDK provides a configurable control panel where user selects her privacy options.'

# This description is used to generate tags and improve search results.
s.description      = <<-DESC
This SDK:

- provides a configurable control panel where user selects her privacy options
- stores the selected user preferences to be used in your app
- works both with Swift and Objective-C apps
- all texts are fully localizable
- privacy policies may be provided by an external web page that is presented w/out leaving the app (see localisation.)

Obtaining explicit user consent with gathering analytics data in an app, or with processing user’s personal data is important part of establishing user trust and seamless user experience.

It is also an obligation of an app developer stated in App Store Guidelines (2.5.14 and 5.1.2), necessary to fulfil in order to get your app approved for distribution. If your app e.g. uses a 3rd party tool for analytics, it is the sole responsibility of you as the app developer, not of the 3rd party tool provider, that the analytics tool does not start registering events in the app without user explicit consent.

Although implementing some dialog to obtain user consents and store them for further reference seems pretty straightforward, digging into it reveals (as usual with “simple tasks”) many programming and design details that must be implemented, which are not the core functionality of your app.
DESC

s.homepage         = 'https://github.com/smartlook/ios-consent-sdk/'
s.screenshots     =  ['https://sdk.smartlook.com/assets/SmartlookConsentSDKDemo2.gif', 'https://github.com/smartlook/ios-consent-sdk/raw/master/readme-media/ConsentSDK-Settings.png']
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Pavel Kroh' => 'pavelkroh@smartlook.com' }
s.source           = { :git => 'https://github.com/smartlook/ios-consent-sdk.git', :tag => s.version.to_s }
s.documentation_url = 'https://github.com/smartlook/ios-consent-sdk/'

s.ios.deployment_target = '10.0'

s.swift_version = '4.2'
s.source_files = 'SmartlookConsentSDK/SmartlookConsentSDK/*.{h,m,c,swift}'

s.resource_bundles = {
    'SmartlookConsentSDK' => ['SmartlookConsentSDK/SmartlookConsentSDK/**/*.{storyboard,xib}']
}

end
