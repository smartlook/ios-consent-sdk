//
//  ViewController.m
//  ConsentSDKDemoObjC
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

#import "ViewController.h"
#import <SmartlookConsentSDK/SmartlookConsentSDK.h>

@interface ViewController ();

@property (weak, nonatomic) IBOutlet UIView *consentsPanelWasShownIndicator;
@property (weak, nonatomic) IBOutlet UIView *privacyConsentIndicator;
@property (weak, nonatomic) IBOutlet UIView *analyticsConsentIndicator;

@end

@implementation ViewController

// MARK: - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _privacyConsentIndicator.layer.cornerRadius = 3;
    _analyticsConsentIndicator.layer.cornerRadius = 3;
    
    // This is not necessary if all the logic is handled in the `SmartlookConsentSDK.check`
    // or `SmartlookConsentSDK.show` callbacks may be usefully eg.,
    // if some UI depends on the consents state like here.
    [[NSNotificationCenter defaultCenter] addObserverForName:SLCConsentsTouchedNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self updateConsentIndicators];
    }];
    
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = UIColor.systemBackgroundColor;
    } else {
        self.view.backgroundColor = UIColor.whiteColor;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateConsentIndicators];
}


// MARK: - Consent state visualization

- (UIColor *)colorForState:(SLCConsentState)state {
    switch (state) {
        case SLCConsentStateUnknown:
            return [UIColor lightGrayColor];
            break;
        case SLCConsentStateNotProvided:
            return [UIColor redColor];
            break;
        case SLCConsentStateProvided:
            return [UIColor greenColor];
            break;
    }
}

-(void)updateConsentIndicators {
    self.consentsPanelWasShownIndicator.backgroundColor = SmartlookConsentSDK.wasShown ? [UIColor greenColor] : [UIColor grayColor];
    self.privacyConsentIndicator.backgroundColor = [self colorForState:[SmartlookConsentSDK consentStateFor:SLCConsentPrivacy]];
    self.analyticsConsentIndicator.backgroundColor = [self colorForState:[SmartlookConsentSDK consentStateFor:SLCConsentAnalytics]];
}


// MARK: - UI Actions

- (IBAction)buttonAction:(id)sender {
    // let user review or check the consents
    [SmartlookConsentSDK showWithCallback:^{
        [self updateConsentIndicators];
        if ([SmartlookConsentSDK consentStateFor:SLCConsentAnalytics] != SLCConsentStateProvided) {
            // stop analytics tools
        };
    }];
}

- (IBAction)showAppSettingsAction:(id)sender {
    NSURL *settingsUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:settingsUrl]) {
        [[UIApplication sharedApplication] openURL:settingsUrl options:@{} completionHandler:nil];
    }

}


@end
