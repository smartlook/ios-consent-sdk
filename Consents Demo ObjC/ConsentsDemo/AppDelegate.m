//
//  AppDelegate.m
//  ConsentSDKDemoObjC
//
//  Created by Pavel Kroh on 15/02/2019.
//  Copyright © 2019 Smartlook. All rights reserved.
//

#import "AppDelegate.h"
#import <SmartlookConsentSDK/SmartlookConsentSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

/** This method is to be invoked any time the app starts to check if the consets are provided
 namely in:
 - `application:didFinishWithLaunchingOptions` for the fresh start
 - `application:WillEnterForeground` for app woken up from background (where possibly the consent setting could be changed in system sessings)
 */
-(void)checkConsentStates {
    NSMutableArray *consentsSettingsDefaults = [NSMutableArray new];
    [consentsSettingsDefaults addObjectsFromArray:@[SLCConsentPrivacy, @(SLCConsentStateProvided)]];
    [consentsSettingsDefaults addObjectsFromArray:@[SLCConsentAnalytics, @(SLCConsentStateNotProvided)]];
    
    [SmartlookConsentSDK checkWith:consentsSettingsDefaults callback:^{
        if ([SmartlookConsentSDK consentStateFor:SLCConsentAnalytics] == SLCConsentStateProvided) {
            // start analytics tools
        };
    }];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch;
    [self checkConsentStates];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [self checkConsentStates];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
