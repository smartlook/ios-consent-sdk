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

@property (weak, nonatomic) IBOutlet UIView *consentsPanelWasShownIndicator;
@property (weak, nonatomic) IBOutlet UIView *privacyConsentIndicator;
@property (weak, nonatomic) IBOutlet UIView *analyticsConsentIndicator;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super viewDidLoad];
    
    //privacyConsentIndicator.layer.cornerRadius = 3
    //analyticsConsentIndicator.layer.cornerRadius = 3
    
    [self updateConsentIndicators];

    NSMutableArray *consentsSettingsDefaults = [NSMutableArray new];
    [consentsSettingsDefaults addObjectsFromArray:@[CSDKConsentPrivacy, @(CSDKConsentStateProvided)]];
    [consentsSettingsDefaults addObjectsFromArray:@[CSDKConsentAnalytics, @(CSDKConsentStateNotProvided)]];

    [ConsentSDK checkWith:consentsSettingsDefaults callback:^{
        [self updateConsentIndicators];
        if ([ConsentSDK consentStateFor:CSDKConsentAnalytics] == CSDKConsentStateProvided) {
            // start analytics tools
        };
    }];
}

- (UIColor *)colourForState:(CSDKConsentState)state {
    switch (state) {
        case CSDKConsentStateUnknown:
            return [UIColor lightGrayColor];
            break;
        case CSDKConsentStateNotProvided:
            return [UIColor redColor];
            break;
        case CSDKConsentStateProvided:
            return [UIColor greenColor];
            break;
    }
}

-(void)updateConsentIndicators {
    self.consentsPanelWasShownIndicator.backgroundColor = ConsentSDK.wasShown ? [UIColor greenColor] : [UIColor grayColor];
    self.privacyConsentIndicator.backgroundColor = [self colourForState:[ConsentSDK consentStateFor:CSDKConsentPrivacy]];
    self.analyticsConsentIndicator.backgroundColor = [self colourForState:[ConsentSDK consentStateFor:CSDKConsentAnalytics]];
}

- (IBAction)buttonAction:(id)sender {
    [ConsentSDK showWithCallback:^{
        [self updateConsentIndicators];
        if ([ConsentSDK consentStateFor:CSDKConsentAnalytics] != CSDKConsentStateProvided) {
            // stop analytics tools
        };

    }];
}

@end
