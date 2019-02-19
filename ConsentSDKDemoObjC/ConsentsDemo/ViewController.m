//
//  ViewController.m
//  ConsentSDKDemoObjC
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

#import "ViewController.h"
#import <SmartlookConsentSDK/SmartlookConsentSDK.h>

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
    [consentsSettingsDefaults addObjectsFromArray:@[SLCConsentPrivacy, @(SLCConsentStateProvided)]];
    [consentsSettingsDefaults addObjectsFromArray:@[SLCConsentAnalytics, @(SLCConsentStateNotProvided)]];

    [SmartlookConsentSDK checkWith:consentsSettingsDefaults callback:^{
        [self updateConsentIndicators];
        if ([SmartlookConsentSDK consentStateFor:SLCConsentAnalytics] == SLCConsentStateProvided) {
            // start analytics tools
        };
    }];
}

- (UIColor *)colourForState:(SLCConsentState)state {
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
    self.privacyConsentIndicator.backgroundColor = [self colourForState:[SmartlookConsentSDK consentStateFor:SLCConsentPrivacy]];
    self.analyticsConsentIndicator.backgroundColor = [self colourForState:[SmartlookConsentSDK consentStateFor:SLCConsentAnalytics]];
}

- (IBAction)buttonAction:(id)sender {
    [SmartlookConsentSDK showWithCallback:^{
        [self updateConsentIndicators];
        if ([SmartlookConsentSDK consentStateFor:SLCConsentAnalytics] != SLCConsentStateProvided) {
            // stop analytics tools
        };

    }];
}

@end
