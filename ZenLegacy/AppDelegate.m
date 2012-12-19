//
//  AppDelegate.m
//  ZenLegacy
//
//  Created by John Parron on 12/15/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import "AppDelegate.h"

#import "AZProjectListViewController.h"

#import "AZRequest.h"
#import "AZAuthor.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize navController = _navController;

@synthesize currentUser = _currentUser;

- (void)dealloc
{
    [_currentUser release];
    [_navController release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Fetch the users info to detch which comments can be deleted
    
    AZRequest *request = [[AZRequest alloc] initWithURL:[NSURL URLWithString:@"https://agilezen.com/api/v1/me"]];
    
    [request performRequestWithHandler:^(AZRequest *request, NSData *responseData, NSError *error){
        
        if (responseData)
        {
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
            if (responseObject)
            {
                _currentUser = [[AZAuthor alloc] initWithJSONObject:responseObject];
                
                AZProjectListViewController *rootViewController = (AZProjectListViewController *)[[_navController viewControllers] objectAtIndex:0];
                
                [rootViewController updateTitle];
            }
        }
        
        [request release];
    }];
    
    // Start loading the UI
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    _window.backgroundColor = [UIColor blackColor];
    
    AZProjectListViewController *rootViewController = [[AZProjectListViewController alloc] init];
    
    _navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    
    [rootViewController release];
    
    [_window setRootViewController:_navController];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self updateSessionDates];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Private Methods

- (void)updateSessionDates
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:@"currentSessionDate"] != nil)
    {
        [userDefaults setObject:[userDefaults objectForKey:@"currentSessionDate"] forKey:@"previousSessionDate"];
    }
    
    [userDefaults setObject:[NSDate date] forKey:@"currentSessionDate"];
    
    [userDefaults setBool:NO forKey:@"kConversationsUpdated"];
    
    [userDefaults synchronize];
}

@end