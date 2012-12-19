//
//  AppDelegate.h
//  ZenLegacy
//
//  Created by John Parron on 12/15/12.
//  Copyright (c) 2012 John Parron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZAuthor;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *_window;
    UINavigationController *_navController;
    
    AZAuthor *_currentUser;;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;

@property (nonatomic, retain) AZAuthor *currentUser;

@end