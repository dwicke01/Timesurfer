
#import "AppDelegate.h"
#import "TSViewController.h"
#import "TSGoogleCalendarManager.h"
#import "TSEventManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *dateKey = @"dateKey";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSDate *lastRead  = (NSDate *)[defaults objectForKey:dateKey];
    

    
    if (lastRead == nil)
    {
        NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:[NSDate date], dateKey, nil];
        
        
        [defaults setBool:NO forKey:@"tempInC"];
        [defaults setBool:NO forKey:@"signedInToGoogle"];
        [defaults setBool:YES forKey:@"airplaneAnimation"];
        [defaults setBool:YES forKey:@"allAnimations"];
        [defaults setBool:YES forKey:@"catsAndDogsAnimation"];
        [defaults setBool:YES forKey:@"helicopterAnimation"];
        [defaults setBool:YES forKey:@"sheepAnimation"];
        [defaults setBool:YES forKey:@"squirrelAnimation"];
        [defaults setBool:NO forKey:@"appleCalendar"];
        [defaults setBool:NO forKey:@"googleCalendar"];
        [defaults setBool:NO forKey:@"eventsAccessRequested"];
        [defaults setBool:NO forKey:@"eventsAccessGranted"];
        
        [defaults registerDefaults:appDefaults];
        [defaults synchronize];
    }
    [defaults setObject:[NSDate date] forKey:dateKey];
    
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults boolForKey:@"eventsAccessRequested"]) {
        [[TSEventManager sharedEventManger] fetchEvents];
    }
    
    if ([defaults boolForKey:@"signedInToGoogle"]) {
        TSGoogleCalendarManager *googleCalendarManager = [[TSGoogleCalendarManager alloc] initWithDelegate:nil];
        [googleCalendarManager authorizeWithCalendarDelegate:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
}

@end
