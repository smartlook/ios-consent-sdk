# SmartlookConsentSDK for iOS

Getting explicit user consent with gathering analytics data in an app, or with processing the user’s personal data, is an important part of establishing user trust and seamless user experience.

It is also an obligation of an app developer stated in [App Store Guidelines](https://developer.apple.com/app-store/review/guidelines/) (2.5.14 and 5.1.2), necessary to fulfil to get your app approved for distribution.

Per the guidelines, if an app uses a 3rd party tool for analytics, it is the sole responsibility of the app developer, not of the 3rd party tool provider, to verify that the analytics tool does not register events in the app without user explicit consent.

Although implementing a simple dialog to obtain user consents and store them for further reference seems like a straightforward process — digging into it reveals (as it is usual with “simple tasks”) that many programming and design details should be respected. 

Since implementing the consent goes beyond core functionality and the intended design of the app, it is likely that this consent necessity will bring further annoyances, impact time and disrupt existing developing processes. 
So why not use or reuse some ready-made SDK?

The SmartlookConsentSDK:
- provides a configurable control panel where user can select their privacy options
- stores the selected user preferences for the app
- enables all texts to be fully localized 
- enables linking to privacy policies which may be provided by an external web page and presenting them without leaving the app

SmartlookConsentSDK works well with both Swift and Objective-C apps.

> Discuss the `ConsentSDK` directly on [Smartlook Discord server](https://discord.gg/SbEt98m).

&nbsp;
&nbsp;


  ![iPad Screenshot](https://github.com/smartlook/ios-consent-sdk/raw/master/readme-media/SmartlookConsentSDKDemo2.gif) &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  ![iPhone SettingsScreenshot](https://github.com/smartlook/ios-consent-sdk/raw/master/readme-media/ConsentSDK-Settings.png)  

## Code examples
### Simple example 
The most straightforward use that utilises default settings:
```swift
SmartlookConsentSDK.check() {
      if SmartlookConsentSDK.consent(for: .analytics) == .provided {
          // Start analytics tools
      }
}
```

This method first checks if the user already provided/rejected consent for both `privacy` and `analytics`. If not, the privacy control panel is shown with build-in defaults (consent is provided for both). When user agrees, the callback is called to let you handle the user preferences. 

In the case user previously went though these settings, the control panel is not show and the callback is called straight away.

### Complex example 

In this example, only consent for analytics is sought for with the consent provided by default.

```swift
var consentsSettingsDefaults = SmartlookConsentSDK.ConsentsSettings()
//consentsSettingsDefaults.append((.privacy, .notProvided)) 
consentsSettingsDefaults.append((.analytics, .provided))

SmartlookConsentSDK.check(with: consentsSettingsDefaults) {
    if SmartlookConsentSDK.consentState(for: .analytics) == .provided {
        // start analytics tools
    }
}
```

## Instalation

### Direct framework embedding
Framwork is ready for direct embedding in your app, e.g. the way it is embedded into the demo apps here. For detailed descriptions see this Apple Developer Portal document [Embedding Frameworks In An App](https://developer.apple.com/library/archive/technotes/tn2435/_index.html)

### Cocoapods
Add cocoapod `SmartlookConsentSDK` into your Podfile.

## Adding SmartlookConsentSDK to app code

Generally, you want `SmartlookConsentSDK.check()` be called at the very beginning of the app life-cycle. Where exactly, it depends on your app architecture. If you don't want integrate this SDK into the standard app Settings, then `viewDidLoad()` of the root view controller is enough. If you want more comprehensive solution, then see our demo apps `AppDelegate` and `ViewController` for an inpiration.

## Objective-C
The SDK is fully compatible with `Objective-C`. For code examples see the respective demo app.

## API

### Consent
Consent is identified by a string constant. For convenience, SDK provides a `String` alias with two predefined constants, `.privacy` a `.analytics` together with the respective text placeholders in demo app `Localizable.strings`. However, any string works, and the name convention used in `Localizable.strings` is obvious.

### ConsentState
Is a standard enumaration and indicates whether user seen and provided consent to a policy.
- `.unknown` state indicates that the user did not reviewed the policy
- `.notProvided` state indicates that the user explicitely refused consent to the policy
- `.provided` state indicates that the user explicitely provided consent to the policy 
```swift
@objc(SLCConsentState) public enum ConsentState: Int {
      case unknown = -2
      case notProvided = -1
      case provided = 1
}
```
### SmartlookConsentSDK.check()
Is the key method of the SDK. It comes in two versions:

```swift
@objc public static func check(callback: @escaping RequestIdCallback)
``` 
a straigth one w/out consents configuration that can be used when both `.privacy` and `.analytics` policies consents are required with `.provided` as the default value. 

```swift
public static func check(with consentsSettings: ConsentsSettings, callback: @escaping RequestIdCallback)
```  
a version with configuration that allows fine-tuning required consents (adding, removing, chaning order of or their default values) 

### SmartlookConsentSDK.show()
Two variants much like `check()`, it **always** opens the Control Panel for the user to review their current privacy settings.

### Content Touched Notification
Whenever user closes the panel opened by a call to `check()` or `show()`, `SmartlookConsentSDK.consentsTouchedNotification` notification is broadcased (regardless whether the consents were changed or not). This provides an alternative way to the `callback` block to let the app know there might be a change in consents.

In ObjC, the notification identifier is `SLCConsentsTouchedNotification`.

## Localisation
The texts shown in the control panel are configured using the standard `Localizable.strings` mechanism. `Localizable.strings`  are also used to provide an optional URL of a detailed policy information (thus the link is localised as well).

The keys used in the `Localizable.strings` are listed in the table below, or you can simply reuse [the file in our demo app](https://github.com/smartlook/ios-consent-sdk/raw/master/Consents%20Demo/ConsentsDemo/Base.lproj/Localizable.strings) .

Localization follows a name conventions. If a new consent type is added (on top of the predefined convenience types `.privacy` a `.analytics`), the respective keys must be added to localized files following the pattern

```
"smartlook-consent-sdk-*consent-key*-consent" = "My special consent...";
"smartlook-consent-sdk-*consent-key*-consent-url" = "https://www.my-company.com/consent-policy-details?lang=de"; //optional
```

where `*consent-key*` is simply the text string constant used to identify the policy.

## iOS Settings

The Consents SDK can be straigthforwardly integrated into the iOS Settings app so the user can also review their consents there. To do this, some manual work is needed even if the SDK is integrated using Cocoapods. If you are not familiar with adding system settings panel into your app, have a look at [Implementing an iOS Settings Bundle](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/UserDefaults/Preferences/Preferences.html) or just copy the `Settings.bundle` from one of our Demo apps to start.

The key for SDK integration here is using the same names for your settings items as you use for localised strings, i.e., in order to add the most basic consent settings to iOS settings:

1. Add `Settings.bundle` if it is not there
2. Into it, add a `Toggle Switch` for each consent.
3. To connect it with a consent, set the toggle identifier to the same string you use for it in `Localizable.strings`, e.g., `smartlook-consent-sdk-analytics-consent`
4. Do not forget that `Settings.bundle` localisation is separated from the app localisation (the respective `.strings` file is inside the `Settings.bundle`, in the demo apps it is named `Root.strings`) 
