//
//  AppDelegate.m
//  ConsentSDKDemoObjC
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

#import "AppDelegate.h"
#import <SmartlookConsentSDK/SmartlookConsentSDK.h>

@implementation AppDelegate

// MARK: - Consent check

/** This method is to be invoked any time the app starts to check if the consents are provided
 namely in:
 - `application:didFinishWithLaunchingOptions` for the fresh start
 - `application:WillEnterForeground` for app woken up from background (where possibly the consent
 setting could be changed in system settings)
 */
- (void)checkConsentStates {
    NSMutableArray *consentsSettingsDefaults = [NSMutableArray new];
    [consentsSettingsDefaults addObjectsFromArray:@[SLCConsentPrivacy, @(SLCConsentStateProvided)]];
    [consentsSettingsDefaults addObjectsFromArray:@[SLCConsentAnalytics, @(SLCConsentStateNotProvided)]];
    
    [SmartlookConsentSDK checkWith:consentsSettingsDefaults callback:^{
        if ([SmartlookConsentSDK consentStateFor:SLCConsentAnalytics] == SLCConsentStateProvided) {
            // start analytics tools
        };
    }];
}


// MARK: - Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self checkConsentStates];
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [self checkConsentStates];
}


@end
