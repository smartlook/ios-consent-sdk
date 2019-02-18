//
//  ViewController.m
//  ConsentSDKDemoObjC
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

#import "ViewController.h"
#import <ConsentSDK/ConsentSDK.h>

@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //if (!PrivacyControlPanel.wasShown) {
        [self showPrivacyControlPanel];
    //}
}

- (void)showPrivacyControlPanel {
    // which policies consents are asked for, and default consent values
    NSMutableDictionary *privacyControlPanelSettings = [NSMutableDictionary new];
    
    [privacyControlPanelSettings setObject:@(CSDKConsentStateProvided) forKey:@(CSDKConsentPrivacy)];
    
    [ConsentSDK showWithConsents:privacyControlPanelSettings callback:^{
        NSLog(@"privacy consent: %ld", (long)[ConsentSDK consentFor:CSDKConsentPrivacy]);
        NSLog(@"analytics conset: %ld", (long)[ConsentSDK consentFor:CSDKConsentAnalytics]);
        if ([ConsentSDK consentFor:CSDKConsentPrivacy] == CSDKConsentStateProvided) {
            NSLog(@"Consent provided");
        }
    }];
    
    //        var privacyControlPanelSettings = PrivacyControlPanelSetting()
    //        privacyControlPanelSettings[.privacy] = .notProvided
    //        privacyControlPanelSettings[.analytics] = .provided
    //
    //        PrivacyControlPanel.show(for: privacyControlPanelSettings) {
    //            // here, read the current values from PrivacyControlPanel and act accordingly
    //            self.updateConsentIndicators()
    //        }
}

@end
