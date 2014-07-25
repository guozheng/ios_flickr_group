//
//  AppDelegate.h
//  ios_flickr_group
//
//  Created by Li Li on 7/17/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "logInViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) logInViewController *loginVC;
@property (strong, nonatomic) UINavigationController *myGroupsNVC;
@property (strong, nonatomic) UIViewController *currentVC;

@end
