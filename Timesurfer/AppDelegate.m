//
//  AppDelegate.m
//  Timesurfer
//
//  Created by Jordan Guggenheim on 6/24/15.
//  Copyright (c) 2015 gugges. All rights reserved.
//

#import "AppDelegate.h"
#import "TSViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *dateKey = @"dateKey";
    NSDate *lastRead  = (NSDate *)[[NSUserDefaults standardUserDefaults] objectForKey:dateKey];
    if (lastRead == nil)
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"tempInC"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"airplaneAnimation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"allAnimations"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"catsAndDogsAnimation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"helicopterAnimation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"sheepAnimation"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"squirrelAnimation"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"googleCalendar"];
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:dateKey];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appEnteredBackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appEnteredForeground" object:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
